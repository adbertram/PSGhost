function Get-WordCount {
    [OutputType('int')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$Post
    )

    $ErrorActionPreference = 'Stop'


    $wordCount = 0
    foreach ($section in ($Post.mobiledoc | ConvertFrom-Json).sections) {
        if ($text = $section[-1] | where { $_[-1] -is 'string' } | foreach { $_[-1] }) {
            $wordCount += $text.split(' ').Count
        }
    }
    $wordCount
}