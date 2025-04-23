[CmdletBinding()]
param (
    [switch]$BumpVersion
)

Write-Host "Starting Build Process..." -ForegroundColor Cyan

$moduleName = 'XBCore.Win32LogTools'
$modulePath = Join-Path $PSScriptRoot $moduleName
$manifestPath = Join-Path $modulePath "$moduleName.psd1"

# 1. Import dependencies if available
if (Test-Path .\dependencies.psd1) {
    Write-Host "Installing dependencies via PSDepend..." -ForegroundColor Yellow
    Invoke-PSDepend .\dependencies.psd1 -Force
}

# 2. Lint with PSScriptAnalyzer
Write-Host "Running PSScriptAnalyzer..." -ForegroundColor Yellow
$scriptFiles = Get-ChildItem -Path "$modulePath\\Public" -Filter *.ps1 -Recurse
$scriptFiles | ForEach-Object {
    Invoke-ScriptAnalyzer -Path $_.FullName -Recurse -Severity Warning,Error
}

# 3. Run Pester tests
if (Test-Path "$PSScriptRoot\\Tests") {
    Write-Host "Running Pester tests..." -ForegroundColor Yellow
    Invoke-Pester -Path "$PSScriptRoot\\Tests"
} else {
    Write-Warning "No test directory found"
}

# 4. Version bump (if enabled)
if ($BumpVersion) {
    Write-Host "Bumping module version..." -ForegroundColor Cyan
    $manifest = Import-PowerShellDataFile -Path $manifestPath
    $v = [System.Version]$manifest.ModuleVersion
    $newVersion = "{0}.{1}.{2}" -f $v.Major, $v.Minor, ($v.Build + 1)
    Update-ModuleManifest -Path $manifestPath -ModuleVersion $newVersion
    Write-Host "New version: $newVersion" -ForegroundColor Green
}

# 5. Generate Help (PlatyPS)
if (-not (Get-Command New-MarkdownHelp -ErrorAction SilentlyContinue)) {
    Write-Warning "PlatyPS is not installed or imported. Skipping help generation."
} else {
    $helpPath = Join-Path "$modulePath\\docs" "en-US"
    New-MarkdownHelp -Module $modulePath -OutputFolder $helpPath -Force
    Write-Host "Generated markdown help to $helpPath" -ForegroundColor Green
}

# 6. Import module to current session
Write-Host "Importing module into current session..." -ForegroundColor Yellow
Import-Module $manifestPath -Force
Write-Host "Build completed." -ForegroundColor Cyan
