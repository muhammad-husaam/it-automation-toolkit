Write-Host "Running Network Diagnostics..." -ForegroundColor Cyan

Test-Connection google.com -Count 2
Get-NetIPConfiguration
