Write-Host "System Health Check" -ForegroundColor Cyan
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
