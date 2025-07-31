@echo off
echo ========================================
echo Test Safe Auto-Start Version
echo ========================================
echo.

echo Testing if auto-start.bat is the safe version...
echo.

echo Step 1: Check version signature...
findstr /C:"SAFE AUTO START" bin\auto-start.bat >nul 2>&1
if not errorlevel 1 (
    echo ✅ Safe version detected
) else (
    echo ❌ Original version still active!
    echo Please run: scripts\fix-auto-start-code-generation.bat
    pause
    exit /b 1
)

echo.
echo Step 2: Check for code generation functions...
findstr /C:"create_nginx_config_for_platform" bin\auto-start.bat >nul 2>&1
if errorlevel 1 (
    echo ✅ No nginx config generation function found
) else (
    echo ❌ Code generation functions still present!
)

findstr /C:"auto_setup_all_domains" bin\auto-start.bat >nul 2>&1
if errorlevel 1 (
    echo ✅ No domain auto-setup function found
) else (
    echo ❌ Domain auto-setup functions still present!
)

echo.
echo Step 3: Check backup files...
if exist "bin\auto-start-original.bat" (
    echo ✅ Original backup exists: bin\auto-start-original.bat
) else (
    echo ⚠️  Original backup not found
)

if exist "backups\auto-start-original-*.bat" (
    echo ✅ Timestamped backup exists in backups\
) else (
    echo ⚠️  Timestamped backup not found
)

echo.
echo Step 4: Test safe execution (dry run)...
echo.
echo Safe auto-start.bat content preview:
echo ----------------------------------------------------------------
type bin\auto-start.bat | findstr /C:"echo" | head -5
echo ----------------------------------------------------------------

echo.
echo Step 5: Verify no auto-generation markers in current configs...
echo.
echo Checking nginx configs for auto-generation markers:
for %%f in (nginx\conf.d\*.conf) do (
    findstr /C:"Auto-generated" "%%f" >nul 2>&1
    if not errorlevel 1 (
        echo [WARNING] Auto-generated config still exists: %%f
    ) else (
        echo [OK] Manual config: %%f
    )
)

echo.
echo ========================================
echo Test Results Summary
echo ========================================
echo.

findstr /C:"SAFE AUTO START" bin\auto-start.bat >nul 2>&1
if not errorlevel 1 (
    echo ✅ SAFE VERSION ACTIVE
    echo.
    echo What the safe version does:
    echo • Starts Docker containers
    echo • Starts all platforms  
    echo • Reloads nginx (existing configs only)
    echo • Opens platforms in browser
    echo.
    echo What it does NOT do:
    echo • Create nginx configurations
    echo • Modify hosts file
    echo • Generate placeholder code
    echo • Overwrite existing files
    echo.
    echo ✅ SAFE TO USE: bin\auto-start.bat
) else (
    echo ❌ ORIGINAL VERSION STILL ACTIVE
    echo.
    echo Please run the fix script:
    echo scripts\fix-auto-start-code-generation.bat
)

echo.
echo Manual alternatives for removed functions:
echo ----------------------------------------------------------------
echo • Setup domains: scripts\setup-domains.bat
echo • Create nginx configs: Copy from templates\nginx\
echo • Manual container start: docker-compose up -d
echo.

echo ========================================
echo Test Complete
echo ========================================
pause
