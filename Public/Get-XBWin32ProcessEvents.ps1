
function Get-XBWin32ProcessEvents {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [int]$DaysBack = 30,

        [ValidateSet("Table", "List", "Json")]
        [string]$Output = "Table"
    )

    begin {
        Write-Debug "Begin: Initializing Sysmon Process Event collection"

        $excludeUsers = @(
            "NT AUTHORITY\SYSTEM",
            "NT AUTHORITY\LOCAL SERVICE",
            "NT AUTHORITY\NETWORK SERVICE",
            "UMFD-0", "DWM-1",
            "NT SERVICE\PBIEgwService",
            "mingrossist\BuchKris_adm"
        )

        $events = @()
    }

    process {
        try {
            Write-Debug "Collecting Sysmon Event ID 1 (Process Create) from last $DaysBack days"

            $filter = @{
                LogName   = 'Microsoft-Windows-Sysmon/Operational'
                ID        = 1
                StartTime = (Get-Date).AddDays(-$DaysBack)
            }

            Get-WinEvent -FilterHashtable $filter | ForEach-Object {
                $event = [xml]$_.ToXml()
                $data = $event.Event.EventData.Data
                $user = ($data | Where-Object { $_.Name -eq 'User' }).'#text'

                if ($excludeUsers -notcontains $user -and $user -match '\\') {
                    $events += [PSCustomObject]@{
                        Time              = $_.TimeCreated
                        User              = $user
                        Process           = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
                        Command           = ($data | Where-Object { $_.Name -eq 'CommandLine' }).'#text'
                        StartedBy         = ($data | Where-Object { $_.Name -eq 'ParentImage' }).'#text'
                        CurrentDirectory  = ($data | Where-Object { $_.Name -eq 'CurrentDirectory' }).'#text'
                        LogonId           = ($data | Where-Object { $_.Name -eq 'LogonId' }).'#text'
                        ProcessId         = ($data | Where-Object { $_.Name -eq 'ProcessId' }).'#text'
                        ParentProcessId   = ($data | Where-Object { $_.Name -eq 'ParentProcessId' }).'#text'
                        IntegrityLevel    = ($data | Where-Object { $_.Name -eq 'IntegrityLevel' }).'#text'
                        Hashes            = ($data | Where-Object { $_.Name -eq 'Hashes' }).'#text'
                    }
                }
            }
        }
        catch [System.Exception] {
            Write-Error ("Failed to process Sysmon events: {0}`nDetails: {1}" -f $_.Exception.Message, $_.Exception.ToString())
        }
    }

    end {
        Write-Debug "End: Outputting collected process events"

        switch ($Output) {
            "Table" { $events | Sort-Object Time | Format-Table -AutoSize }
            "List"  { $events | Sort-Object Time | Format-List }
            "Json"  { $events | Sort-Object Time | ConvertTo-Json -Depth 10 }
        }
    }
}
