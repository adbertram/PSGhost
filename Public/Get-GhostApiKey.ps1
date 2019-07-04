function Get-GhostApiKey {
    <#
		.SYNOPSIS
			Queries the API key configuration to return the API key set earlier via the Save-GhostApiKey command.
	
		.EXAMPLE
			PS> Get-GhostApiKey

			This example pulls the API key from the configuration file.

	
	#>
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

    try {
        $atKey = decrypt $encApiKey
        $script:GhostApiKey = $atKey
        $script:GhostApiKey
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}