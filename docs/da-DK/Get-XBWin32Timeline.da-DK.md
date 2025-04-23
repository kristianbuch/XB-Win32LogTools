# Get-XBWin32Timeline

## SYNOPSIS
Generér en samlet tidslinje fra Sysmon-hændelser (Proces, Netværk, Fil).

## SYNTAX
```powershell
Get-XBWin32Timeline [-DaysBack <int>] [-Output <string>] [-ExcludeUsers <string[]>] [-IncludeUsers <string[]>]
```

## DESCRIPTION
Sammenfatter Sysmon Event ID 1 (Proces), 3 (Netværk) og 11 (Fil) i en samlet kronologisk tidslinje over brugeraktivitet. Understøtter filtrering og forskellige output-formater.

## PARAMETERS

### -DaysBack
Antal dage der skal med i tidslinjen.

### -Output
Output-format: Table (standard), List eller Json.

### -ExcludeUsers
Brugere der skal udelades fra tidslinjen.

### -IncludeUsers
Brugere der skal inkluderes – tilsidesætter ExcludeUsers.

## EXAMPLES

### Eksempel 1
```powershell
Get-XBWin32Timeline -DaysBack 3 -IncludeUsers "contoso\jdoe"
```
Returnerer 3 dages aktivitetstidslinje for brugeren contoso\jdoe.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch