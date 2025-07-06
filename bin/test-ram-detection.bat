@echo off
setlocal enabledelayedexpansion

REM Test RAM Detection Script
REM Tests RAM detection on different systems

echo ========================================
echo   RAM Detection Test
echo ========================================
echo.

echo [TEST 1] PowerShell Method:
for /f %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB"') do (
    set /a ram_ps=%%i
    echo   Result: !ram_ps!GB
)

echo.
echo [TEST 2] WMIC Method:
for /f "tokens=2 delims==" %%i in ('wmic computersystem get TotalPhysicalMemory /value 2^>nul ^| find "="') do (
    set /a ram_wmic=%%i/1024/1024/1024
    echo   Result: !ram_wmic!GB
)

echo.
echo [TEST 3] System Info Method:
for /f "tokens=2 delims=:" %%i in ('systeminfo ^| find "Total Physical Memory"') do (
    set ram_info=%%i
    echo   Result: !ram_info!
)

echo.
echo [SUMMARY]
echo PowerShell: !ram_ps!GB
echo WMIC:       !ram_wmic!GB
echo SystemInfo: !ram_info!

echo.
echo [AUTO-OPTIMIZATION PROFILES]
echo.

REM Test different RAM scenarios
for %%r in (2 4 8 16 32 64) do (
    echo RAM: %%rGB
    if %%r LEQ 4 (
        echo   Profile: Low RAM ^(Conservative^)
        echo   MySQL InnoDB: ~200MB, PHP: 256MB, OPcache: 64MB
    ) else if %%r LEQ 8 (
        echo   Profile: Medium RAM ^(Balanced^)
        echo   MySQL InnoDB: ~400MB, PHP: 512MB, OPcache: 128MB
    ) else if %%r LEQ 16 (
        echo   Profile: High RAM ^(Performance^)
        echo   MySQL InnoDB: ~1GB, PHP: 1GB, OPcache: 256MB
    ) else (
        echo   Profile: Very High RAM ^(Maximum Performance^)
        echo   MySQL InnoDB: ~2GB, PHP: 2GB, OPcache: 512MB
    )
    echo.
)

pause
