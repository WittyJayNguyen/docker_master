@echo off
echo ========================================
echo Prevent Code Auto-Generation Tool
echo ========================================
echo.

echo This tool helps identify and prevent scripts from auto-generating code
echo.

echo [1] Scan all scripts for code generation functions
echo [2] Disable auto-generation in specific scripts
echo [3] Create safe versions of problematic scripts
echo [4] Monitor for code generation activity
echo [5] Exit
echo.
set /p choice="Choose option (1-5): "

if "%choice%"=="1" goto :scan_scripts
if "%choice%"=="2" goto :disable_generation
if "%choice%"=="3" goto :create_safe_versions
if "%choice%"=="4" goto :monitor_activity
if "%choice%"=="5" goto :exit

:scan_scripts
echo.
echo Scanning all scripts for code generation functions...
echo ================================================================

echo.
echo Scripts that may generate code:
echo ----------------------------------------------------------------

REM Scan for scripts with code generation patterns
for /r %%f in (*.bat) do (
    findstr /C:"echo.*>" "%%f" >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo File: %%f
        echo Code generation patterns found:
        findstr /N /C:"echo.*>" "%%f" | head -3
    )
)

echo.
echo Scripts with file creation patterns:
echo ----------------------------------------------------------------

for /r %%f in (*.bat) do (
    findstr /C:") >" "%%f" >nul 2>&1
    if not errorlevel 1 (
        echo.
        echo File: %%f
        echo File creation patterns:
        findstr /N /C:") >" "%%f" | head -2
    )
)

echo.
echo Scripts that modify project files:
echo ----------------------------------------------------------------

for /r %%f in (*.bat) do (
    findstr /C:"projects\\" "%%f" >nul 2>&1
    if not errorlevel 1 (
        findstr /C:"echo\|copy\|move\|del" "%%f" >nul 2>&1
        if not errorlevel 1 (
            echo.
            echo File: %%f
            echo May modify project files
        )
    )
)

pause
goto :exit

:disable_generation
echo.
echo Disable auto-generation in specific scripts...
echo ================================================================

echo.
echo Scripts with known auto-generation:
echo ----------------------------------------------------------------
echo 1. bin\auto-start.bat (FIXED - safe version created)
echo 2. scripts\auto-platform.bat
echo 3. scripts\create-platform.bat
echo 4. scripts\auto-setup-project.bat
echo 5. bin\create.bat
echo.

echo Which script would you like to disable auto-generation for?
echo [1] auto-platform.bat
echo [2] create-platform.bat
echo [3] auto-setup-project.bat
echo [4] create.bat
echo [5] All of the above
echo [6] Back to main menu
echo.
set /p script_choice="Choose (1-6): "

if "%script_choice%"=="1" call :disable_auto_platform
if "%script_choice%"=="2" call :disable_create_platform
if "%script_choice%"=="3" call :disable_auto_setup
if "%script_choice%"=="4" call :disable_create
if "%script_choice%"=="5" call :disable_all_scripts
if "%script_choice%"=="6" goto :exit

goto :exit

:disable_auto_platform
echo.
echo Disabling auto-generation in auto-platform.bat...
if not exist "backups" mkdir backups
copy "scripts\auto-platform.bat" "backups\auto-platform-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.bat" >nul

REM Comment out code generation lines
powershell -Command "(Get-Content 'scripts\auto-platform.bat') -replace '^(.*echo.*>.*projects.*)$', 'REM DISABLED: $1' | Set-Content 'scripts\auto-platform-safe.bat'"

echo [OK] Safe version created: scripts\auto-platform-safe.bat
exit /b 0

:disable_create_platform
echo.
echo Disabling auto-generation in create-platform.bat...
if not exist "backups" mkdir backups
copy "scripts\create-platform.bat" "backups\create-platform-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.bat" >nul

powershell -Command "(Get-Content 'scripts\create-platform.bat') -replace '^(.*echo.*>.*projects.*)$', 'REM DISABLED: $1' | Set-Content 'scripts\create-platform-safe.bat'"

echo [OK] Safe version created: scripts\create-platform-safe.bat
exit /b 0

:disable_auto_setup
echo.
echo Disabling auto-generation in auto-setup-project.bat...
if not exist "backups" mkdir backups
copy "scripts\auto-setup-project.bat" "backups\auto-setup-project-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.bat" >nul

