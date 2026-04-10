# ============================================
# IT Support Toolkit
# Author: Muhammad Husaam
# ============================================

Set-Location $PSScriptRoot

$basePath = $PSScriptRoot
$scriptPath = "$basePath\Scripts"
$reportPath = "$basePath\Reports\IT-Report.html"

# Create Reports folder if missing
if (!(Test-Path "$basePath\Reports")) {
    New-Item -ItemType Directory -Path "$basePath\Reports" | Out-Null
}

# ================= MENU =================
function Show-Menu {
    Clear-Host
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host "       IT SUPPORT TOOLKIT         " -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan

    Write-Host "1. Network Diagnostics"
    Write-Host "2. System Information"
    Write-Host "3. Disk Space Check"
    Write-Host "4. Service Status"
    Write-Host "5. User Account Audit"
    Write-Host "6. System Health Check"
    Write-Host "7. Backup Files"
    Write-Host "8. Auto Fix Network"
    Write-Host "9. Generate HTML Report"
    Write-Host "10. Exit"
}

# ================= RUN SCRIPT =================
function Run-Script($file) {
    $full = Join-Path $scriptPath $file

    if (Test-Path $full) {
        Write-Host "`nRunning $file..." -ForegroundColor Yellow
        & $full
    } else {
        Write-Host "❌ Missing script: $file" -ForegroundColor Red
    }

    Pause
}

# ================= AUTO FIX NETWORK =================
function Auto-Fix-Network {
    Write-Host "`nRunning Network Fix..." -ForegroundColor Yellow

    try {
        ipconfig /flushdns | Out-Null
        Restart-Service -Name "Dnscache" -ErrorAction SilentlyContinue

        Write-Host "✅ Network fixed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Network fix failed" -ForegroundColor Red
    }

    Pause
}

# ================= HTML REPORT =================
function Generate-Report {

    $author = "Muhammad Husaam"
    $timestamp = Get-Date

    $system = Get-ComputerInfo | Select CsName, WindowsVersion, OsArchitecture
    $disk = Get-PSDrive -PSProvider FileSystem
    $network = Get-NetIPConfiguration

    $html = @"
<html>
<head>
<title>IT Support Report</title>
<style>
body { font-family: Arial; margin: 20px; }
h1 { color: #2c3e50; }
h2 { color: #3498db; }
table { border-collapse: collapse; width: 80%; }
th, td { border: 1px solid black; padding: 6px; }
th { background-color: #3498db; color: white; }
.header { background:#f4f4f4; padding:10px; border:1px solid #ccc; }
</style>
</head>
<body>

<div class="header">
<h1>IT Support Toolkit Report</h1>
<p><b>Author:</b> $author</p>
<p><b>Generated:</b> $timestamp</p>
</div>

<h2>System Information</h2>
<p>$($system.CsName) | $($system.WindowsVersion) | $($system.OsArchitecture)</p>

<h2>Disk Usage</h2>
<table>
<tr><th>Drive</th><th>Free Space (GB)</th></tr>
"@

    foreach ($d in $disk) {
        if ($d.Free) {
            $free = [math]::Round($d.Free/1GB,2)
            $html += "<tr><td>$($d.Name)</td><td>$free</td></tr>"
        }
    }

    $html += "</table><h2>Network Information</h2>"

    foreach ($n in $network) {
        if ($n.IPv4Address) {
            $html += "<p>$($n.InterfaceAlias): $($n.IPv4Address.IPAddress)</p>"
        }
    }

    $html += "</body></html>"

    $html | Out-File -Encoding UTF8 $reportPath

    Write-Host "`n✅ Report Generated Successfully!" -ForegroundColor Green
    Write-Host "Author: $author"
    Write-Host "Time: $timestamp"
    Write-Host "Saved: $reportPath" -ForegroundColor Cyan

    Pause
}

# ================= MAIN LOOP =================
do {
    Show-Menu
    $choice = Read-Host "Select option"

    switch ($choice) {
        "1" { Run-Script "network-diagnostic.ps1" }
        "2" { Run-Script "system-info.ps1" }
        "3" { Run-Script "disk-space-check.ps1" }
        "4" { Run-Script "service-status.ps1" }
        "5" { Run-Script "user-audit.ps1" }
        "6" { Run-Script "system-health-check.ps1" }
        "7" { Run-Script "backup-files.ps1" }
        "8" { Auto-Fix-Network }
        "9" { Generate-Report }
        "10" { break }
        default { Write-Host "Invalid option"; Pause }
    }

} while ($true)
