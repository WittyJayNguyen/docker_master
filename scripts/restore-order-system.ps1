# AWS Order System Database Restore Script (PowerShell)
# This script creates a new database and restores data from backup

param(
    [string]$DatabaseName = "aws_order_system",
    [string]$BackupFile = "Data110720125\aws_order_system_20250603_120501"
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "AWS Order System Database Restore Script" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Configuration
$PostgresHost = "localhost"
$PostgresPort = "5432"
$PostgresUser = "postgres_user"
$PostgresPassword = "postgres_pass"
$PostgresDB = "docker_master"
$ContainerName = "postgres_low_ram"

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "- Host: $PostgresHost" -ForegroundColor White
Write-Host "- Port: $PostgresPort" -ForegroundColor White
Write-Host "- User: $PostgresUser" -ForegroundColor White
Write-Host "- New Database: $DatabaseName" -ForegroundColor White
Write-Host "- Backup File: $BackupFile" -ForegroundColor White
Write-Host ""

# Step 1: Check if PostgreSQL container is running
Write-Host "Step 1: Checking PostgreSQL container status..." -ForegroundColor Cyan
$containerStatus = docker ps --filter "name=$ContainerName" --format "table {{.Names}}\t{{.Status}}"
if ($containerStatus -match $ContainerName) {
    Write-Host "[OK] PostgreSQL container is running" -ForegroundColor Green
} else {
    Write-Host "[ERROR] PostgreSQL container is not running!" -ForegroundColor Red
    Write-Host "Please start the containers first: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

# Step 2: Check if backup file exists
Write-Host ""
Write-Host "Step 2: Checking backup file..." -ForegroundColor Cyan
if (Test-Path $BackupFile) {
    $fileSize = (Get-Item $BackupFile).Length / 1MB
    Write-Host "[OK] Backup file found (Size: $([math]::Round($fileSize, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Backup file not found: $BackupFile" -ForegroundColor Red
    exit 1
}

# Step 3: Create new database
Write-Host ""
Write-Host "Step 3: Creating database '$DatabaseName'..." -ForegroundColor Cyan

# Drop database if exists
Write-Host "- Dropping existing database (if exists)..." -ForegroundColor Yellow
$dropResult = docker exec -i $ContainerName psql -U $PostgresUser -d $PostgresDB -c "DROP DATABASE IF EXISTS $DatabaseName;" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Existing database dropped (if existed)" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Warning during database drop: $dropResult" -ForegroundColor Yellow
}

# Create new database
Write-Host "- Creating new database..." -ForegroundColor Yellow
$createResult = docker exec -i $ContainerName psql -U $PostgresUser -d $PostgresDB -c "CREATE DATABASE $DatabaseName WITH ENCODING='UTF8' LC_COLLATE='C' LC_CTYPE='C';" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Database '$DatabaseName' created successfully" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to create database: $createResult" -ForegroundColor Red
    exit 1
}

# Step 4: Copy backup file to container
Write-Host ""
Write-Host "Step 4: Copying backup file to container..." -ForegroundColor Cyan
$copyResult = docker cp $BackupFile "${ContainerName}:/tmp/backup.sql" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Backup file copied to container" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to copy backup file: $copyResult" -ForegroundColor Red
    exit 1
}

# Step 5: Restore database using pg_restore
Write-Host ""
Write-Host "Step 5: Restoring database from backup..." -ForegroundColor Cyan
Write-Host "Using pg_restore for PostgreSQL custom format..." -ForegroundColor Yellow
Write-Host "This may take several minutes due to the large file size..." -ForegroundColor Yellow
Write-Host ""

$restoreStart = Get-Date
$restoreResult = docker exec -i $ContainerName pg_restore -U $PostgresUser -d $DatabaseName -v /tmp/backup.sql 2>&1
$restoreEnd = Get-Date
$restoreDuration = $restoreEnd - $restoreStart

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Database restored successfully" -ForegroundColor Green
    Write-Host "Restore duration: $($restoreDuration.Minutes) minutes $($restoreDuration.Seconds) seconds" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to restore database" -ForegroundColor Red
    Write-Host "Error details: $restoreResult" -ForegroundColor Red
    exit 1
}

# Step 6: Clean up temporary files
Write-Host ""
Write-Host "Step 6: Cleaning up temporary files..." -ForegroundColor Cyan
docker exec -i $ContainerName rm -f /tmp/backup.sql
Write-Host "[OK] Temporary files cleaned up" -ForegroundColor Green

# Step 7: Verify restoration
Write-Host ""
Write-Host "Step 7: Verifying database restoration..." -ForegroundColor Cyan
Write-Host "Tables in database:" -ForegroundColor Yellow
docker exec -i $ContainerName psql -U $PostgresUser -d $DatabaseName -c "\dt"

Write-Host ""
Write-Host "Database size:" -ForegroundColor Yellow
docker exec -i $ContainerName psql -U $PostgresUser -d $DatabaseName -c "SELECT pg_size_pretty(pg_database_size('$DatabaseName')) as database_size;"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Database restoration completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Connection Details:" -ForegroundColor Yellow
Write-Host "- Host: $PostgresHost" -ForegroundColor White
Write-Host "- Port: $PostgresPort" -ForegroundColor White
Write-Host "- Database: $DatabaseName" -ForegroundColor White
Write-Host "- Username: $PostgresUser" -ForegroundColor White
Write-Host "- Password: $PostgresPassword" -ForegroundColor White
Write-Host ""
Write-Host "Access Options:" -ForegroundColor Yellow
Write-Host "- pgAdmin Web Interface: http://localhost:8080" -ForegroundColor White
Write-Host "- Command Line: docker exec -it $ContainerName psql -U $PostgresUser -d $DatabaseName" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
