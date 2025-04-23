# Get-XBWin32NetworkEvents

## SYNOPSIS
Retrieve Sysmon network connection events (Event ID 3).

## SYNTAX
```powershell
Get-XBWin32NetworkEvents [-DaysBack <int>] [-Output <string>] [-ExcludeUsers <string[]>]
```

## DESCRIPTION
Parses Sysmon Event ID 3 to identify user-initiated network connections. 
Supports filtering by time and excluding system/service accounts.

## PARAMETERS

### -DaysBack
Number of days back to include in the result.

### -Output
Format of the output: Table (default), List or Json.

### -ExcludeUsers
Usernames to exclude from the results.

## EXAMPLES

### Example 1
```powershell
Get-XBWin32NetworkEvents -DaysBack 7 -Output Json
```
Returns JSON-formatted network events for the past 7 days.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch