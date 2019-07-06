# PSGhost - Manage your Ghost Blog with PowerShell

## Setup Instructions

1. Download PSGhost from the PowerShell Gallery (`Install-Module PSGhost`)
1. Create a custom integration for Ghost. https://ghost.org/integrations/custom-integrations/#add-a-new-custom-integration
2. Find your API keys in the Ghost console from your custom integration at https://%account-name%.ghost.io/ghost/#/settings/integrations.
3. Save all API keys and the API URL to your local configuration. This command saves your API keys encrypted to _%LOCALAPPDATA%\PSGhost\configuration.json_
  ```PowerShell
  Save-GhostConfigurationItem -Label ContentApiKey -Value 'XXXXXXXXX'
  Save-GhostConfigurationItem -Label AdminApiKey -Value 'XXXXXXXX'
  Save-GhostConfigurationItem -Label ApiUrl -Value 'https://<account-name>.ghost.io'
  Save-GhostConfigurationItem -Label UserName -Value 'XXXXXX'
  Save-GhostConfigurationItem -Label UserPassword -Value 'XXXXXXXX'
  ```
4. Run `Get-GhostConfiguration` to ensure all API keys are returned decrypted.
5. Run a command to ensure no errors are returned: `Get-GhostSettings`.

## FYI: Only tested on Ghost(Pro)
