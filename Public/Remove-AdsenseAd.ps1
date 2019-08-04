function Remove-AdsenseAd {
    [OutputType('void')]
    [CmdletBinding(DefaultParameterSetName = 'AllAds')]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$Post,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AdsenseCode,

        [Parameter(Mandatory, ParameterSetName = 'FirstAd')]
        [ValidateNotNullOrEmpty()]
        [int]$First,

        [Parameter(Mandatory, ParameterSetName = 'LastAd')]
        [ValidateNotNullOrEmpty()]
        [int]$Last,

        [Parameter(Mandatory, ParameterSetName = 'AllAds')]
        [ValidateNotNullOrEmpty()]
        [switch]$All,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('html', 'mobiledoc')]
        [string]$Format = 'mobiledoc'
    )

    $ErrorActionPreference = 'Stop'

    $removeString = "<!--kg-card-begin: html-->$($AdsenseCode -replace '\n','|||n')<!--kg-card-end: html-->"

    if ($Format -ne 'mobiledoc') {
        throw "The [$($Format)] is not currently supported. Please use mobiledoc."
    }

    $objmobiledoc = $Post.mobiledoc | ConvertFrom-Json
    $objmobiledoc.cards = $objmobiledoc.cards | ? { -not ($_[1] | ? { ($_.html -replace '\s', '') -eq ($adsensecode -replace '\s', '') }) }
    if (-not $objmobiledoc.cards) {
        $objmobiledoc.cards = , @()
    }

    $mobileDoc = $objmobiledoc | ConvertTo-Json -Depth 100 -Compress

    Set-GhostPost -Post $Post -MobileDoc $mobileDoc
}