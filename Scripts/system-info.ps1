Write-Host "System Information" -ForegroundColor Cyan
Get-ComputerInfo | Select-Object OSName, OSVersion, CsTotalPhysicalMemory
