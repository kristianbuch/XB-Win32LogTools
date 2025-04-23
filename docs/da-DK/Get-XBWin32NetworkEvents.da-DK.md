# Get-XBWin32NetworkEvents

## SYNOPSIS
Hent Sysmon-netværksforbindelser (Event ID 3).

## SYNTAX
```powershell
Get-XBWin32NetworkEvents [-DaysBack <int>] [-Output <string>] [-ExcludeUsers <string[]>]
```

## DESCRIPTION
Parser Sysmon Event ID 3 for at finde netværksforbindelser startet af brugere. 
Understøtter filtrering på dage og eksklusion af systembrugere.

## PARAMETERS

### -DaysBack
Antal dage tilbage i tiden der skal vises.

### -Output
Visningsformat: Table (standard), List eller Json.

### -ExcludeUsers
Brugere som skal udelukkes fra resultaterne.

## EXAMPLES

### Eksempel 1
```powershell
Get-XBWin32NetworkEvents -DaysBack 7 -Output Json
```
Returnerer netværkshændelser i JSON-format for de seneste 7 dage.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch