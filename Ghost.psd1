@{
    RootModule        = 'Ghost.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '3b4869fa-45a9-41a1-a412-bd07c84559dc'
    Author            = 'Adam Bertram'
    CompanyName       = 'Adam the Automator, LLC'
    Copyright         = '(c) 2017 Adam Bertram. All rights reserved.'
    Description       = "This module is used to interact with the blogging platform, Ghost's API."
    PowerShellVersion = '6.0'
    FunctionsToExport = '*'
    CmdletsToExport   = '*'
    VariablesToExport = '*'
    AliasesToExport   = '*'
    PrivateData       = @{
        PSData = @{
            Tags       = @('PSModule', 'Ghost')
            ProjectUri = 'https://github.com/adbertram/PSGhost'
        }
    }
}
