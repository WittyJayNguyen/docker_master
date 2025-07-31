@echo off
echo ========================================
echo Fix Volumes Auto-Creation Issue
echo ========================================
echo.

echo [PROBLEM] Docker volumes automatically create project directories
echo [SOLUTION] Clean up unwanted directories and fix volume paths
echo.

echo Step 1: Analyzing current volume configurations...
echo ================================================================

echo.
echo Current platforms and their volume mappings:
echo.

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo Platform: %%~ni
        findstr /C:"../../projects/" "%%i\docker-compose.*.yml" 2>nul | findstr /V "#"
        echo.
    )
)

echo.
echo Step 2: Checking for unwanted project directories...
echo ================================================================

echo.
echo Project directories that might be auto-created:
for /d %%i in (projects\*) do (
    if not exist "%%i\index.php" if not exist "%%i\wordpress" if not exist "%%i\web" if not exist "%%i\html" if not exist "%%i\code" (
        echo [SUSPICIOUS] %%i - Might be auto-created by Docker
    )
)

echo.
echo Step 3: Options to fix the issue...
echo ================================================================
echo.
echo [1] Stop all containers and clean up auto-created directories
echo [2] Fix volume paths to use existing project structures
echo [3] Create .dockerignore to prevent auto-creation
echo [4] Show detailed analysis of each platform
echo [5] Exit without changes
echo.
set /p choice="Choose option (1-5): "

if "%choice%"=="1" goto :cleanup_auto_created
if "%choice%"=="2" goto :fix_volume_paths
if "%choice%"=="3" goto :create_dockerignore
if "%choice%"=="4" goto :detailed_analysis
if "%choice%"=="5" goto :exit

:cleanup_auto_created
echo.
echo Stopping all containers first...
docker-compose down 2>nul
for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        docker-compose -f "%%i\docker-compose.*.yml" down 2>nul
    )
)

echo.
echo Cleaning up auto-created directories...
echo ================================================================

REM List of directories that are likely auto-created and empty/minimal
for /d %%i in (projects\*) do (
    set "dir_name=%%~ni"
    
    REM Check if directory is likely auto-created (empty or only has basic files)
    set "file_count=0"
    for /f %%f in ('dir /b "%%i" 2^>nul ^| find /c /v ""') do set "file_count=%%f"
    
    if !file_count! LEQ 2 (
        echo Checking: %%i
        if not exist "%%i\wordpress" if not exist "%%i\web" if not exist "%%i\html" if not exist "%%i\code" if not exist "%%i\src" (
            echo [REMOVING] %%i - Appears to be auto-created
            rmdir /s /q "%%i" 2>nul
        )
    )
)

echo.
echo Cleanup completed!
goto :exit

:fix_volume_paths
echo.
echo Fixing volume paths in docker-compose files...
echo ================================================================

REM Create backup first
if not exist "backups" mkdir backups
echo Creating backups...

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        copy "%%i\docker-compose.*.yml" "backups\%%~ni-docker-compose-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.yml" >nul
        echo Backed up: %%~ni
    )
)

echo.
echo Analyzing and suggesting fixes for each platform...

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo.
        echo Platform: %%~ni
        echo Current volume mapping:
        findstr /C:"../../projects/" "%%i\docker-compose.*.yml" 2>nul
        
        REM Check what actually exists in projects
        if exist "projects\%%~ni\wordpress" (
            echo [OK] WordPress structure exists
        ) else if exist "projects\%%~ni\web" (
            echo [OK] Laravel/Web structure exists  
        ) else if exist "projects\%%~ni\html" (
            echo [OK] HTML structure exists
        ) else if exist "projects\%%~ni\code" (
            echo [OK] Code structure exists
        ) else (
            echo [ISSUE] No proper project structure found
            echo [SUGGESTION] Create proper structure or update volume path
        )
    )
)

goto :exit

:create_dockerignore
echo.
echo Creating .dockerignore to prevent auto-creation...
echo ================================================================

(
echo # Prevent Docker from auto-creating directories
echo projects/*/
echo !projects/*/wordpress/
echo !projects/*/web/
echo !projects/*/html/
echo !projects/*/code/
echo !projects/*/src/
echo.
echo # Logs and data directories
echo logs/*/
echo data/*/
echo.
echo # Temporary files
echo *.tmp
echo *.log
echo .DS_Store
echo Thumbs.db
) > .dockerignore

echo [OK] .dockerignore created
echo.
echo Also creating .gitignore entries...

if not exist ".gitignore" (
    echo # Auto-created project directories > .gitignore
) else (
    echo. >> .gitignore
    echo # Auto-created project directories >> .gitignore
)

echo projects/*/logs/ >> .gitignore
echo projects/*/cache/ >> .gitignore
echo projects/*/tmp/ >> .gitignore

echo [OK] .gitignore updated
goto :exit

:detailed_analysis
echo.
echo Detailed Analysis of Each Platform
echo ================================================================

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo.
        echo ========================================
        echo Platform: %%~ni
        echo ========================================
        
        echo Docker Compose File:
        type "%%i\docker-compose.*.yml" | findstr /N /C:"volumes:" /A:5 /B:5
        
        echo.
        echo Project Directory Status:
        if exist "projects\%%~ni" (
            echo [EXISTS] projects\%%~ni
            echo Contents:
            dir "projects\%%~ni" /b 2>nul
            
            echo.
            echo Subdirectories:
            for /d %%j in (projects\%%~ni\*) do (
                echo   - %%~nj
            )
        ) else (
            echo [MISSING] projects\%%~ni
        )
        
        echo.
        echo Logs Directory:
        if exist "logs\apache\%%~ni" (
            echo [EXISTS] logs\apache\%%~ni
        ) else (
            echo [MISSING] logs\apache\%%~ni
        )
        
        echo.
        echo Data Directory:
        if exist "data\uploads\%%~ni" (
            echo [EXISTS] data\uploads\%%~ni
        ) else (
            echo [MISSING] data\uploads\%%~ni
        )
        
        echo.
        pause
    )
)

goto :exit

:exit
echo.
echo ========================================
echo Volume Fix Tool Complete
echo ========================================
echo.
echo Summary of recommendations:
echo 1. Stop containers before making changes
echo 2. Clean up auto-created empty directories
echo 3. Ensure proper project structure exists
echo 4. Use .dockerignore to prevent auto-creation
echo 5. Regular cleanup of unwanted directories
echo.
echo Next steps:
echo - Review your project structures
echo - Update volume paths if needed
echo - Consider using named volumes instead of bind mounts
echo.
pause
