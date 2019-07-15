function Set-GhostSession {
    [CmdletBinding()]
    param
    ()

    $ErrorActionPreference = 'Stop'

    $config = Get-GhostConfiguration
    $invParams = @{
        Headers         = @{ 'Origin' = $config.ApiUrl }
        Body            = @{'username' = $config.UserName; 'password' = $config.UserPassword }
        Uri             = "$($config.ApiUrl)/ghost/api/v2/admin/session/"
        SessionVariable = 'session'
        Method          = 'POST'
    }
    $null = Invoke-RestMethod @invParams
    $script:ghostSession = $session
}