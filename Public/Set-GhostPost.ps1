function Set-GhostPost {
    [OutputType('pscustomobject')]
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$Post,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Html,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$PassThru
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'posts'

    $invParams = @{
        Endpoint = "$endPointLabel/$($Post.id)"
        Method = 'PUT'
    }

    $body = @{ 'updated_at' = $Post.updated_at }

    if ($PSBoundParameters.ContainsKey('Title')) {
        $body.title = $Title
    }
    if ($PSBoundParameters.ContainsKey('Html')) {
        $invParams.Source = 'html'
        $body.html = $Html
    }
    $invParams.Body = $body
    
    $result = Invoke-GhostApiCall @invParams
    if ($PassThru.IsPresent) {
        $result
    }
}