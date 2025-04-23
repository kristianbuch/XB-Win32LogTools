# New-XBWin32ScheduledExportTask

## SYNOPSIS
Opret en planlagt opgave til automatisk eksport af logfiler.

## SYNTAX
```powershell
New-XBWin32ScheduledExportTask [-LogName <string>] [-DestinationPath <string>] [-Time <string>] [-Interval <string>]
```

## DESCRIPTION
Opretter en Windows Scheduled Task som automatisk kører Export-XBWin32Log på angivet tidspunkt og frekvens. Anvendes til at automatisere log-eksport.

## PARAMETERS

### -LogName
Navnet på loggen der skal eksporteres (f.eks. Security, Microsoft-Windows-Sysmon/Operational).

### -DestinationPath
Mappe hvor logfilerne gemmes. Oprettes hvis den ikke findes.

### -Time
Tidspunkt på dagen for eksport (format HH:mm).

### -Interval
Hvor ofte opgaven skal køre: Daily, Hourly, Weekly.

## EXAMPLES

### Eksempel 1
```powershell
New-XBWin32ScheduledExportTask -LogName "Security" -DestinationPath "D:\Logs" -Time "03:00"
```

### Eksempel 2
```powershell
New-XBWin32ScheduledExportTask -LogName "Microsoft-Windows-Sysmon/Operational" -DestinationPath "C:\ExportedLogs" -Time "01:00" -Interval Weekly
```

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch