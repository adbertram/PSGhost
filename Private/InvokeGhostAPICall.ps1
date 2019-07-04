function InvokeGhostAPICall {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('posts')]
        [string]$Endpoint,

        [Parameter(Mandatorr)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('content', 'admin')]
        [string]$Api,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUrl,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey
    )

    $ErrorActionPreference = 'Stop'

    if ($PSBoundParameters.ContainsKey('SiteUrl')) {
        ## get from config
    }

    $invParams = @{
        Uri = "$SiteUrl/ghost/api/v2/$Api/$Endpoint/?key=$ApiKey"
    }
    throw 'finish this'
    
}