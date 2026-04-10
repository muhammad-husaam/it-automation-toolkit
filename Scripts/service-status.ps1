Write-Host "Service Status" -ForegroundColor Cyan
Get-Service | Select-Object Name, Status
