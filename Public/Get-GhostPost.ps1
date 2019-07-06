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
        [string]$Slug,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Title
    )

    $ErrorActionPreference = 'Stop'

    $invParams = @{
        Api = 'content'
    }
    if ($PSBoundParameters.Keys -notcontains 'Id' -and $PSBoundParameters.Keys -notcontains 'Id') {
        $invParams.Endpoint = 'posts'
    } elseif ($PSBoundParameters.ContainsKey('Id')) {
        $invParams.Endpoint = "posts/$Id"
    } elseif ($PSBoundParameters.ContainsKey('Slug')) {
        $invParams.Endpoint = "posts/slug/$Slug"
    }
    $result = Invoke-GhostApiCall @invParams
    
    ## Filter posts locally for all other filter criteria
    if ($result) {
        if ($PSBoundParameters.ContainsKey('Title')) {
            @($result).where({ $_.title -eq $Title })
        }
    }
}