@echo off
setlocal enabledelayedexpansion

REM Auto-Optimization Script
REM Automatically runs when starting the development environment
REM Detects RAM and optimizes configurations accordingly

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors
set "GREEN=[92m"
set "BLUE=[94m"
set "YELLOW=[93m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%   Docker Development Environment%NC%
echo %BLUE%        Auto RAM Optimization%NC%
echo %BLUE%========================================%NC%
echo.

REM Check if optimization has been run before
set "optimization_file=%PROJECT_ROOT%\.ram-optimized"
if exist "%optimization_file%" (
    for /f %%i in ('type "%optimization_file%"') do set last_ram=%%i
    echo %YELLOW%Previous optimization found: %last_ram%GB RAM%NC%
    echo.
)

REM Detect current RAM
echo %BLUE%[INFO]%NC% Detecting system RAM...
for /f %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB"') do (
    set /a current_ram=%%i
)

if not defined current_ram (
    echo %YELLOW%[WARNING]%NC% Could not detect RAM. Using default 8GB.
    set current_ram=8
)

echo %GREEN%[SUCCESS]%NC% Detected: %current_ram%GB RAM
echo.

REM Check if re-optimization is needed
set need_optimization=1
if exist "%optimization_file%" (
    if "%current_ram%"=="%last_ram%" (
        echo %GREEN%[INFO]%NC% System RAM unchanged. Optimization up to date.
        set need_optimization=0
    ) else (
        echo %YELLOW%[INFO]%NC% RAM changed from %last_ram%GB to %current_ram%GB. Re-optimizing...
    )
)

REM Run optimization if needed
if %need_optimization%==1 (
    echo %BLUE%[INFO]%NC% Running RAM optimization for %current_ram%GB...
    call "%SCRIPT_DIR%optimize-ram.bat"
    
    REM Save optimization info
    echo %current_ram% > "%optimization_file%"
    echo %GREEN%[SUCCESS]%NC% Optimization completed and saved.
) else (
    echo %GREEN%[INFO]%NC% Skipping optimization - already optimized for current RAM.
)

echo.
echo %BLUE%========================================%NC%
echo %GREEN%   Environment Ready for %current_ram%GB RAM%NC%
echo %BLUE%========================================%NC%
echo.

REM Show optimization summary
echo %BLUE%[SUMMARY]%NC% Current optimization settings:
if %current_ram% LEQ 4 (
    echo   - Profile: Low RAM ^(Conservative^)
    echo   - MySQL InnoDB: ~200MB
    echo   - PHP Memory: 256MB
    echo   - OPcache: 64MB
) else if %current_ram% LEQ 8 (
    echo   - Profile: Medium RAM ^(Balanced^)
    echo   - MySQL InnoDB: ~400MB
    echo   - PHP Memory: 512MB
    echo   - OPcache: 128MB
) else if %current_ram% LEQ 16 (
    echo   - Profile: High RAM ^(Performance^)
    echo   - MySQL InnoDB: ~1GB
    echo   - PHP Memory: 1GB
    echo   - OPcache: 256MB
) else (
    echo   - Profile: Very High RAM ^(Maximum Performance^)
    echo   - MySQL InnoDB: ~2GB
    echo   - PHP Memory: 2GB
    echo   - OPcache: 512MB
)

echo.
echo %YELLOW%[TIP]%NC% Monitor memory usage with: docker stats
echo %YELLOW%[TIP]%NC% View optimization status: http://localhost/ram-optimization.php
echo.
