Write-Host "Backup Started..." -ForegroundColor Cyan

$source = "C:\Temp"
$destination = "C:\Backup"

Copy-Item -Path $source -Destination $destination -Recurse -Force
Write-Host "Backup Completed"
