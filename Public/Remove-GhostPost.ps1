function Remove-GhostPost {
  [OutputType('pscustomobject')]
  [CmdletBinding(DefaultParameterSetName = 'None')]
  param
  (
      [Parameter()]
      [ValidateNotNullOrEmpty()]
      [string]$Id,

      [Parameter()]
      [ValidateNotNullOrEmpty()]
      [switch]$PassThru
  )

  $ErrorActionPreference = 'Stop'

  $endPointLabel = 'posts'

  $invParams = @{
    Endpoint = "$endPointLabel/$Id"
    Method   = 'DELETE'
  }

  $result = Invoke-GhostApiCall @invParams
  if ($PassThru.IsPresent) {
      $result
  }
}