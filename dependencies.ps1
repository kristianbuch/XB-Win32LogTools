@{
    PSDependOptions = @{
        Target       = 'CurrentUser'
        Confirm      = $false
        AllowClobber = $true
        Force        = $true
    }

    Pester = @{
        Version       = '5.*'
        Parameters    = @{
            AllowPrerelease = $false
        }
    }

    PlatyPS = @{
        Version       = '0.14.*'
        Parameters    = @{
            AllowClobber = $true
            Force        = $true
        }
    }

    PSScriptAnalyzer = @{
        Version       = '1.*'
        Parameters    = @{
            AllowClobber = $true
            Force        = $true
        }
    }

    Sysmon = @{
    DependencyType = 'Command'
    Command        = 'winget install --id Sysinternals.Sysmon -e --accept-source-agreements --accept-package-agreements'
    SkipIf         = { Test-Path "$env:ProgramFiles\\Sysinternals Suite\\Sysmon.exe" }
    }
}
