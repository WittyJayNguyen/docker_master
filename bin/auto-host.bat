@echo off
REM Docker Master Platform - Auto Host Manager for Windows
REM Tự động thêm/xóa host entries vào Windows hosts file
REM Usage: auto-host.bat [add|remove|list] [hostname] [ip]

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   DOCKER MASTER - AUTO HOST MANAGER
echo ========================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: This script requires Administrator privileges!
    echo.
    echo 💡 Please run as Administrator:
    echo   1. Right-click on Command Prompt
    echo   2. Select "Run as administrator"
    echo   3. Navigate to your project folder
    echo   4. Run: bin\auto-host.bat [command] [hostname]
    echo.
    pause
    exit /b 1
)

REM Set hosts file path
set HOSTS_FILE=%SystemRoot%\System32\drivers\etc\hosts

REM Parse command line arguments
set COMMAND=%1
set HOSTNAME=%2
set IP_ADDRESS=%3

REM Default IP if not specified
if "%IP_ADDRESS%"=="" set IP_ADDRESS=127.0.0.1

REM Show usage if no command provided
if "%COMMAND%"=="" (
    call :show_usage
    exit /b 0
)

REM Execute command
if /i "%COMMAND%"=="add" (
    call :add_host "%HOSTNAME%" "%IP_ADDRESS%"
) else if /i "%COMMAND%"=="remove" (
    call :remove_host "%HOSTNAME%"
) else if /i "%COMMAND%"=="list" (
    call :list_hosts
) else if /i "%COMMAND%"=="help" (
    call :show_usage
) else (
    echo ❌ Unknown command: %COMMAND%
    echo.
    call :show_usage
    exit /b 1
)

exit /b 0

:show_usage
echo 🚀 Docker Master Platform - Auto Host Manager
echo.
echo 📝 USAGE:
echo   auto-host.bat add [hostname] [ip]     - Add host entry
echo   auto-host.bat remove [hostname]       - Remove host entry  
echo   auto-host.bat list                    - List all custom hosts
echo   auto-host.bat help                    - Show this help
echo.
echo 💡 EXAMPLES:
echo   auto-host.bat add my-shop.local
echo   auto-host.bat add api.local 192.168.1.100
echo   auto-host.bat remove my-shop.local
echo   auto-host.bat list
echo.
echo 🌐 COMMON DOCKER MASTER HOSTS:
echo   auto-host.bat add my-blog.io
echo   auto-host.bat add my-shop.io  
echo   auto-host.bat add user-api.io
echo   auto-host.bat add admin-panel.io
echo.
exit /b 0

:add_host
set HOST_NAME=%~1
set HOST_IP=%~2

if "%HOST_NAME%"=="" (
    echo ❌ ERROR: Hostname is required!
    echo Usage: auto-host.bat add [hostname] [ip]
    exit /b 1
)

echo 🔍 Checking if host already exists: %HOST_NAME%

REM Check if host already exists
findstr /C:"%HOST_NAME%" "%HOSTS_FILE%" >nul 2>&1
if not errorlevel 1 (
    echo ⚠️  Host '%HOST_NAME%' already exists in hosts file
    echo.
    echo Current entry:
    findstr /C:"%HOST_NAME%" "%HOSTS_FILE%"
    echo.
    set /p OVERWRITE="Do you want to update it? (y/N): "
    if /i not "!OVERWRITE!"=="y" (
        echo ❌ Operation cancelled
        exit /b 0
    )
    
    REM Remove existing entry first
    call :remove_host "%HOST_NAME%" silent
)

echo 📝 Adding host entry: %HOST_IP% %HOST_NAME%

REM Create backup
copy "%HOSTS_FILE%" "%HOSTS_FILE%.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%" >nul 2>&1

REM Add new entry with comment
echo. >> "%HOSTS_FILE%"
echo # Docker Master Platform - Added by auto-host.bat on %date% %time% >> "%HOSTS_FILE%"
echo %HOST_IP% %HOST_NAME% >> "%HOSTS_FILE%"

REM Verify addition
findstr /C:"%HOST_NAME%" "%HOSTS_FILE%" >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: Failed to add host entry
    exit /b 1
) else (
    echo ✅ SUCCESS: Host '%HOST_NAME%' added successfully!
    echo.
    echo 🌐 You can now access: http://%HOST_NAME%
    echo 🔄 DNS cache will be flushed automatically...

    REM Flush DNS cache
    ipconfig /flushdns >nul 2>&1
    echo ✅ DNS cache flushed
)

exit /b 0

:remove_host
set HOST_NAME=%~1
set SILENT_MODE=%~2

if "%HOST_NAME%"=="" (
    echo ❌ ERROR: Hostname is required!
    echo Usage: auto-host.bat remove [hostname]
    exit /b 1
)

if not "%SILENT_MODE%"=="silent" (
    echo 🗑️  Removing host entry: %HOST_NAME%
)

REM Check if host exists
findstr /C:"%HOST_NAME%" "%HOSTS_FILE%" >nul 2>&1
if errorlevel 1 (
    if not "%SILENT_MODE%"=="silent" (
        echo ⚠️  Host '%HOST_NAME%' not found in hosts file
    )
    exit /b 0
)

REM Create backup
copy "%HOSTS_FILE%" "%HOSTS_FILE%.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%" >nul 2>&1

REM Create temporary file without the host entry
set TEMP_FILE=%TEMP%\hosts_temp_%RANDOM%
type nul > "%TEMP_FILE%"

for /f "usebackq delims=" %%a in ("%HOSTS_FILE%") do (
    echo %%a | findstr /C:"%HOST_NAME%" >nul 2>&1
    if errorlevel 1 (
        echo %%a >> "%TEMP_FILE%"
    )
)

REM Replace original file
move "%TEMP_FILE%" "%HOSTS_FILE%" >nul 2>&1

if not "%SILENT_MODE%"=="silent" (
    echo ✅ SUCCESS: Host '%HOST_NAME%' removed successfully!
    echo 🔄 DNS cache will be flushed automatically...

    REM Flush DNS cache
    ipconfig /flushdns >nul 2>&1
    echo ✅ DNS cache flushed
)

exit /b 0

:list_hosts
echo 📋 Current custom host entries:
echo ================================
echo.

REM Show Docker Master Platform entries
echo 🐳 Docker Master Platform hosts:
findstr /C:"Docker Master Platform" "%HOSTS_FILE%" >nul 2>&1
if not errorlevel 1 (
    for /f "usebackq delims=" %%a in ("%HOSTS_FILE%") do (
        echo %%a | findstr /C:"Docker Master Platform" >nul 2>&1
        if not errorlevel 1 (
            REM Skip comment lines, show next line which should be the host entry
            set NEXT_IS_HOST=1
        ) else if defined NEXT_IS_HOST (
            echo   %%a
            set NEXT_IS_HOST=
        )
    )
) else (
    echo   (No Docker Master Platform hosts found)
)

echo.
echo 🌐 All custom hosts (non-system):
for /f "usebackq delims=" %%a in ("%HOSTS_FILE%") do (
    echo %%a | findstr /v /C:"#" | findstr /v /C:"localhost" | findstr /v /C:"::1" | findstr /r /C:"^[0-9]" >nul 2>&1
    if not errorlevel 1 (
        echo   %%a
    )
)

echo.
echo 💡 Use 'auto-host.bat remove [hostname]' to remove entries
exit /b 0
