function Invoke-GhostApiCall {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('content', 'admin')]
        [string]$Api = 'admin',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Method = 'GET',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ApiUrl = (Get-GhostConfiguration).ApiUrl,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]$HttpParameters = @{ },

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Format,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$Page,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('html')]
        [string]$Source,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Include,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ContentType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]$Filter
    )

    $ErrorActionPreference = 'Stop'

    try {

        ## Prevents "The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel"
        [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $baseEndpoint = $Endpoint.split('/')[0]

        $config = Get-GhostConfiguration

        if (-not (Get-Variable -Name ghostSession -Scope Script -ErrorAction Ignore)) {
            Set-GhostSession
        }

        $ivrParams = @{
            Headers    = @{ 'Origin' = $config.ApiUrl }
            WebSession = $script:ghostSession
            Method     = $Method
        }
        if ($PSBoundParameters.ContainsKey('ContentType')) {
            $ivrParams.ContentType = $ContentType
        } else {
            $ivrParams.ContentType = 'application/json'
        }

        $request = [System.UriBuilder]"$ApiUrl/ghost/api/v2/$Api/$Endpoint"
        
        if ($PSBoundParameters.ContainsKey('Format')) {
            $HttpParameters.Formats = $Format -join ','
        }
        if ($PSBoundParameters.ContainsKey('Include')) {
            $HttpParameters.Include = $Include -join ','
        }
        if ($PSBoundParameters.ContainsKey('Filter')) {
            $HttpParameters.Filter = New-Filter -Filter $Filter
        }
        if ($PSBoundParameters.ContainsKey('Source')) {
            $HttpParameters.Source = $Source
        }
        if ($PSBoundParameters.ContainsKey('Page')) {
            $HttpParameters.Page = $Page
        }

        $params = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        foreach ($queryParam in $HttpParameters.GetEnumerator()) {
            $params[$queryParam.Key.ToLower()] = $queryParam.Value
        }
        $request.Query = $params.ToString()
        $ivrParams.Uri = $request.Uri

        if ($Body) {
            if ($Body.ContainsKey('mobiledoc')) {
                $bodyFixed = $Body.mobiledoc
                if ($bodyFixed -isnot 'string') {
                    $bodyFixed = $bodyFixed | ConvertTo-Json -Depth 100 -Compress
                }
            } elseif ($Body.ContainsKey('html')) {
                $bodyFixed = $Body.html
            } else {
                $bodyFixed = $Body
            }

            ## replace smart quotes
            $smartSingleQuotes = '[\u2019\u2018]'
            $smartDoubleQuotes = '[\u201C\u201D]'

            $bodyFixed = $bodyFixed -replace $smartSingleQuotes, "'" -replace $smartDoubleQuotes, '"' -replace '“', '"' -replace '“', '"'
            if ($Body.ContainsKey('mobiledoc')) {
                $Body.mobiledoc = $bodyFixed
            } elseif ($Body.ContainsKey('html')) {
                $Body.html = $bodyFixed
            }

            $ivrParams.Body = @{$baseEndpoint = @($Body) } | ConvertTo-Json -Depth 100
        }
        
        Invoke-RestMethod @ivrParams
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}