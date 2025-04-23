# Export-XBWin32Log

## SYNOPSIS
Export a Windows Event Log to `.evtx` or `.json`.

## SYNTAX
```powershell
Export-XBWin32Log [-LogName <string>] [-DestinationPath <string>] [-TimestampedName] [-AsJson]
```

## DESCRIPTION
Exports the specified Windows Event Log (default: Sysmon) to a chosen directory.
Supports standard `.evtx` format via wevtutil or JSON export via Get-WinEvent.

## PARAMETERS

### -LogName
The name of the event log to export.

### -DestinationPath
The destination folder to store exported logs.

### -TimestampedName
Appends timestamp to the exported file name if specified.

### -AsJson
Exports the log content to JSON instead of `.evtx`.

## EXAMPLES

### Example 1
```powershell
Export-XBWin32Log -LogName "Security" -DestinationPath "C:\Exports" -TimestampedName
```
Exports the Security log with a timestamped file name.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch