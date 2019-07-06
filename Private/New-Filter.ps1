function New-Filter {
    [OutputType('string')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$Filter
    )

    $ErrorActionPreference = 'Stop'
 
    ## Only one element supported now
    $stringElements = @('title')
    if ($Filter.Keys -in $stringElements) {
        $val = "'$($Filter.Values)'"
    } else {
        $val = $Filter.Values
    }
    "$($Filter.Keys):$val"
}