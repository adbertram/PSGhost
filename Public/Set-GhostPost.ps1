function Set-GhostPost {
    [OutputType('pscustomobject')]
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$Post,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Excerpt,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Html,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$MobileDoc,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$PassThru
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'posts'

    $invParams = @{
        Endpoint = "$endPointLabel/$($Post.id)"
        Method   = 'PUT'
    }

    $body = @{ 'updated_at' = $Post.updated_at }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $body.title = $Title
    }
    if ($PSBoundParameters.ContainsKey('Excerpt')) {
        $body.custom_excerpt = $Excerpt
    }
    if ($PSBoundParameters.ContainsKey('Html')) {
        $invParams.Source = 'html'
        $body.html = $Html
    }
    if ($PSBoundParameters.ContainsKey('MobileDoc')) {
        $body.mobiledoc = $MobileDoc
    }
    $invParams.Body = $body
    
    $result = Invoke-GhostApiCall @invParams
    if ($PassThru.IsPresent) {
        $result
    }
}