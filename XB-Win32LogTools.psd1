@{
    RootModule        = 'XB-Win32LogTools.psm1'
    ModuleVersion     = '1.0.1'
    GUID              = 'c15a9b21-a89f-4c00-9005-3d6e96402c58'
    Author            = 'Kristian Holm Buch'
    CompanyName       = 'NexaBlue'
    Copyright         = '(c) 2025 - Kristian Holm Buch. All rights reserved.'
    Description       = 'Advanced Sysmon Log Management Toolkit'
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')
    RequiredModules   = @('PSScriptAnalyzer', 'PlatyPS', 'Pester')
    FunctionsToExport = @(
        'Export-XBWin32Log',
        'Get-XBWin32FileEvents',
        'Get-XBWin32LogDetails',
        'Get-XBWin32NetworkEvents',
        'Get-XBWin32ProcessEvents',
        'Get-XBWin32Timeline',
        'New-XBWin32ScheduledExportTask',
        'Set-XBWin32AuditPolicyWizard'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    Tags              = @('Sysmon', 'EventLog', 'Security', 'Logging', 'Export', 'Audit')
    ProjectUri        = 'https://github.com/kristianbuch/XBCore.Win32LogTools'
    HelpInfoUri       = 'https://github.com/kristianbuch/XBCore.Win32LogTools'
    PrivateData       = @{
    }
}
