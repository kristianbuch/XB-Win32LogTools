# Get-XBWin32FileEvents

## SYNOPSIS
Retrieve Sysmon file creation events (Event ID 11).

## SYNTAX
```powershell
Get-XBWin32FileEvents [-DaysBack <int>] [-Output <string>] [-ExcludeUsers <string[]>]
```

## DESCRIPTION
Parses Sysmon Event ID 11 to track file creations by user processes. Includes hash data when available. Warns if Sysmon policy does not include file creation logging.

## PARAMETERS

### -DaysBack
Number of days to look back for file creation events.

### -Output
Output format: Table (default), List, or Json.

### -ExcludeUsers
Users to exclude from the event log output.

## EXAMPLES

### Example 1
```powershell
Get-XBWin32FileEvents -DaysBack 14 -Output Json
```
Displays file creation events from the last 14 days as JSON.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch