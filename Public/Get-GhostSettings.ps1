function Get-GhostSettings {
    [OutputType('pscustomobject')]
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    ()

    $ErrorActionPreference = 'Stop'

    $invParams = @{
        Endpoint = 'settings'
    }
    (Invoke-GhostApiCall @invParams).settings
}