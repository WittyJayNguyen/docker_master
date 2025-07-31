@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Clean Auto-Created Volume Directories
echo ========================================
echo.

echo [ISSUE] Docker automatically creates directories when mounting volumes
echo [SOLUTION] Stop containers, clean unwanted dirs, prevent future creation
echo.

echo Step 1: Stop all containers to release volume mounts...
echo ================================================================

echo Stopping main docker-compose...
docker-compose down 2>nul

echo Stopping individual platform containers...
for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo Stopping %%~ni...
        docker-compose -f "%%i\docker-compose.*.yml" down 2>nul
    )
)

echo [OK] All containers stopped
echo.

echo Step 2: Analyzing project directories...
echo ================================================================

echo.
echo Legitimate project directories (should keep):
for /d %%i in (projects\*) do (
    set "keep_dir=false"
    
    REM Check for legitimate project structures
    if exist "%%i\wordpress" set "keep_dir=true"
    if exist "%%i\web" set "keep_dir=true"
    if exist "%%i\html" set "keep_dir=true"
    if exist "%%i\code" set "keep_dir=true"
    if exist "%%i\src" set "keep_dir=true"
    if exist "%%i\package.json" set "keep_dir=true"
    if exist "%%i\composer.json" set "keep_dir=true"
    if exist "%%i\index.php" set "keep_dir=true"
    if exist "%%i\README.md" set "keep_dir=true"
    
    if "!keep_dir!"=="true" (
        echo [KEEP] %%i - Has legitimate project structure
    ) else (
        echo [REMOVE] %%i - Appears to be auto-created by Docker
    )
)

echo.
echo Step 3: Clean up auto-created directories...
echo ================================================================

set /p confirm="Do you want to remove auto-created directories? (y/N): "
if /i not "%confirm%"=="y" goto :skip_cleanup

echo.
echo Removing auto-created directories...

for /d %%i in (projects\*) do (
    set "keep_dir=false"
    
    REM Check for legitimate project structures
    if exist "%%i\wordpress" set "keep_dir=true"
    if exist "%%i\web" set "keep_dir=true"
    if exist "%%i\html" set "keep_dir=true"
    if exist "%%i\code" set "keep_dir=true"
    if exist "%%i\src" set "keep_dir=true"
    if exist "%%i\package.json" set "keep_dir=true"
    if exist "%%i\composer.json" set "keep_dir=true"
    if exist "%%i\index.php" set "keep_dir=true"
    if exist "%%i\README.md" set "keep_dir=true"
    
    if "!keep_dir!"=="false" (
        echo Removing: %%i
        rmdir /s /q "%%i" 2>nul
        if exist "%%i" (
            echo [WARNING] Could not remove %%i - may be in use
        ) else (
            echo [OK] Removed %%i
        )
    )
)

echo.
echo Cleaning up empty log directories...
for /d %%i in (logs\apache\*) do (
    dir /b "%%i" 2>nul | findstr . >nul
    if errorlevel 1 (
        echo Removing empty log dir: %%i
        rmdir "%%i" 2>nul
    )
)

echo.
echo Cleaning up empty data directories...
for /d %%i in (data\uploads\*) do (
    dir /b "%%i" 2>nul | findstr . >nul
    if errorlevel 1 (
        echo Removing empty data dir: %%i
        rmdir "%%i" 2>nul
    )
)

:skip_cleanup

echo.
echo Step 4: Create prevention measures...
echo ================================================================

