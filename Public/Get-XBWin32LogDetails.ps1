
function Get-XBWin32LogDetails {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param (
        [Parameter(HelpMessage = "Output as table format.")]
        [switch]$AsTable,

        [Parameter(HelpMessage = "Output as JSON format.")]
        [switch]$AsJson
    )

    begin {
        Write-Debug "Begin: Initializing log detail retrieval"
    }

    process {
        try {
            $first = Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' |
                Sort-Object TimeCreated | Select-Object -First 1

            $last = Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' |
                Sort-Object TimeCreated | Select-Object -Last 1

            $logs = Get-WinEvent -ListLog 'Microsoft-Windows-Sysmon/Operational' | ForEach-Object {
                [PSCustomObject]@{
                    LogName        = $_.LogName
                    LogType        = $_.LogType
                    FileSizeMB     = '{0:N2}' -f ($_.FileSize / 1MB)
                    MaxSizeMB      = '{0:N2}' -f ($_.MaximumSizeInBytes / 1MB)
                    Records        = $_.RecordCount
                    Enabled        = $_.IsEnabled
                    LogMode        = $_.LogMode
                    LogFilePath    = $_.LogFilePath
                    LastAccessTime = $_.LastAccessTime
                    IsClassicLog   = $_.IsClassicLog
                    LogIsolation   = $_.LogIsolation
                    OldestLog      = $first.TimeCreated
                    Latest         = $last.TimeCreated
                }
            }

            if ($AsTable) {
                $logs | Format-Table -AutoSize
            } elseif ($AsJson) {
                $logs | ConvertTo-Json -Depth 10
            } else {
                return $logs
            }
        }
        catch [System.Exception] {
            Write-Error ("Error retrieving Sysmon log details: {0}`nDetails: {1}" -f $_.Exception.Message, $_.Exception.ToString())
        }
    }

    end {
        Write-Debug "End: Completed log detail retrieval"
    }
}
