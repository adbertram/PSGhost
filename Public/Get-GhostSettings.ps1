function Get-GhostSettings {
    [OutputType('pscustomobject')]
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    ()

    $ErrorActionPreference = 'Stop'

    $invParams = @{
        Api      = 'content'
        Endpoint = 'settings'
    }
    Invoke-GhostApiCall @invParams
}