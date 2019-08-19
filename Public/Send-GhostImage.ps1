function Send-GhostImage {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath
    )

    $ErrorActionPreference = 'Stop'

    if (-not (Get-Variable -Name ghostSession -Scope Script -ErrorAction Ignore)) {
        Set-GhostSession
    }

    $config = Get-GhostConfiguration

    $Params = @{
        'Method'      = 'POST'
        'Uri'         = "$($config.ApiUrl)/ghost/api/v2/admin/images/upload/"
        'Form'        = @{
            "file" = Get-Item -Path $FilePath
            "ref"  = (Get-Item -Path $FilePath).Name
            "purpose" = 'image'
        }
        "WebSession" = $ghostSession
    }
    
    Invoke-RestMethod @Params
}