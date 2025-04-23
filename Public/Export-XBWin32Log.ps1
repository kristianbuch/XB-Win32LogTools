function Export-XBWin32Log {
    [CmdletBinding(DefaultParameterSetName = 'Evtx')]
    param (
        [Parameter(
            HelpMessage = "The name of the event log to export.",
            Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$LogName = 'Microsoft-Windows-Sysmon/Operational',

        [Parameter(
            HelpMessage = "Destination directory to save the exported log file.",
            Mandatory = $false)]
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
        [string]$DestinationPath = "$env:SystemDrive\Logs\XBCore",

        [Parameter(
            HelpMessage = "If set, appends a timestamp to the exported file name.",
            Mandatory = $false)]
        [switch]$TimestampedName,

        [Parameter(
            HelpMessage = "Export log content as JSON instead of .evtx.",
            ParameterSetName = 'Json')]
        [switch]$AsJson
    )

    <#
    .SYNOPSIS
    Export a Windows Event Log to .evtx or .json format.

    .DESCRIPTION
    Exports the specified Windows Event Log (default: Sysmon) to a chosen directory.
    Supports standard .evtx format via wevtutil or JSON export via Get-WinEvent.

    .PARAMETER LogName
    The name of the event log to export (e.g., 'Microsoft-Windows-Sysmon/Operational').

    .PARAMETER DestinationPath
    Directory to save the exported log file. The path is created if it does not exist.

    .PARAMETER TimestampedName
    If specified, a timestamp is appended to the filename for uniqueness and archival.

    .PARAMETER AsJson
    If specified, exports the log as JSON using Get-WinEvent.

    .EXAMPLE
    Export-XBWin32Log

    .EXAMPLE
    Export-XBWin32Log -LogName 'Security' -DestinationPath 'C:\Exports' -TimestampedName

    .EXAMPLE
    Export-XBWin32Log -AsJson

    .NOTES
        Author      : Kristian Holm Buch
        Organization: NexaBlue
        License     : CC BY-NC-ND 4.0
        Copyright   : (c) 2025 - Kristian Holm Buch. All Rights Reserved.
        GitHub      : https://github.com/kristianbuch
        LinkedIn    : https://linkedin.com/in/kristianbuch
    #>

    begin {
        Write-Debug "Begin: Exporting log '$LogName' to $DestinationPath"
    }

    process {
        try {
            $timestamp = if ($TimestampedName) { Get-Date -Format 'yyyyMMdd_HHmmss' } else { '' }
            $fileBase = if ($timestamp) { "$($LogName -replace '[^a-zA-Z0-9]', '_')_$timestamp" } else { "$($LogName -replace '[^a-zA-Z0-9]', '_')" }

            if ($AsJson) {
                Write-Debug "Exporting log as JSON using Get-WinEvent"
                $events = Get-WinEvent -LogName $LogName -ErrorAction Stop
                $json = $events | Select-Object -Property * | ConvertTo-Json -Depth 10
                $jsonPath = Join-Path -Path $DestinationPath -ChildPath "$fileBase.json"
                Set-Content -Path $jsonPath -Value $json -Encoding UTF8
                Write-Verbose "Exported log as JSON to $jsonPath"
            }
            else {
                Write-Debug "Exporting log as EVTX using wevtutil"
                $evtxPath = Join-Path -Path $DestinationPath -ChildPath "$fileBase.evtx"
                wevtutil epl "$LogName" "$evtxPath"
                Write-Verbose "Exported log as EVTX to $evtxPath"
            }
        }
        catch [System.Exception] {
            Write-Error "Failed to export log '$LogName': $($_.Exception.Message)"
            Write-Debug $_.Exception.ToString()
        }
    }

    end {
        Write-Debug "End: Export-XBWin32Log complete"
    }
}
