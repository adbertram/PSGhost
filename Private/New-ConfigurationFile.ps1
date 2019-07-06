function New-ConfigurationFile {
    [CmdletBinding()]
    param
    (
        
    )

    $ErrorActionPreference = 'Stop'

    $configFileFolderPath = $configFilePath | Split-Path -Parent
    if (-not (Test-Path -Path $configFileFolderPath -PathType Container)) {
        $null = New-Item -Path $configFileFolderPath -ItemType 'Directory'
    }

    if (-not (Test-Path -Path $configFilePath -PathType Leaf)) {
        Copy-Item -Path $configTemplateFilePath -Destination "$configFileFolderPath\configuration.json"
    }
}