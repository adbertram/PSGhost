function Save-GhostConfigurationItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('ContentApiKey', 'AdminApiKey', 'ApiUrl')]
        [string]$Label,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )

    function encrypt([string]$TextToEncrypt) {
        $secure = ConvertTo-SecureString $TextToEncrypt -AsPlainText -Force
        $encrypted = $secure | ConvertFrom-SecureString
        return $encrypted
    }

    New-ConfigurationFile

    $config = Get-Content -Path $configFilePath -Raw | ConvertFrom-Json

    if ($Label -in $configItemsToEncrypt) {
        $Value = encrypt $Value
    }
    $config.$Label = $Value

    $config | ConvertTo-Json | Set-Content -Path $configFilePath
}