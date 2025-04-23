# Get-XBWin32FileEvents

## SYNOPSIS
Hent filoprettelser via Sysmon (Event ID 11).

## SYNTAX
```powershell
Get-XBWin32FileEvents [-DaysBack <int>] [-Output <string>] [-ExcludeUsers <string[]>]
```

## DESCRIPTION
Parser Sysmon Event ID 11 for at vise filoprettelser fra brugerprocesser. Viser hashdata hvis tilgængelig. Advarer hvis Sysmon-policy ikke dækker FileCreate.

## PARAMETERS

### -DaysBack
Antal dage tilbage der skal inkluderes.

### -Output
Outputformat: Table (standard), List eller Json.

### -ExcludeUsers
Brugere der skal udelukkes fra resultatet.

## EXAMPLES

### Eksempel 1
```powershell
Get-XBWin32FileEvents -DaysBack 14 -Output Json
```
Viser filoprettelser de sidste 14 dage i JSON-format.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch