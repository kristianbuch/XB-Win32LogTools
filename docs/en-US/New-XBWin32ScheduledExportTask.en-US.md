# New-XBWin32ScheduledExportTask

## SYNOPSIS
Create a scheduled task to export event logs on a schedule.

## SYNTAX
```powershell
New-XBWin32ScheduledExportTask [-LogName <string>] [-DestinationPath <string>] [-Time <string>] [-Interval <string>]
```

## DESCRIPTION
Sets up a Windows Scheduled Task to run Export-XBWin32Log at a given time and interval. Useful for automating regular log exports.

## PARAMETERS

### -LogName
The name of the log to export (e.g. Security, Microsoft-Windows-Sysmon/Operational).

### -DestinationPath
Directory where exported logs should be stored. Will be created if it does not exist.

### -Time
The time of day to run the task (HH:mm format).

### -Interval
How often to run the task: Daily, Hourly, Weekly.

## EXAMPLES

### Example 1
```powershell
New-XBWin32ScheduledExportTask -LogName "Security" -DestinationPath "D:\Logs" -Time "03:00"
```

### Example 2
```powershell
New-XBWin32ScheduledExportTask -LogName "Microsoft-Windows-Sysmon/Operational" -DestinationPath "C:\ExportedLogs" -Time "01:00" -Interval Weekly
```

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch