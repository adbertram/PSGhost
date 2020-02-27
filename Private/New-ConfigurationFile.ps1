function New-ConfigurationFile {
    [CmdletBinding()]
    param
    (
        
    )

    $ErrorActionPreference = 'Stop'

    $configFileFolderPath = $script:configFilePath | Split-Path -Parent
    $script:configTemplateFilePath

    if (-not (Test-Path -Path $script:configFilePath -PathType Leaf)) {
        Write-Verbose -Message "Creating new configuration file..."
        Copy-Item -Path $script:configTemplateFilePath -Destination (Join-Path -Path $configFileFolderPath -ChildPath 'configuration.json')
    }
}