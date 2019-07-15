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

    $fileBytes = [System.IO.File]::ReadAllBytes($FilePath);
    $fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes);
    $boundary = [System.Guid]::NewGuid().ToString(); 
    $LF = "`r`n";

    $fileName = (Get-Item -Path $FilePath).Name
    $body = ( 
        "--$boundary",
        "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"",
        "Content-Type: application/octet-stream$LF",
        # $fileEnc,
        "--$boundary--$LF" 
    ) -join $LF

    $config = Get-GhostConfiguration
    $invParams = @{
        'Method'      = 'POST'
        'ContentType' = "multipart/form-data; boundary=`"$boundary`""
        'Uri'         = "$($config.ApiUrl)/ghost/api/v2/admin/images/upload"
        'Headers'     = @{ 'Origin' = $config.ApiUrl }
        'Body'        = $body
        'WebSession'  = $script:ghostSession
    }
    
    Invoke-RestMethod @invParams
}

