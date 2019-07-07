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
        [hashtable]$Filter
    )

    $ErrorActionPreference = 'Stop'

    try {

        $baseEndpoint = $Endpoint.split('/')[0]

        $config = Get-GhostConfiguration

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

        $queryParams = @{}
        if ($PSBoundParameters.ContainsKey('Format')) {
            $queryParams.Formats = $Format -join ','
        }
        if ($PSBoundParameters.ContainsKey('Include')) {
            $queryParams.Include = $Include -join ','
        }
        if ($PSBoundParameters.ContainsKey('Filter')) {
            $queryParams.Filter = New-Filter -Filter $Filter
        }
        if ($PSBoundParameters.ContainsKey('Source')) {
            $queryParams.Source = $Source
        }
        if ($PSBoundParameters.ContainsKey('Page')) {
            $queryParams.Page = $Page
        }

        $params = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        foreach ($queryParam in $queryParams.GetEnumerator()) {
            $params[$queryParam.Key.ToLower()] = $queryParam.Value
        }
        $request.Query = $params.ToString()
        $invParams.Uri = $request.Uri

        if ($Body) {
            $invParams.Body = (@{$baseEndpoint = @($Body) } | ConvertTo-Json)
        }
        
        Invoke-RestMethod @invParams
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}