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
        [int]$Page
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'posts'

    $invParams = @{
        Api = 'content'
    }
    if ($PSBoundParameters.Keys -notcontains 'Id' -and $PSBoundParameters.Keys -notcontains 'Id') {
        $invParams.Endpoint = $endPointLabel
    } elseif ($PSBoundParameters.ContainsKey('Id')) {
        $invParams.Endpoint = "$endPointLabel/$Id"
    } elseif ($PSBoundParameters.ContainsKey('Slug')) {
        $invParams.Endpoint = "$endPointLabel/slug/$Slug"
    }

    if ($PSBoundParameters.ContainsKey('Page')) {
        $invParams.Body = @{ 'page' = $Page }
    }
    $pageResult = Invoke-GhostApiCall @invParams
    $whereFilter = { '*' }
    if ($PSBoundParameters.ContainsKey('Title')) {
        $whereFilter = { $_.title -eq $Title }
    }
    @($pageResult.$endPointLabel).where($whereFilter)
    
    if ($pageResult.meta.pagination.next) {
        $getParams = $PSBoundParameters
        $getParams['Page'] = $pageResult.meta.pagination.next
        Get-GhostPost @getParams
    }
}