function Get-GhostUser {
    [OutputType('pscustomobject')]
    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName = 'ByEmail')]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress
    )

    $ErrorActionPreference = 'Stop'

    $endPointLabel = 'users'

    $invParams = @{
        Endpoint = $endPointLabel
    }

    $result = Invoke-GhostApiCall @invParams
    
    if ($result.$endPointLabel) {
        $whereFilter = { '*' }
        if ($PSBoundParameters.ContainsKey('EmailAddress')) {
            ## using where here since no docs on how to limit by username
            $whereFilter = { $_.email -eq $EmailAddress }
        }
        $result.$endPointLabel | Where-Object -FilterScript $whereFilter
    }
}