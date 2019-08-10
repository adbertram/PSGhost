function Get-GhostUser {
    [OutputType('pscustomobject')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'ByEmail')]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddreess
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'users'

    $invParams = @{
        Endpoint       = $endPointLabel
        HttpParameters = @{ 'userName' = $EmailAddreess }
    }

    $result = Invoke-GhostApiCall @invParams
    $result.$endPointLabel
}