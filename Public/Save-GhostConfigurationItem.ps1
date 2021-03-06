function Save-GhostConfigurationItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('ContentApiKey', 'AdminApiKey', 'ApiUrl', 'UserName', 'UserPassword')]
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

    $config = Get-Content -Path $script:configFilePath -Raw | ConvertFrom-Json

    if ($Label -in $script:configItemsToEncrypt) {
        $Value = encrypt $Value
    }
    $config.$Label = $Value

    $config | ConvertTo-Json | Set-Content -Path $script:configFilePath
}