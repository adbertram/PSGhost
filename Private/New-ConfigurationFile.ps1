function New-ConfigurationFile {
    [CmdletBinding()]
    param
    (
        
    )

    $ErrorActionPreference = 'Stop'

    $configFileFolderPath = $script:configFilePath | Split-Path -Parent
    if (-not (Test-Path -Path $configFileFolderPath -PathType Container)) {
        $null = New-Item -Path $configFileFolderPath -ItemType 'Directory'
    }

    if (-not (Test-Path -Path $script:configFilePath -PathType Leaf)) {
        Copy-Item -Path $script:configTemplateFilePath -Destination "$configFileFolderPath\configuration.json"
    }
}