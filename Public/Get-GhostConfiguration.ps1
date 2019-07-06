function Get-GhostConfiguration {
    [CmdletBinding()]
    param
    ()
	
    $ErrorActionPreference = 'Stop'

    function decrypt([string]$TextToDecrypt) {
        $secure = ConvertTo-SecureString $TextToDecrypt
        $hook = New-Object system.Management.Automation.PSCredential("test", $secure)
        $plain = $hook.GetNetworkCredential().Password
        return $plain
    }

    $config = Get-Content -Path $configFilePath -Raw | ConvertFrom-Json
    foreach ($item in $config.PSObject.Properties) {
        if ($item.Name -in $configItemsToEncrypt) {
            $config.($item.Name) = decrypt $item.Value
        } else {
            $config.($item.Name) = $item.Value
        }
    }
    $config
}