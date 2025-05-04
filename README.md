# XB-Win32LogTools

A professional PowerShell module for analyzing and exporting Windows Event Logs – especially Sysmon. Includes log timeline generation, scheduled exports, network/file tracking, and audit policy configuration.

## ✨ Features
- Export logs as `.evtx` or `.json`
- View process, file, and network activity by user
- Build forensic timelines
- Schedule automatic exports
- Configure Windows and Sysmon auditing
- PlatyPS-compatible help
- Supports Pester, PSDepend, ScriptAnalyzer

## 🛠 Requirements
- Sysmon installed and configured
- PowerShell 5.1+ or 7+

## 📦 Installation
```powershell
# 1. Install dependencies automatically
Invoke-PSDepend .\dependencies.psd1 -Force

# 2. Import the module
Import-Module .\XB-Win32LogTools\XB-Win32LogTools.psd1 -Force
```

## 🔧 Build/Test
```powershell
# Run code validation and tests
.\Build.ps1
```

## 🧪 Run specific tool
```powershell
Export-XBWin32Log -AsJson
Get-XBWin32NetworkEvents -DaysBack 7 -Output Json
Get-XBWin32Timeline -IncludeUsers 'contoso\admin1'
Set-XBWin32AuditPolicyWizard
```

## 📚 Help
```powershell
Get-Help Export-XBWin32Log -Full
```

## 👤 Author

**Kristian Holm Buch**  
[GitHub](https://github.com/kristianbuch)  
[LinkedIn](https://linkedin.com/in/kristianbuch)  

© 2025 NexaBlue — Licensed under CC BY-NC-ND 4.0
