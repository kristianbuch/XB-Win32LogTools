function Get-XBWin32Timeline {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(HelpMessage = "Number of days back to include in the timeline.")]
        [ValidateRange(1, 365)]
        [int]$DaysBack = 30,

        [Parameter(HelpMessage = "Output format: Table, List or Json.")]
        [ValidateSet("Table", "List", "Json")]
        [string]$Output = "Table",

        [Parameter(HelpMessage = "Users to exclude from the timeline.")]
        [string[]]$ExcludeUsers = @(
            "NT AUTHORITY\\SYSTEM",
            "NT AUTHORITY\\LOCAL SERVICE",
            "NT AUTHORITY\\NETWORK SERVICE",
            "UMFD-0", "DWM-1",
            "NT SERVICE\\PBIEgwService",
            "mingrossist\\BuchKris_adm"
        ),

        [Parameter(HelpMessage = "Limit timeline to only these users.")]
        [string[]]$IncludeUsers
    )

    <#
    .SYNOPSIS
    Generates a timeline of user activity based on Sysmon events.

    .DESCRIPTION
    Combines Sysmon events (Process Create, Network Connect, File Create) into a unified, sorted timeline.

    .PARAMETER DaysBack
    Number of days to include in the timeline.

    .PARAMETER Output
    Output format: Table, List or Json.

    .PARAMETER ExcludeUsers
    Users to exclude from the timeline.

    .PARAMETER IncludeUsers
    Limit timeline to only these users (overrides ExcludeUsers).

    .EXAMPLE
    Get-XBWin32Timeline -DaysBack 7 -Output Json

    .EXAMPLE
    Get-XBWin32Timeline -IncludeUsers 'mydomain\\jdoe'

    .NOTES
        Author      : Kristian Holm Buch
        Organization: NexaBlue
        License     : CC BY-NC-ND 4.0
        Copyright   : (c) 2025 - Kristian Holm Buch. All Rights Reserved.
        GitHub      : https://github.com/kristianbuch
        LinkedIn    : https://linkedin.com/in/kristianbuch
    #>

    begin {
        Write-Debug "Begin: Building timeline from Sysmon Event IDs 1, 3, and 11"
        $timeline = @()
    }

    process {
        try {
            $start = (Get-Date).AddDays(-$DaysBack)
            $ids = 1, 3, 11
            $events = Get-WinEvent -FilterHashtable @{ LogName = 'Microsoft-Windows-Sysmon/Operational'; ID = $ids; StartTime = $start }

            foreach ($eventRecord in $events) {
                $event = [xml]$eventRecord.ToXml()
                $data = $event.Event.EventData.Data
                $id = $event.Event.System.EventID
                $user = ($data | Where-Object { $_.Name -eq 'User' }).'#text'

                if ($IncludeUsers -and $user -notin $IncludeUsers) { continue }
                if (-not $IncludeUsers -and ($ExcludeUsers -contains $user -or $user -notmatch '\\')) { continue }

                $entry = [PSCustomObject]@{
                    Time       = $eventRecord.TimeCreated
                    User       = $user
                    EventType  = switch ($id) {
                        1  { "ProcessCreated" }
                        3  { "NetworkConnection" }
                        11 { "FileCreated" }
                        default { "Unknown" }
                    }
                    Process    = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
                    Command    = ($data | Where-Object { $_.Name -eq 'CommandLine' }).'#text'
                    Target     = ($data | Where-Object { $_.Name -eq 'TargetFilename' }).'#text'
                    RemoteIP   = ($data | Where-Object { $_.Name -eq 'DestinationIp' }).'#text'
                    RemotePort = ($data | Where-Object { $_.Name -eq 'DestinationPort' }).'#text'
                }

                $timeline += $entry
            }
        }
        catch [System.Exception] {
            Write-Error "Failed to generate timeline: $($_.Exception.Message)"
            Write-Debug $_.Exception.ToString()
        }
    }

    end {
        Write-Debug "End: Outputting timeline"
        $sorted = $timeline | Sort-Object Time

        switch ($Output) {
            "Table" { $sorted | Format-Table -AutoSize }
            "List"  { $sorted | Format-List }
            "Json"  { $sorted | ConvertTo-Json -Depth 10 }
        }
    }
}
