function Get-XBWin32NetworkEvents {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(
            HelpMessage = "Number of days back to retrieve network events.")]
        [ValidateRange(1, 365)]
        [int]$DaysBack = 30,

        [Parameter(
            HelpMessage = "Output format: Table, List or Json.")]
        [ValidateSet("Table", "List", "Json")]
        [string]$Output = "Table",

        [Parameter(
            HelpMessage = "Array of usernames to exclude from results.")]
        [string[]]$ExcludeUsers = @(
            "NT AUTHORITY\\SYSTEM",
            "NT AUTHORITY\\LOCAL SERVICE",
            "NT AUTHORITY\\NETWORK SERVICE",
            "UMFD-0", "DWM-1",
            "NT SERVICE\\PBIEgwService",
            "mingrossist\\BuchKris_adm"
        )
    )

    <#
    .SYNOPSIS
    Retrieves network connection events from Sysmon (Event ID 3).

    .DESCRIPTION
    Parses Sysmon Event ID 3 for network activity including destination IP, port, and protocol.
    Supports output as table, list or JSON. You can exclude system or specific users.

    .PARAMETER DaysBack
    Defines how many days of data to include from Sysmon Event ID 3.

    .PARAMETER Output
    Defines the output format: Table (default), List, or Json.

    .PARAMETER ExcludeUsers
    List of usernames to exclude (system or service accounts, etc.).

    .EXAMPLE
    Get-XBWin32NetworkEvents

    .EXAMPLE
    Get-XBWin32NetworkEvents -DaysBack 7 -Output Json

    .EXAMPLE
    Get-XBWin32NetworkEvents -ExcludeUsers @("mydomain\\svc_admin")

    .NOTES
        Author      : Kristian Holm Buch
        Organization: NexaBlue
        License     : CC BY-NC-ND 4.0
        Copyright   : (c) 2025 - Kristian Holm Buch. All Rights Reserved.
        GitHub      : https://github.com/kristianbuch
        LinkedIn    : https://linkedin.com/in/kristianbuch
    #>

    begin {
        Write-Debug "Begin: Collecting Sysmon Network Events"
        $events = @()
    }

    process {
        try {
            $filter = @{
                LogName   = 'Microsoft-Windows-Sysmon/Operational'
                ID        = 3
                StartTime = (Get-Date).AddDays(-$DaysBack)
            }

            Write-Debug "Querying Sysmon Event ID 3 for the last $DaysBack days"
            Get-WinEvent -FilterHashtable $filter -ErrorAction Stop | ForEach-Object {
                $event = [xml]$_.ToXml()
                $data  = $event.Event.EventData.Data

                $user = ($data | Where-Object { $_.Name -eq 'User' }).'#text'
                if ($ExcludeUsers -notcontains $user -and $user -match '\\') {
                    $events += [PSCustomObject]@{
                        Time             = $_.TimeCreated
                        User             = $user
                        Process          = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
                        CommandLine      = ($data | Where-Object { $_.Name -eq 'CommandLine' }).'#text'
                        SourceIp         = ($data | Where-Object { $_.Name -eq 'SourceIp' }).'#text'
                        SourcePort       = ($data | Where-Object { $_.Name -eq 'SourcePort' }).'#text'
                        DestinationIp    = ($data | Where-Object { $_.Name -eq 'DestinationIp' }).'#text'
                        DestinationPort  = ($data | Where-Object { $_.Name -eq 'DestinationPort' }).'#text'
                        Protocol         = ($data | Where-Object { $_.Name -eq 'Protocol' }).'#text'
                        Initiated        = ($data | Where-Object { $_.Name -eq 'Initiated' }).'#text'
                    }
                }
            }
        }
        catch [System.Exception] {
            Write-Error "Failed to retrieve network events: $($_.Exception.Message)"
            Write-Debug $_.Exception.ToString()
        }
    }

    end {
        Write-Debug "End: Outputting network events"
        switch ($Output) {
            "Table" { $events | Sort-Object Time | Format-Table -AutoSize }
            "List"  { $events | Sort-Object Time | Format-List }
            "Json"  { $events | Sort-Object Time | ConvertTo-Json -Depth 10 }
        }
    }
}