powershell -Command "(Get-Content 'scripts\auto-setup-project.bat') -replace '^(.*echo.*>.*projects.*)$', 'REM DISABLED: $1' | Set-Content 'scripts\auto-setup-project-safe.bat'"

echo [OK] Safe version created: scripts\auto-setup-project-safe.bat
exit /b 0

:disable_create
echo.
echo Disabling auto-generation in create.bat...
if not exist "backups" mkdir backups
copy "bin\create.bat" "backups\create-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.bat" >nul

powershell -Command "(Get-Content 'bin\create.bat') -replace '^(.*echo.*>.*projects.*)$', 'REM DISABLED: $1' | Set-Content 'bin\create-safe.bat'"

echo [OK] Safe version created: bin\create-safe.bat
exit /b 0

:disable_all_scripts
echo.
echo Disabling auto-generation in all scripts...
call :disable_auto_platform
call :disable_create_platform
call :disable_auto_setup
call :disable_create
echo [OK] All scripts have safe versions created
exit /b 0

:create_safe_versions
echo.
echo Creating safe versions of all problematic scripts...
echo ================================================================

echo.
echo Creating safe versions that only start containers without code generation...

REM Create safe auto-platform.bat
(
echo @echo off
echo REM Safe Auto Platform - No Code Generation
echo echo This is a safe version that starts platforms without generating code
echo echo Use manual configuration for nginx and project setup
echo.
echo echo Starting platforms only...
echo for /d %%%%i in ^(platforms\*^) do ^(
echo     if exist "platforms\%%%%~ni\docker-compose.%%%%~ni.yml" ^(
echo         echo Starting platform: %%%%~ni
echo         cd platforms\%%%%~ni
echo         docker-compose -f docker-compose.%%%%~ni.yml up -d
echo         cd ..\..
echo     ^)
echo ^)
echo.
echo echo Platforms started. Manual configuration required for:
echo echo - Nginx configs: nginx\conf.d\
echo echo - Domain setup: scripts\setup-domains.bat
echo pause
) > "scripts\auto-platform-safe-only.bat"

echo [OK] Created: scripts\auto-platform-safe-only.bat

REM Create safe create.bat
(
echo @echo off
echo REM Safe Create - No Code Generation
echo echo This is a safe version that does not generate code
echo echo.
echo echo To create a new platform:
echo echo 1. Manually create project structure in projects\[name]\
echo echo 2. Copy docker-compose template from templates\
echo echo 3. Configure nginx manually
echo echo 4. Setup domains with scripts\setup-domains.bat
echo echo.
echo echo Use the original scripts only if you want auto-generation
echo pause
) > "bin\create-safe-only.bat"

echo [OK] Created: bin\create-safe-only.bat

echo [OK] All safe versions created
goto :exit

:monitor_activity
echo.
echo Starting code generation monitor...
echo ================================================================

echo This will monitor for file changes that might indicate code generation
echo Press Ctrl+C to stop monitoring
echo.

:monitor_loop
echo [%time%] Checking for new files...

REM Check for new files in projects
for /d %%i in (projects\*) do (
    for %%f in ("%%i\*") do (
        forfiles /p "%%i" /m "%%~nxf" /d +0 >nul 2>&1
        if not errorlevel 1 (
            echo [ALERT] New file detected: %%f
        )
    )
)

REM Check for new nginx configs
for %%f in (nginx\conf.d\*.conf) do (
    forfiles /p "nginx\conf.d" /m "%%~nxf" /d +0 >nul 2>&1
    if not errorlevel 1 (
        findstr /C:"Auto-generated" "%%f" >nul 2>&1
        if not errorlevel 1 (
            echo [ALERT] Auto-generated nginx config: %%f
        )
    )
)

timeout /t 5 /nobreak >nul
goto :monitor_loop

:exit
echo.
echo ========================================
echo Prevention Tool Complete
echo ========================================
echo.
echo Summary of actions available:
echo.
echo Safe versions created:
echo - bin\auto-start.bat (replaced with safe version)
echo - scripts\*-safe.bat (safe versions of scripts)
echo.
echo Manual alternatives:
echo - Start containers: docker-compose up -d
echo - Setup domains: scripts\setup-domains.bat
echo - Create nginx configs: Copy from templates
echo.
echo Prevention tips:
echo 1. Always use safe versions for daily operations
echo 2. Create project structures manually
echo 3. Review scripts before running them
echo 4. Use monitoring to detect unwanted changes
echo.
pause
