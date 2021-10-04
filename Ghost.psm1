Set-StrictMode -Version Latest

$script:configFilePath = Join-Path -Path '~' -ChildPath 'PSGhost-configuration.json'
$script:configTemplateFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'configuration_template.json'
$script:configItemsToEncrypt = 'ContentApiKey', 'AdminApiKey', 'UserPassword'

## Prevents "The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel"
[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Get public and private function definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files.
foreach ($import in @($Public + $Private)) {
    try {
        Write-Verbose "Importing $($import.FullName)"
        . $import.FullName
    } catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}

foreach ($file in $Public) {
    Export-ModuleMember -Function $file.BaseName
}