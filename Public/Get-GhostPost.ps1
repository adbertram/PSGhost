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
        [string]$Title,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('authors', 'tags')]
        [string[]]$Include,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$Page
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'posts'

    $invParams = @{ }    
    if ($PSBoundParameters.ContainsKey('Id')) {
        $invParams.Endpoint = "$endPointLabel/$Id"
    } elseif ($PSBoundParameters.ContainsKey('Slug')) {
        $invParams.Endpoint = "$endPointLabel/slug/$Slug"
    } else {
        $invParams.Endpoint = $endPointLabel
    }

    if ($PSBoundParameters.ContainsKey('Page')) {
        $invParams.Body = @{ 'page' = $Page }
    }
    if ($PSBoundParameters.ContainsKey('Include')) {
        $invParams.Include = $Include
    }
    if ($PSBoundParameters.ContainsKey('Title')) {
        $invParams.Filter = @{ 'title' = $Title }
    }


    $pageResult = Invoke-GhostApiCall @invParams
    if ($pageResult.$endPointLabel) {
        $pageResult.$endPointLabel

        if ($pageResult.PSObject.Properties.Name -contains 'meta' -and $pageResult.meta.pagination.next) {
            $getParams = $PSBoundParameters
            $getParams['Page'] = $pageResult.meta.pagination.next
            Get-GhostPost @getParams
        }
    }
}