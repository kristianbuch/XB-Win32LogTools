function New-XBWin32ScheduledExportTask {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "The event log to export regularly.")]
        [ValidateSet(
            "Microsoft-Windows-Sysmon/Operational",
            "Security",
            "Application",
            "System"
        )]
        [string]$LogName,

        [Parameter(Mandatory = $true, HelpMessage = "Where to store the exported logs.")]
        [ValidateScript({
            if (-not ($_ -is [string])) { throw "DestinationPath must be a string." }
            elseif (-not (Test-Path $_)) {
                try {
                    $null = New-Item -Path $_ -ItemType Directory -Force
                    $true
                } catch {
                    throw "DestinationPath '$_' does not exist and could not be created. Error: $($_.Exception.Message)"
                }
            } else {
                $true
            }
        })]
        [string]$DestinationPath,

        [Parameter(Mandatory = $true, HelpMessage = "Time of day to run the task (24h format e.g. '02:00')")]
        [ValidatePattern('^\d{2}:\d{2}$')]
        [string]$Time,

        [Parameter(Mandatory = $false, HelpMessage = "How often to run the task.")]
        [ValidateSet("Daily", "Hourly", "Weekly")]
        [string]$Interval = "Daily"
    )

    <#
    .SYNOPSIS
    Creates a scheduled task to export a Windows Event Log at a specified interval.

    .DESCRIPTION
    Automates the export of Windows event logs using Export-XBWin32Log via Task Scheduler.
    Supports daily, hourly, or weekly export.

    .PARAMETER LogName
    The name of the Windows Event Log to export.

    .PARAMETER DestinationPath
    The location to export logs to. Directory is created if not existing.

    .PARAMETER Time
    Time of day to run the task in HH:mm format (24-hour).

    .PARAMETER Interval
    Run frequency: Daily, Hourly or Weekly.

    .EXAMPLE
    New-XBWin32ScheduledExportTask -LogName 'Security' -DestinationPath 'C:\Exports' -Time '01:00'

    .EXAMPLE
    New-XBWin32ScheduledExportTask -LogName 'Microsoft-Windows-Sysmon/Operational' -DestinationPath 'D:\Logs' -Time '03:00' -Interval Weekly

    .NOTES
        Author      : Kristian Holm Buch
        Organization: NexaBlue
        License     : CC BY-NC-ND 4.0
        Copyright   : (c) 2025 - Kristian Holm Buch. All Rights Reserved.
        GitHub      : https://github.com/kristianbuch
        LinkedIn    : https://linkedin.com/in/kristianbuch
    #>

    begin {
        Write-Debug "Begin: Creating scheduled task for exporting $LogName"
    }

    process {
        try {
            $sanitized = $LogName -replace '[^a-zA-Z0-9]', '_'
            $taskName = "XBCore_Export_$sanitized"

            $action = "powershell.exe -ExecutionPolicy Bypass -NoProfile -Command `"Export-XBWin32Log -LogName '$LogName' -DestinationPath '$DestinationPath' -TimestampedName`""
            $schedule = "/SC $Interval.ToUpper() /ST $Time"
            $command = "schtasks /Create /F /TN `"$taskName`" /TR `"$action`" $schedule /RL HIGHEST"

            Write-Debug "Executing: $command"
            Invoke-Expression $command
            Write-Verbose "Scheduled task '$taskName' created to export '$LogName' at $Time ($Interval)"
        }
        catch [System.Exception] {
            Write-Error "Failed to create scheduled task: $($_.Exception.Message)"
            Write-Debug $_.Exception.ToString()
        }
    }

    end {
        Write-Debug "End: Scheduled task created"
    }
}
