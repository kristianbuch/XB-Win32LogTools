# Export-XBWin32Log

## SYNOPSIS
Eksporter en Windows-hændelseslog til `.evtx` eller `.json`.

## SYNTAX
```powershell
Export-XBWin32Log [-LogName <string>] [-DestinationPath <string>] [-TimestampedName] [-AsJson]
```

## DESCRIPTION
Eksporterer den angivne Windows-logfil (standard: Sysmon) til en angivet mappe.
Understøtter både `.evtx` (wevtutil) og JSON (Get-WinEvent).

## PARAMETERS

### -LogName
Navnet på hændelsesloggen der skal eksporteres.

### -DestinationPath
Mappen, hvor logfilen gemmes.

### -TimestampedName
Tilføjer et tidsstempel til filnavnet, hvis angivet.

### -AsJson
Eksporterer loggen som JSON fremfor `.evtx`.

## EXAMPLES

### Eksempel 1
```powershell
Export-XBWin32Log -LogName "Security" -DestinationPath "C:\Eksport" -TimestampedName
```
Eksporterer Security-loggen med et tidsstempel i filnavnet.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch