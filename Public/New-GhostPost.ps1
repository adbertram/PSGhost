function New-GhostPost {
    [OutputType('void')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Markdown')]
        [string]$Format,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Body,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Tag,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$AuthorId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('draft', 'published')]
        [string]$Status = 'draft',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [switch]$PassThru
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'posts'

    $postBody = @{
        status = $Status
        title  = $Title
    }
    if ($Format -eq 'Markdown') {
        $mobileDoc = [ordered]@{
            version  = '0.3.1'
            atoms    = @()
            cards    = @(, @('markdown', [ordered]@{ cardName = 'markdown'; markdown = $Body }))
            markups  = @()
            sections = @(, @(10, 0))
        }
        $postBody.mobiledoc = $mobileDoc
    }

    if ($PSBoundParameters.ContainsKey('Tags')) {
        $postBody.Tags = @($Tag)
    }
    if ($PSBoundParameters.ContainsKey('AuthorId')) {
        $authors = @()
        $AuthorId | foreach { $authors += @{ 'id' = $_ } }
        $postBody.authors = $authors
    }

    $invParams = @{
        Endpoint = $endPointLabel
        Method   = 'POST'
        Body     = $postBody
    }
    
    $result = Invoke-GhostApiCall @invParams
    if ($PassThru.IsPresent) {
        $result
    }
}