echo Creating .dockerignore to prevent auto-creation...
(
echo # Prevent Docker from auto-creating project directories
echo # Only allow existing legitimate project structures
echo.
echo # Auto-created empty directories
echo projects/*/
echo !projects/*/wordpress/
echo !projects/*/web/
echo !projects/*/html/
echo !projects/*/code/
echo !projects/*/src/
echo !projects/*/public/
echo.
echo # Log and data directories
echo logs/apache/*/
echo data/uploads/*/
echo.
echo # Temporary and cache files
echo *.tmp
echo *.log
echo .DS_Store
echo Thumbs.db
echo node_modules/
echo vendor/
echo .git/
) > .dockerignore

echo [OK] .dockerignore created

echo.
echo Updating .gitignore...
if not exist ".gitignore" (
    echo # Git ignore file > .gitignore
)

REM Add entries to gitignore if they don't exist
findstr /C:"# Auto-created directories" .gitignore >nul 2>&1
if errorlevel 1 (
    echo. >> .gitignore
    echo # Auto-created directories >> .gitignore
    echo logs/apache/*/ >> .gitignore
    echo data/uploads/*/ >> .gitignore
    echo projects/*/cache/ >> .gitignore
    echo projects/*/tmp/ >> .gitignore
    echo [OK] .gitignore updated
) else (
    echo [OK] .gitignore already has auto-created entries
)

echo.
echo Step 5: Fix volume paths in docker-compose files...
echo ================================================================

echo Creating backup of docker-compose files...
if not exist "backups" mkdir backups

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        copy "%%i\docker-compose.*.yml" "backups\%%~ni-volumes-fix-%date:~-4,4%%date:~-10,2%%date:~-7,2%.yml" >nul
        echo Backed up: %%~ni
    )
)

echo.
echo Analyzing volume paths that might cause auto-creation...

for /d %%i in (platforms\*) do (
    if exist "%%i\docker-compose.*.yml" (
        echo.
        echo Platform: %%~ni
        
        REM Check current volume mapping
        for /f "tokens=*" %%j in ('findstr /C:"../../projects/" "%%i\docker-compose.*.yml" 2^>nul') do (
            echo Current: %%j
            
            REM Extract project path
            for /f "tokens=2 delims=:" %%k in ("%%j") do (
                set "vol_path=%%k"
                set "vol_path=!vol_path: =!"
                
                REM Check if target directory exists
                if exist "!vol_path!" (
                    echo [OK] Target exists: !vol_path!
                ) else (
                    echo [ISSUE] Target missing: !vol_path!
                    echo [SUGGESTION] Will be auto-created by Docker
                )
            )
        )
    )
)

echo.
echo Step 6: Create proper project structure template...
echo ================================================================

echo Creating project structure template...
if not exist "templates" mkdir templates
if not exist "templates\project-structure" mkdir templates\project-structure

(
echo # Project Structure Template
echo.
echo This template shows the recommended project structure
echo to prevent Docker from auto-creating unwanted directories.
echo.
echo ## For WordPress projects:
echo projects/[platform-name]/
echo   ├── wordpress/          ^<-- Mount point
echo   ├── docs/
echo   └── README.md
echo.
echo ## For Laravel projects:
echo projects/[platform-name]/
echo   ├── web/               ^<-- Mount point
echo   ├── docs/
echo   └── README.md
echo.
echo ## For HTML projects:
echo projects/[platform-name]/
echo   ├── html/              ^<-- Mount point
echo   ├── docs/
echo   └── README.md
) > templates\project-structure\README.md

echo [OK] Project structure template created

echo.
echo ========================================
echo Cleanup Complete!
echo ========================================
echo.
echo Summary of actions taken:
echo ✓ Stopped all containers
echo ✓ Analyzed project directories
echo ✓ Removed auto-created directories (if confirmed)
echo ✓ Created .dockerignore to prevent future auto-creation
echo ✓ Updated .gitignore
echo ✓ Backed up docker-compose files
echo ✓ Created project structure template
echo.
echo Next steps:
echo 1. Review remaining project directories
echo 2. Ensure proper project structure exists before starting containers
echo 3. Start containers: docker-compose up -d
echo.
echo Prevention tips:
echo - Always create project structure before running containers
echo - Use .dockerignore to control what Docker can create
echo - Regular cleanup of unwanted directories
echo.
pause
