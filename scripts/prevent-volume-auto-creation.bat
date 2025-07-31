@echo off
echo ========================================
echo Prevent Volume Auto-Creation Tool
echo ========================================
echo.

echo This tool helps prevent Docker from auto-creating unwanted directories
echo when mounting volumes in your platforms.
echo.

echo [1] Check current volume configurations
echo [2] Create missing project structures
echo [3] Fix problematic volume paths
echo [4] Monitor for auto-creation
echo [5] Exit
echo.
set /p choice="Choose option (1-5): "

if "%choice%"=="1" goto :check_volumes
if "%choice%"=="2" goto :create_structures
if "%choice%"=="3" goto :fix_paths
if "%choice%"=="4" goto :monitor
if "%choice%"=="5" goto :exit

:check_volumes
echo.
echo Checking volume configurations...
echo ================================================================

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo.
        echo Platform: %%~ni
        echo ----------------------------------------
        
        REM Get volume mappings
        for /f "tokens=*" %%j in ('findstr /C:"../../projects/" "%%i\docker-compose.*.yml" 2^>nul') do (
            echo Volume: %%j
            
            REM Extract source path (before colon)
            for /f "tokens=1 delims=:" %%k in ("%%j") do (
                set "source_path=%%k"
                set "source_path=!source_path:~6!"
                set "source_path=!source_path: =!"
                
                if exist "!source_path!" (
                    echo [OK] Source exists: !source_path!
                ) else (
                    echo [WARNING] Source missing: !source_path!
                    echo [RISK] Docker will auto-create this directory
                )
            )
        )
    )
)

echo.
pause
goto :exit

:create_structures
echo.
echo Creating missing project structures...
echo ================================================================

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo.
        echo Checking platform: %%~ni
        
        REM Check what type of project structure is expected
        findstr /C:"wordpress" "%%i\docker-compose.*.yml" >nul
        if not errorlevel 1 (
            echo Type: WordPress project
            if not exist "projects\%%~ni\wordpress" (
                echo Creating WordPress structure...
                mkdir "projects\%%~ni\wordpress" 2>nul
                echo ^<?php echo 'WordPress placeholder for %%~ni'; ?^> > "projects\%%~ni\wordpress\index.php"
                echo [CREATED] projects\%%~ni\wordpress
            )
        ) else (
            findstr /C:"/web:" "%%i\docker-compose.*.yml" >nul
            if not errorlevel 1 (
                echo Type: Laravel/Web project
                if not exist "projects\%%~ni\web" (
                    echo Creating web structure...
                    mkdir "projects\%%~ni\web" 2>nul
                    echo ^<?php echo 'Web placeholder for %%~ni'; ?^> > "projects\%%~ni\web\index.php"
                    echo [CREATED] projects\%%~ni\web
                )
            ) else (
                echo Type: Generic project
                if not exist "projects\%%~ni" (
                    echo Creating generic structure...
                    mkdir "projects\%%~ni" 2>nul
                    echo ^<?php echo 'Project placeholder for %%~ni'; ?^> > "projects\%%~ni\index.php"
                    echo [CREATED] projects\%%~ni
                )
            )
        )
    )
)

echo.
echo [OK] Project structures created
pause
goto :exit

:fix_paths
echo.
echo Fixing problematic volume paths...
echo ================================================================

echo Creating backup first...
if not exist "backups" mkdir backups

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        copy "%%i\docker-compose.*.yml" "backups\%%~ni-path-fix-%date:~-4,4%%date:~-10,2%%date:~-7,2%.yml" >nul
        echo Backed up: %%~ni
        
        REM Analyze and suggest fixes
        echo.
        echo Platform: %%~ni
        echo Current volumes:
        findstr /C:"../../projects/" "%%i\docker-compose.*.yml"
        
        REM Check if we need to fix the path
        findstr /C:"../../projects/%%~ni:" "%%i\docker-compose.*.yml" >nul
        if not errorlevel 1 (
            echo [ISSUE] Direct mount to project root - may cause auto-creation
            echo [SUGGESTION] Use subdirectory like /web or /html
        )
    )
)

echo.
echo [INFO] Manual review recommended for volume paths
echo Check the backup files and modify paths as needed
pause
goto :exit

:monitor
echo.
echo Starting volume auto-creation monitor...
echo ================================================================

echo This will monitor the projects directory for new auto-created folders
echo Press Ctrl+C to stop monitoring
echo.

:monitor_loop
for /d %%i in (projects\*) do (
    set "suspicious=true"
    
    REM Check if directory has legitimate content
    if exist "%%i\wordpress" set "suspicious=false"
    if exist "%%i\web" set "suspicious=false"
    if exist "%%i\html" set "suspicious=false"
    if exist "%%i\code" set "suspicious=false"
    if exist "%%i\src" set "suspicious=false"
    if exist "%%i\index.php" set "suspicious=false"
    if exist "%%i\package.json" set "suspicious=false"
    if exist "%%i\composer.json" set "suspicious=false"
    
    if "!suspicious!"=="true" (
        echo [ALERT] Suspicious directory detected: %%i
        echo Time: %date% %time%
        echo This might be auto-created by Docker
        echo.
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
echo Tips to prevent auto-creation:
echo.
echo 1. Always create project structure BEFORE starting containers
echo 2. Use specific subdirectories in volume mounts (e.g., /wordpress, /web)
echo 3. Avoid mounting directly to project root
echo 4. Use .dockerignore to control what Docker can create
echo 5. Regular monitoring and cleanup
echo.
echo Example good volume mapping:
echo   - ../../projects/my-project/web:/var/www/html
echo.
echo Example bad volume mapping:
echo   - ../../projects/my-project:/var/www/html
echo.
pause
