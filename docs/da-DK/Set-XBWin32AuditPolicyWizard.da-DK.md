# Set-XBWin32AuditPolicyWizard

## SYNOPSIS
Opsæt Windows auditpolitik interaktivt eller automatisk.

## SYNTAX
```powershell
Set-XBWin32AuditPolicyWizard [-Quiet]
```

## DESCRIPTION
Gennemgår vigtige Windows auditpol-subkategorier (f.eks. Logon, Process Creation). Brugeren kan vælge hvad der aktiveres – eller alt aktiveres automatisk med -Quiet.
Tjekker også om Sysmon EventIDs 1, 3, 11 er til stede.

## PARAMETERS

### -Quiet
Aktiverer alle auditpol-indstillinger automatisk uden prompts.

## EXAMPLES

### Eksempel 1
```powershell
Set-XBWin32AuditPolicyWizard
```
Kører den interaktive auditpolitik-wizard.

### Eksempel 2
```powershell
Set-XBWin32AuditPolicyWizard -Quiet
```
Aktiverer alle anbefalede auditpol-kategorier automatisk og tjekker Sysmon.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch