@echo off
echo ========================================
echo Fix Auto-Start Code Generation Issue
echo ========================================
echo.

echo [PROBLEM] bin\auto-start.bat automatically generates/modifies code
echo [SOLUTION] Disable auto-generation and clean up generated files
echo.

echo Step 1: Analyzing what auto-start.bat generates...
echo ================================================================

echo.
echo Functions in auto-start.bat that generate code:
echo ----------------------------------------------------------------
echo 1. :create_nginx_config_for_platform (lines 200-246)
echo    - Creates nginx config files in nginx\conf.d\
echo    - Overwrites existing configurations
echo.
echo 2. :auto_setup_all_domains (lines 167-198)
echo    - Modifies Windows hosts file
echo    - Adds domain entries automatically
echo.
echo 3. Auto-detection and creation triggers
echo    - Scans platforms and creates missing configs
echo    - May trigger other creation scripts
echo.

echo Step 2: Checking for auto-generated files...
echo ================================================================

echo.
echo Checking nginx configs that might be auto-generated:
for /d %%i in (platforms\*) do (
    if exist "nginx\conf.d\%%~ni.conf" (
        findstr /C:"Auto-generated" "nginx\conf.d\%%~ni.conf" >nul 2>&1
        if not errorlevel 1 (
            echo [AUTO-GENERATED] nginx\conf.d\%%~ni.conf
        ) else (
            echo [MANUAL] nginx\conf.d\%%~ni.conf
        )
    )
)

echo.
echo Checking for placeholder files in projects:
for /d %%i in (projects\*) do (
    if exist "%%i\index.php" (
        findstr /C:"Auto-generated\|placeholder" "%%i\index.php" >nul 2>&1
        if not errorlevel 1 (
            echo [AUTO-GENERATED] %%i\index.php
        )
    )
)

echo.
echo Step 3: Options to fix the issue...
echo ================================================================
echo.
echo [1] Create safe version of auto-start.bat (no code generation)
echo [2] Backup and disable auto-generation functions
echo [3] Clean up auto-generated files
echo [4] Show detailed analysis of auto-start.bat
echo [5] Exit without changes
echo.
set /p choice="Choose option (1-5): "

if "%choice%"=="1" goto :create_safe_version
if "%choice%"=="2" goto :disable_auto_generation
if "%choice%"=="3" goto :cleanup_generated
if "%choice%"=="4" goto :detailed_analysis
if "%choice%"=="5" goto :exit

:create_safe_version
echo.
echo Creating safe version of auto-start.bat...
echo ================================================================

echo Creating backup of original auto-start.bat...
if not exist "backups" mkdir backups
copy "bin\auto-start.bat" "backups\auto-start-original-%date:~-4,4%%date:~-10,2%%date:~-7,2%.bat" >nul
echo [OK] Backup created: backups\auto-start-original-*.bat

echo.
echo Creating safe version without code generation...
(
echo @echo off
echo REM Docker Master Platform - Safe Auto Start ^(No Code Generation^)
echo REM Modified version that does NOT generate or modify code
echo.
echo echo.
echo echo ========================================
echo echo   DOCKER MASTER - SAFE AUTO START
echo echo ========================================
echo echo.
echo.
echo echo 🚀 SAFE AUTO STARTING DOCKER MASTER PLATFORM
echo echo ================================================================
echo.
echo echo ℹ️  This script will:
echo echo   • Start all core services
echo echo   • Start all platforms ^(without modifying configs^)
echo echo   • Test connectivity
echo echo   • Open platforms in browser
echo echo   • NO automatic code generation
echo.
echo echo.
echo echo 🔍 Step 1: Check Docker Desktop
echo echo ----------------------------------------------------------------
echo.
echo echo Checking Docker Desktop status...
echo docker ps ^>nul 2^>^&1
echo if errorlevel 1 ^(
echo     echo ❌ Docker Desktop is not running!
echo     echo.
echo     echo 💡 Please start Docker Desktop first
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo ✅ Docker Desktop is running
echo.
echo echo.
echo echo 🗄️ Step 2: Start core services
echo echo ----------------------------------------------------------------
echo.
echo echo Starting core services ^(MySQL, PostgreSQL, Redis, Nginx^)...
echo docker-compose -f docker-compose.low-ram.yml up -d
echo.
echo echo ⏳ Waiting for core services to initialize...
echo timeout /t 10 /nobreak ^>nul
echo.
echo echo.
echo echo 🚀 Step 3: Start all platforms ^(NO CONFIG GENERATION^)
echo echo ----------------------------------------------------------------
echo.
echo echo Starting all existing platforms...
echo for /d %%%%i in ^(platforms\*^) do ^(
echo     if exist "platforms\%%%%~ni\docker-compose.%%%%~ni.yml" ^(
echo         echo Starting platform: %%%%~ni
echo         cd platforms\%%%%~ni
echo         docker-compose -f docker-compose.%%%%~ni.yml up -d
echo         cd ..\..
echo     ^)
echo ^)
echo.
echo echo ⏳ Waiting for platforms to start...
echo timeout /t 15 /nobreak ^>nul
echo.
echo echo.
echo echo 🔄 Step 4: Reload Nginx ^(existing configs only^)
echo echo ----------------------------------------------------------------
echo.
echo echo Reloading Nginx with existing configurations...
echo docker exec nginx_proxy_low_ram nginx -s reload ^>nul 2^>^&1
echo if not errorlevel 1 ^(
echo     echo ✅ Nginx reloaded
echo ^) else ^(
echo     echo ⚠️  Nginx reload failed, doing restart...
echo     docker restart nginx_proxy_low_ram ^>nul 2^>^&1
echo     timeout /t 5 /nobreak ^>nul
echo     echo ✅ Nginx restarted
echo ^)
echo.
echo echo.
echo echo 🎉 SAFE AUTO START COMPLETED!
echo echo ================================================================
echo.
echo echo 📊 RUNNING PLATFORMS:
echo echo ----------------------------------------------------------------
echo docker ps --filter "name=_php" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo echo.
echo echo 🌐 ACCESS URLS:
echo echo ----------------------------------------------------------------
echo.
echo echo 📝 Direct Port Access:
echo for /d %%%%i in ^(platforms\*^) do ^(
echo     if exist "platforms\%%%%~ni\docker-compose.%%%%~ni.yml" ^(
echo         for /f "tokens=2 delims=:" %%%%p in ^(^'findstr /C:":80" "platforms\%%%%~ni\docker-compose.%%%%~ni.yml" 2^^^>nul ^^^| findstr /v "expose"^'^) do ^(
echo             echo   • %%%%~ni: http://localhost:%%%%p
echo         ^)
echo     ^)
echo ^)
echo.
echo echo.
echo echo 💡 MANUAL CONFIGURATION:
echo echo ----------------------------------------------------------------
echo echo   • Setup domains: scripts\setup-domains.bat
echo echo   • Create nginx configs: scripts\create-nginx-configs.bat
echo echo   • View logs: docker logs [container-name]
echo.
echo echo.
echo echo 🌟 DOCKER MASTER PLATFORM READY ^(SAFE MODE^)!
echo echo    All platforms started without code generation!
echo.
echo pause
echo exit /b 0
) > "bin\auto-start-safe.bat"

echo [OK] Created: bin\auto-start-safe.bat

echo.
echo Renaming original auto-start.bat to auto-start-original.bat...
ren "bin\auto-start.bat" "auto-start-original.bat" 2>nul
ren "bin\auto-start-safe.bat" "auto-start.bat" 2>nul

echo [OK] Original auto-start.bat renamed and replaced with safe version

goto :exit

:disable_auto_generation
echo.
echo Disabling auto-generation functions in auto-start.bat...
echo ================================================================

echo Creating backup...
if not exist "backups" mkdir backups
copy "bin\auto-start.bat" "backups\auto-start-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.bat" >nul

echo.
echo Commenting out auto-generation functions...

REM Create modified version with auto-generation disabled
powershell -Command "(Get-Content 'bin\auto-start.bat') -replace 'call :create_nginx_config_for_platform', 'REM DISABLED: call :create_nginx_config_for_platform' | Set-Content 'bin\auto-start-modified.bat'"

powershell -Command "(Get-Content 'bin\auto-start-modified.bat') -replace 'call :auto_setup_all_domains', 'REM DISABLED: call :auto_setup_all_domains' | Set-Content 'bin\auto-start-modified2.bat'"

move "bin\auto-start-modified2.bat" "bin\auto-start.bat" >nul
del "bin\auto-start-modified.bat" 2>nul

echo [OK] Auto-generation functions disabled

goto :exit

:cleanup_generated
echo.
echo Cleaning up auto-generated files...
echo ================================================================

set /p confirm="This will remove auto-generated files. Continue? (y/N): "
if /i not "%confirm%"=="y" goto :exit

echo.
echo Removing auto-generated nginx configs...
for /d %%i in (platforms\*) do (
    if exist "nginx\conf.d\%%~ni.conf" (
        findstr /C:"Auto-generated" "nginx\conf.d\%%~ni.conf" >nul 2>&1
        if not errorlevel 1 (
            echo Removing auto-generated: nginx\conf.d\%%~ni.conf
            del "nginx\conf.d\%%~ni.conf" 2>nul
        )
    )
)

echo.
echo Removing auto-generated placeholder files...
for /d %%i in (projects\*) do (
    if exist "%%i\index.php" (
        findstr /C:"Auto-generated\|placeholder" "%%i\index.php" >nul 2>&1
        if not errorlevel 1 (
            echo Removing auto-generated: %%i\index.php
            del "%%i\index.php" 2>nul
        )
    )
)

echo [OK] Auto-generated files cleaned up

goto :exit

:detailed_analysis
echo.
echo Detailed Analysis of auto-start.bat
echo ================================================================

echo.
echo Functions that generate/modify code:
echo ----------------------------------------------------------------

echo.
echo 1. :create_nginx_config_for_platform (lines 200-246)
echo    Purpose: Creates nginx configuration files
echo    Location: nginx\conf.d\[platform].conf
echo    Risk: Overwrites existing nginx configurations
echo.

echo 2. :auto_setup_all_domains (lines 167-198)
echo    Purpose: Adds domain entries to Windows hosts file
echo    Location: C:\Windows\System32\drivers\etc\hosts
echo    Risk: Modifies system hosts file
echo.

echo 3. Auto-detection triggers (lines 70-74)
echo    Purpose: Calls config creation if files don't exist
echo    Risk: May trigger other creation scripts
echo.

echo.
echo Files that may be auto-generated:
echo ----------------------------------------------------------------
for /d %%i in (platforms\*) do (
    echo Platform: %%~ni
    if exist "nginx\conf.d\%%~ni.conf" (
        echo   - nginx\conf.d\%%~ni.conf
        findstr /C:"Auto-generated" "nginx\conf.d\%%~ni.conf" >nul 2>&1
        if not errorlevel 1 (
            echo     [AUTO-GENERATED] - Created by script
        ) else (
            echo     [MANUAL] - Created manually
        )
    ) else (
        echo   - nginx\conf.d\%%~ni.conf [MISSING]
    )
    echo.
)

pause
goto :exit

:exit
echo.
echo ========================================
echo Fix Auto-Start Complete
echo ========================================
echo.
echo Summary of available fixes:
echo 1. Safe version: bin\auto-start-safe.bat (no code generation)
echo 2. Disabled functions: Comments out auto-generation
echo 3. Cleanup: Removes auto-generated files
echo.
echo Recommendations:
echo - Use safe version for daily operations
echo - Create nginx configs manually when needed
echo - Setup domains manually with scripts\setup-domains.bat
echo.
pause
