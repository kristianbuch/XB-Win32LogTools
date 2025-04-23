# Get-XBWin32LogDetails

## SYNOPSIS
Display detailed information about the current Sysmon event log.

## SYNTAX
```powershell
Get-XBWin32LogDetails [-AsTable] [-AsJson]
```

## DESCRIPTION
Retrieves and displays information about the Microsoft-Windows-Sysmon/Operational log including size, record count, access time, and retention limits. You can view the output as a formatted table or JSON.

## PARAMETERS

### -AsTable
Display the log details in a table format.

### -AsJson
Display the log details in JSON format.

## EXAMPLES

### Example 1
```powershell
Get-XBWin32LogDetails -AsTable
```
Displays current Sysmon log information as a formatted table.

### Example 2
```powershell
Get-XBWin32LogDetails -AsJson
```
Outputs the log data as JSON.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch