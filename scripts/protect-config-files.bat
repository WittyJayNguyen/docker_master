@echo off
echo ========================================
echo Config Files Protection Tool
echo ========================================
echo.

echo [1] Checking for auto-modification sources...

echo.
echo [2] Checking running processes that might modify files...
echo Looking for monitoring scripts...
tasklist | findstr /I "monitor\|auto\|script" 2>nul
if %ERRORLEVEL% equ 0 (
    echo [WARNING] Found monitoring processes that might modify files
) else (
    echo [OK] No suspicious monitoring processes found
)

echo.
echo [3] Checking for Docker Compose override files...
if exist "docker-compose.override.yml" (
    echo [WARNING] Found docker-compose.override.yml - this might override your settings
    echo Content:
    type docker-compose.override.yml
) else (
    echo [OK] No override files found
)

echo.
echo [4] Checking for auto-scripts in startup...
echo Checking scheduled tasks...
schtasks /query /fo LIST | findstr /I "docker\|auto\|monitor" 2>nul
if %ERRORLEVEL% equ 0 (
    echo [WARNING] Found scheduled tasks that might modify Docker files
) else (
    echo [OK] No suspicious scheduled tasks found
)

echo.
echo [5] Protection Options:
echo ========================================
echo.
echo [1] Make config files read-only
echo [2] Create backup of current configs
echo [3] Disable auto-scripts temporarily
echo [4] Show file modification history
echo [5] Exit
echo.
set /p choice="Choose option (1-5): "

if "%choice%"=="1" goto :make_readonly
if "%choice%"=="2" goto :backup_configs
if "%choice%"=="3" goto :disable_auto_scripts
if "%choice%"=="4" goto :show_history
if "%choice%"=="5" goto :exit

:make_readonly
echo.
echo Making config files read-only...
attrib +R "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml"
attrib +R "nginx\conf.d\asmo-foodservice.conf"
attrib +R "nginx\sites\asmo-foodservice.conf"
echo [OK] Config files are now read-only
echo To edit: attrib -R [filename]
goto :exit

:backup_configs
echo.
echo Creating backup of config files...
if not exist "backups" mkdir backups
copy "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml" "backups\asmo-foodservice-docker-compose-%date:~-4,4%%date:~-10,2%%date:~-7,2%.yml" >nul
copy "nginx\conf.d\asmo-foodservice.conf" "backups\asmo-foodservice-nginx-%date:~-4,4%%date:~-10,2%%date:~-7,2%.conf" >nul 2>nul
echo [OK] Backup created in backups\ folder
goto :exit

:disable_auto_scripts
echo.
echo Temporarily disabling auto-scripts...
if exist "scripts\auto-monitor.bat" ren "scripts\auto-monitor.bat" "scripts\auto-monitor.bat.disabled"
if exist "scripts\auto-discovery.bat" ren "scripts\auto-discovery.bat" "scripts\auto-discovery.bat.disabled"
if exist "scripts\auto-platform.bat" ren "scripts\auto-platform.bat" "scripts\auto-platform.bat.disabled"
echo [OK] Auto-scripts disabled (renamed with .disabled extension)
echo To re-enable: Remove .disabled extension from script names
goto :exit

:show_history
echo.
echo File modification history...
echo ========================================
echo asmo-foodservice docker-compose.yml:
dir "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml" | findstr "docker-compose"
echo.
echo Recent git changes:
git log --oneline -5 "platforms\asmo-foodservice\" 2>nul || echo "No git history available"
goto :exit

:exit
echo.
echo ========================================
echo Protection Tool Complete
echo ========================================
echo.
echo Tips to prevent auto-modification:
echo 1. Check VS Code extensions (Docker, YAML)
echo 2. Disable auto-format on save
echo 3. Use read-only mode for important configs
echo 4. Regular backups of config files
echo.
pause
