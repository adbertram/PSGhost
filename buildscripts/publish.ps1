$ErrorActionPreference = 'Stop'

try {
    ## Don't upload the build scripts and appveyor.yml to PowerShell Gallery
    $tempmoduleFolderPath = "$env:Temp\$env:APPVEYOR_PROJECT_NAME"
    $null = mkdir $tempmoduleFolderPath

    ## Remove all of the files/folders to exclude out of the main folder
    $excludeFromPublish = @(
        "$env:APPVEYOR_PROJECT_NAME\\buildscripts"
        "$env:APPVEYOR_PROJECT_NAME\\appveyor\.yml"
        "$env:APPVEYOR_PROJECT_NAME\\\.git"
        "$env:APPVEYOR_PROJECT_NAME\\\.nuspec"
        "$env:APPVEYOR_PROJECT_NAME\\README\.md"

    )
    $exclude = $excludeFromPublish -join '|'
    Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER -Recurse | where { $_.FullName -match $exclude } | Remove-Item -Force -Recurse

    ## Publish module to PowerShell Gallery
    $publishParams = @{
        Path        = $env:APPVEYOR_BUILD_FOLDER
        NuGetApiKey = $env:nuget_apikey
        Repository  = 'PSGallery'
        Force       = $true
        Confirm     = $false
    }
    Publish-Module @publishParams

} catch {
    Write-Error -Message $_.Exception.Message
    $host.SetShouldExit($LastExitCode)
}