# Get-XBWin32LogDetails

## SYNOPSIS
Vis detaljeret information om den nuværende Sysmon-log.

## SYNTAX
```powershell
Get-XBWin32LogDetails [-AsTable] [-AsJson]
```

## DESCRIPTION
Henter information om loggen Microsoft-Windows-Sysmon/Operational – inklusive størrelse, adgangstid, antal poster og ældste/nuværende hændelse. Understøtter output som tabel eller JSON.

## PARAMETERS

### -AsTable
Viser informationen som en formateret tabel.

### -AsJson
Viser informationen som JSON.

## EXAMPLES

### Eksempel 1
```powershell
Get-XBWin32LogDetails -AsTable
```
Viser Sysmon-loggens status som tabel.

### Eksempel 2
```powershell
Get-XBWin32LogDetails -AsJson
```
Returnerer loggens metadata som JSON.

## NOTES
Author: Kristian Holm Buch  
Organization: NexaBlue  
License: CC BY-NC-ND 4.0  
GitHub: https://github.com/kristianbuch  
LinkedIn: https://linkedin.com/in/kristianbuch