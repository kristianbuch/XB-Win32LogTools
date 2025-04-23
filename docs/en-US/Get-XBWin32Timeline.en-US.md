# Get-XBWin32Timeline

## SYNOPSIS
Generate a unified timeline from Sysmon events (Process, Network, File).

## SYNTAX
```powershell
Get-XBWin32Timeline [-DaysBack <int>] [-Output <string>] [-ExcludeUsers <string[]>] [-IncludeUsers <string[]>]
```

## DESCRIPTION
Combines Sysmon Event IDs 1 (Process Create), 3 (Network Connect), and 11 (File Create) into a single, time-sorted timeline of user activity. Supports user filtering and output formatting.

## PARAMETERS

### -DaysBack
Number of days to include in the timeline.

### -Output
Output format: Table (default), List or Json.

### -ExcludeUsers
List of users to exclude from the timeline.

### -IncludeUsers
Optional filter to include only specified users. Overrides ExcludeUsers.

## EXAMPLES

### Example 1
```powershell
Get-XBWin32Timeline -DaysBack 3 -IncludeUsers "contoso\jdoe"
```
Returns a 3-day activity timeline for user contoso\jdoe.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch