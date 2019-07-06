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
        [string]$ApiKey,

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Format,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Include,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]$Filter
    )

    $ErrorActionPreference = 'Stop'

    try {

        $config = Get-GhostConfiguration
        if (-not $PSBoundParameters.ContainsKey('ApiKey')) {
            switch ($Api) {
                'content' {
                    $ApiKey = $config.ContentApiKey
                    break
                }
                'admin' {
                    $ApiKey = $config.AdminApiKey
                    break
                }
                default {
                    throw "Unrecognized APIKey: [$_]"
                }
            }
        }

        if (-not (Get-Variable -Name ghostSession -Scope Script -ErrorAction Ignore)) {
            Set-GhostSession
        }

        $invParams = @{
            Headers     = @{ 'Origin' = $config.ApiUrl }
            ContentType = 'application/json'
            WebSession  = $script:ghostSession
            Method      = $Method
        }

        $request = [System.UriBuilder]"$ApiUrl/ghost/api/v2/$Api/$Endpoint"

        $queryParams = @{
            'key' = $ApiKey
        }
        if ($PSBoundParameters.ContainsKey('Format')) {
            $queryParams.Formats = $Format -join ','
        }
        if ($PSBoundParameters.ContainsKey('Include')) {
            $queryParams.Include = $Include -join ','
        }
        if ($PSBoundParameters.ContainsKey('Filter')) {
            $queryParams.Filter = New-Filter -Filter $Filter
        }

        $params = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        foreach ($queryParam in $queryParams.GetEnumerator()) {
            $params[$queryParam.Key.ToLower()] = $queryParam.Value
        }
        $request.Query = $params.ToString()
        $invParams.Uri = $request.Uri

        if ($Body) {
            $invParams.Body = (@{ $Endpoint = $Body } | ConvertTo-Json)
        }
        
        Invoke-RestMethod @invParams
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}