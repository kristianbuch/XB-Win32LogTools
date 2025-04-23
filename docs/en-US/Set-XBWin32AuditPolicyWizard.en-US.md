# Set-XBWin32AuditPolicyWizard

## SYNOPSIS
Configure Windows auditing interactively or automatically.

## SYNTAX
```powershell
Set-XBWin32AuditPolicyWizard [-Quiet]
```

## DESCRIPTION
Guides the user through configuring Windows audit policy subcategories such as Logon, Process Creation, and more.
Can be run interactively or silently using -Quiet to auto-enable all recommended audit settings.
Also checks for Sysmon Event ID coverage.

## PARAMETERS

### -Quiet
Enable all audit policies automatically without user prompts.

## EXAMPLES

### Example 1
```powershell
Set-XBWin32AuditPolicyWizard
```
Runs the audit policy wizard interactively.

### Example 2
```powershell
Set-XBWin32AuditPolicyWizard -Quiet
```
Enables all audit categories silently and checks Sysmon visibility.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch