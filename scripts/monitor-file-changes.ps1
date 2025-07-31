# File Change Monitor for Docker Compose Files
# Monitors specific files and alerts when they are modified

param(
    [string]$FilePath = "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml",
    [int]$CheckInterval = 5
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "File Change Monitor" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$FullPath = Join-Path (Get-Location) $FilePath
Write-Host "Monitoring file: $FullPath" -ForegroundColor Yellow
Write-Host "Check interval: $CheckInterval seconds" -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path $FullPath)) {
    Write-Host "ERROR: File not found!" -ForegroundColor Red
    exit 1
}

# Get initial file info
$LastWriteTime = (Get-Item $FullPath).LastWriteTime
$LastSize = (Get-Item $FullPath).Length
$InitialHash = Get-FileHash $FullPath -Algorithm MD5

Write-Host "Initial file info:" -ForegroundColor Cyan
Write-Host "- Last modified: $LastWriteTime" -ForegroundColor White
Write-Host "- Size: $LastSize bytes" -ForegroundColor White
Write-Host "- Hash: $($InitialHash.Hash)" -ForegroundColor White
Write-Host ""

Write-Host "Monitoring started... Press Ctrl+C to stop" -ForegroundColor Green
Write-Host ""

$ChangeCount = 0

try {
    while ($true) {
        Start-Sleep $CheckInterval
        
        if (Test-Path $FullPath) {
            $CurrentInfo = Get-Item $FullPath
            $CurrentHash = Get-FileHash $FullPath -Algorithm MD5
            
            # Check if file was modified
            if ($CurrentInfo.LastWriteTime -ne $LastWriteTime -or 
                $CurrentInfo.Length -ne $LastSize -or 
                $CurrentHash.Hash -ne $InitialHash.Hash) {
                
                $ChangeCount++
                $ChangeTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                
                Write-Host "🚨 FILE CHANGED! #$ChangeCount" -ForegroundColor Red
                Write-Host "Time: $ChangeTime" -ForegroundColor Yellow
                Write-Host "Previous: $LastWriteTime ($LastSize bytes)" -ForegroundColor Gray
                Write-Host "Current:  $($CurrentInfo.LastWriteTime) ($($CurrentInfo.Length) bytes)" -ForegroundColor White
                
                # Show what changed
                if ($CurrentInfo.Length -ne $LastSize) {
                    $SizeDiff = $CurrentInfo.Length - $LastSize
                    Write-Host "Size change: $SizeDiff bytes" -ForegroundColor Cyan
                }
                
                if ($CurrentHash.Hash -ne $InitialHash.Hash) {
                    Write-Host "Content changed (hash different)" -ForegroundColor Cyan
                }
                
                # Try to identify what process might have changed it
                Write-Host "Checking for processes that might have modified the file..." -ForegroundColor Yellow
                
                $SuspiciousProcesses = Get-Process | Where-Object {
                    $_.ProcessName -match "code|notepad|docker|script|powershell|cmd" -and
                    $_.StartTime -and
                    $_.StartTime -gt (Get-Date).AddMinutes(-5)
                } | Select-Object ProcessName, Id, StartTime
                
                if ($SuspiciousProcesses) {
                    Write-Host "Recent processes that could modify files:" -ForegroundColor Cyan
                    $SuspiciousProcesses | Format-Table -AutoSize
                } else {
                    Write-Host "No obvious processes found" -ForegroundColor Gray
                }
                
                # Log the change
                $LogEntry = "$ChangeTime - File changed: $FilePath (Size: $($CurrentInfo.Length), Hash: $($CurrentHash.Hash))"
                Add-Content -Path "logs\file-changes.log" -Value $LogEntry -ErrorAction SilentlyContinue
                
                Write-Host ""
                
                # Update tracking variables
                $LastWriteTime = $CurrentInfo.LastWriteTime
                $LastSize = $CurrentInfo.Length
                $InitialHash = $CurrentHash
            }
        } else {
            Write-Host "⚠️ File was deleted!" -ForegroundColor Red
            break
        }
        
        # Show alive indicator every 30 seconds
        if ((Get-Date).Second % 30 -eq 0) {
            Write-Host "." -NoNewline -ForegroundColor Green
        }
    }
} catch {
    Write-Host ""
    Write-Host "Monitoring stopped." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "File Change Monitor Stopped" -ForegroundColor Green
Write-Host "Total changes detected: $ChangeCount" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
