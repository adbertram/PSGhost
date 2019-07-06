function Invoke-GhostApiCall {
    <#
        .SYNOPSIS
            Main function that all public-facing functions use to call the APIs.

        .PARAMETER Endpoint
            Mandatory parameter for the API endpoint. Available options can be found here: https://docs.ghost.org/api/content/#endpoints
        
        .PARAMETER Api
            Mandatory parameter that can be content or admin.

        .PARAMETER ApiUrl
            Optional parameter. If this isn't used, it's value will be attempted to be found in the configuration.json.
        
        .PARAMETER ApiKey
            Optional parameter. If this isn't used, it's value will be attempted to be found in the configuration.json.
    
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Endpoint,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('content', 'admin')]
        [string]$Api,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ApiUrl = (Get-GhostConfiguration).ApiUrl,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey
    )

    $ErrorActionPreference = 'Stop'

    try {
        if (-not $PSBoundParameters.ContainsKey('ApiKey')) {
            switch ($Api) {
                'content' {
                    $ApiKey = (Get-GhostConfiguration).ContentApiKey
                    break
                }
                'admin' {
                    $ApiKey = (Get-GhostConfiguration).AdminApiKey
                    break
                }
                default {
                    throw "Unrecognized APIKey: [$_]"
                }
            }
        }

        $invParams = @{
            Uri = "$ApiUrl/ghost/api/v2/$Api/$Endpoint/?key=$ApiKey"
        }
        $result = Invoke-RestMethod @invParams

        $returnType = $Endpoint.split('/')[0]
        $result.$returnType
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}