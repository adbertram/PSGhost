function Get-GhostPost {
    [OutputType('pscustomobject')]
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(ParameterSetName = 'BySlug')]
        [ValidateNotNullOrEmpty()]
        [string]$Slug
    )

    $ErrorActionPreference = 'Stop'

    $invParams = @{
        Api = 'content'
    }
    if ($PSBoundParameters.Keys.Count -eq 0) {
        $invParams.Endpoint = 'posts'
    } elseif ($PSBoundParameters.ContainsKey('Id')) {
        $invParams.Endpoint = "posts/$Id"
    } elseif ($PSBoundParameters.ContainsKey('Slug')) {
        $invParams.Endpoint = "posts/slug/$Slug"
    }
    Invoke-GhostApiCall @invParams
}