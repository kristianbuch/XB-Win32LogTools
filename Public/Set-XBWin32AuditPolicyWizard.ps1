function Set-XBWin32AuditPolicyWizard {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Run without prompts and enable all recommended audit settings automatically.")]
        [switch]$Quiet
    )

    <#
    .SYNOPSIS
    Interactive or automatic configuration of Windows audit policies and Sysmon visibility.

    .DESCRIPTION
    Guides the user through enabling key audit categories in auditpol, or enables them all silently using -Quiet.
    Also checks for important Sysmon EventIDs and informs if they're missing.

    .PARAMETER Quiet
    Enables all audit policy settings automatically without prompting the user.

    .EXAMPLE
    Set-XBWin32AuditPolicyWizard

    .EXAMPLE
    Set-XBWin32AuditPolicyWizard -Quiet

    .NOTES
        Author      : Kristian Holm Buch
        Organization: NexaBlue
        License     : CC BY-NC-ND 4.0
        Copyright   : (c) 2025 - Kristian Holm Buch. All Rights Reserved.
        GitHub      : https://github.com/kristianbuch
        LinkedIn    : https://linkedin.com/in/kristianbuch
    #>

    $settings = @(
        @{ Name = "Logon"; Description = "Monitor successful and failed login attempts." },
        @{ Name = "Logoff"; Description = "Track when a user logs off." },
        @{ Name = "Account Lockout"; Description = "Helps identify brute-force attempts or compromised accounts." },
        @{ Name = "Process Creation"; Description = "Log every time a process starts." },
        @{ Name = "Process Termination"; Description = "Log when a process ends." },
        @{ Name = "Object Access"; Description = "Track access to files, folders and registry keys." },
        @{ Name = "File System"; Description = "More granular file system access logging (requires SACLs)." },
        @{ Name = "Account Logon"; Description = "Authentication logs, especially from domain controllers." },
        @{ Name = "Authentication Policy Change"; Description = "Logs changes to local security policies." },
        @{ Name = "User Account Management"; Description = "Logs creation, deletion or changes to users." },
        @{ Name = "Security Group Management"; Description = "Logs group membership changes." }
    )

    foreach ($setting in $settings) {
        if (-not $Quiet) {
            Write-Host "`n[AuditPol] $($setting.Name)" -ForegroundColor Cyan
            Write-Host "$($setting.Description)" -ForegroundColor Gray
            $confirm = Read-Host "Enable this? (Y/N)"
            if ($confirm -notmatch '^y') {
                Write-Host "→ Skipped $($setting.Name)"
                continue
            }
        }

        try {
            $cmd = "auditpol /set /subcategory:`"$($setting.Name)`" /success:enable /failure:enable"
            Write-Debug "Running: $cmd"
            Invoke-Expression $cmd
            Write-Host "→ Enabled audit policy: $($setting.Name)" -ForegroundColor Green
        }
        catch {
            Write-Warning "Could not enable audit policy '$($setting.Name)': $($_.Exception.Message)"
        }
    }

    Write-Host "`n[Sysmon EventID Check]" -ForegroundColor Yellow

    $requiredIDs = @(1, 3, 11)
    $missingIDs = @()

    foreach ($id in $requiredIDs) {
        try {
            $found = Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=$id} -MaxEvents 1 -ErrorAction Stop
            if (-not $found) { $missingIDs += $id }
        }
        catch {
            $missingIDs += $id
        }
    }

    if ($missingIDs.Count -eq 0) {
        Write-Host "✔ Sysmon appears to log EventIDs 1, 3, and 11." -ForegroundColor Green
    } else {
        Write-Warning "⚠ Sysmon does not appear to log: $($missingIDs -join ', ')"
        Write-Host "Ensure your Sysmon XML config includes these events." -ForegroundColor Gray
    }

    Write-Debug "Audit policy wizard complete."
}
