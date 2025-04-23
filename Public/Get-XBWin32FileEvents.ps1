function Get-XBWin32FileEvents {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(HelpMessage = "Number of days back to retrieve file events.")]
        [ValidateRange(1, 365)]
        [int]$DaysBack = 30,

        [Parameter(HelpMessage = "Output format: Table, List or Json.")]
        [ValidateSet("Table", "List", "Json")]
        [string]$Output = "Table",

        [Parameter(HelpMessage = "Array of usernames to exclude from results.")]
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
    Retrieves file creation events from Sysmon (Event ID 11).

    .DESCRIPTION
    Parses Sysmon Event ID 11 to track file creation activity by users.
    If no data is returned, a warning is shown indicating potential policy misconfiguration.

    .PARAMETER DaysBack
    Number of days to include from Sysmon logs.

    .PARAMETER Output
    Format of output: Table (default), List or Json.

    .PARAMETER ExcludeUsers
    List of usernames to exclude (e.g., system/service accounts).

    .EXAMPLE
    Get-XBWin32FileEvents

    .EXAMPLE
    Get-XBWin32FileEvents -DaysBack 7 -Output Json

    .EXAMPLE
    Get-XBWin32FileEvents -ExcludeUsers @("contoso\\svc_worker")

    .NOTES
        Author      : Kristian Holm Buch
        Organization: NexaBlue
        License     : CC BY-NC-ND 4.0
        Copyright   : (c) 2025 - Kristian Holm Buch. All Rights Reserved.
        GitHub      : https://github.com/kristianbuch
        LinkedIn    : https://linkedin.com/in/kristianbuch
    #>

    begin {
        Write-Debug "Begin: Retrieving Sysmon Event ID 11 (FileCreate)"
        $events = @()
    }

    process {
        try {
            $filter = @{
                LogName   = 'Microsoft-Windows-Sysmon/Operational'
                ID        = 11
                StartTime = (Get-Date).AddDays(-$DaysBack)
            }

            $rawEvents = Get-WinEvent -FilterHashtable $filter -ErrorAction Stop

            if (-not $rawEvents) {
                Write-Warning "No Event ID 11 entries found. Ensure your Sysmon policy includes FileCreate monitoring."
            }

            foreach ($eventRecord in $rawEvents) {
                $event = [xml]$eventRecord.ToXml()
                $data = $event.Event.EventData.Data
                $user = ($data | Where-Object { $_.Name -eq 'User' }).'#text'

                if ($ExcludeUsers -notcontains $user -and $user -match '\\') {
                    $events += [PSCustomObject]@{
                        Time         = $eventRecord.TimeCreated
                        User         = $user
                        Process      = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
                        TargetFile   = ($data | Where-Object { $_.Name -eq 'TargetFilename' }).'#text'
                        CreationUtc  = ($data | Where-Object { $_.Name -eq 'UtcTime' }).'#text'
                        Hashes       = ($data | Where-Object { $_.Name -eq 'Hashes' }).'#text'
                    }
                }
            }
        }
        catch [System.Exception] {
            Write-Error "Failed to retrieve file events: $($_.Exception.Message)"
            Write-Debug $_.Exception.ToString()
        }
    }

    end {
        Write-Debug "End: Outputting file events"
        switch ($Output) {
            "Table" { $events | Sort-Object Time | Format-Table -AutoSize }
            "List"  { $events | Sort-Object Time | Format-List }
            "Json"  { $events | Sort-Object Time | ConvertTo-Json -Depth 10 }
        }
    }
}
