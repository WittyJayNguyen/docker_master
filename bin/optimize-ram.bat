@echo off
setlocal enabledelayedexpansion

REM Auto RAM Optimization Script for Docker Development Environment (Windows)
REM Automatically detects system RAM and optimizes configurations

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Colors (limited support in Windows)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Helper functions
:log_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:log_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:log_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Detect system RAM
:detect_ram
REM Try PowerShell method first (more reliable)
for /f %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB"') do (
    set /a RAM_GB=%%i
)

REM Fallback to wmic if PowerShell fails
if not defined RAM_GB (
    for /f "tokens=2 delims==" %%i in ('wmic computersystem get TotalPhysicalMemory /value 2^>nul ^| find "="') do (
        set /a RAM_GB=%%i/1024/1024/1024
    )
)

REM Default to 8GB if detection fails
if not defined RAM_GB set RAM_GB=8

call :log_info "Detected RAM: %RAM_GB%GB"
goto :eof

REM Generate optimized MySQL configuration
:generate_mysql_config
set ram_gb=%1
set config_file=%PROJECT_ROOT%\database\mysql\conf\my.cnf

call :log_info "Generating MySQL config for %ram_gb%GB RAM..."

REM Calculate MySQL memory allocation based on RAM size
if %ram_gb% LEQ 4 (
    REM Low RAM: 20% allocation
    set /a mysql_memory=%ram_gb%*200
    set /a innodb_buffer=%mysql_memory%*60/100
    set /a query_cache=32
    set /a max_connections=100
) else if %ram_gb% LEQ 8 (
    REM Medium RAM: 25% allocation
    set /a mysql_memory=%ram_gb%*250
    set /a innodb_buffer=%mysql_memory%*70/100
    set /a query_cache=64
    set /a max_connections=200
) else if %ram_gb% LEQ 16 (
    REM High RAM: 30% allocation
    set /a mysql_memory=%ram_gb%*300
    set /a innodb_buffer=%mysql_memory%*75/100
    set /a query_cache=128
    set /a max_connections=300
) else (
    REM Very High RAM: 25% allocation (cap for development)
    set /a mysql_memory=%ram_gb%*250
    set /a innodb_buffer=%mysql_memory%*80/100
    set /a query_cache=256
    set /a max_connections=500
)

REM Minimum and maximum values
if %innodb_buffer% LSS 128 set innodb_buffer=128
if %innodb_buffer% GTR 4096 set innodb_buffer=4096
if %query_cache% LSS 16 set query_cache=16
if %query_cache% GTR 512 set query_cache=512

(
echo [mysqld]
echo # Auto-generated MySQL configuration for %ram_gb%GB RAM
echo # Generated on %date% %time%
echo.
echo # Disable SSL for development
echo ssl = 0
echo require_secure_transport = OFF
echo.
echo # Memory settings ^(optimized for %ram_gb%GB RAM^)
echo innodb_buffer_pool_size = %innodb_buffer%M
echo innodb_log_file_size = %innodb_buffer:~0,-1%M
echo query_cache_size = %query_cache%M
echo query_cache_limit = 2M
echo.
echo # Connection settings
echo max_connections = %max_connections%
echo max_allowed_packet = 64M
echo thread_cache_size = %ram_gb%
echo table_open_cache = %ram_gb%00
echo.
echo # Character set
echo character-set-server = utf8mb4
echo collation-server = utf8mb4_unicode_ci
echo.
echo # Performance settings
echo innodb_flush_log_at_trx_commit = 2
echo innodb_flush_method = O_DIRECT
echo query_cache_type = 1
echo.
echo # Logging ^(minimal for development^)
echo general_log = 0
echo slow_query_log = 1
echo slow_query_log_file = /var/log/mysql/slow.log
echo long_query_time = 2
echo.
echo [mysql]
echo default-character-set = utf8mb4
echo.
echo [client]
echo default-character-set = utf8mb4
) > "%config_file%"

call :log_success "MySQL config generated: %innodb_buffer%MB InnoDB buffer, %query_cache%MB query cache"
goto :eof

REM Generate optimized PHP configuration
:generate_php_config
set ram_gb=%1
set php_version=%2
set config_file=%PROJECT_ROOT%\php\%php_version%\php.ini

call :log_info "Generating PHP %php_version% config for %ram_gb%GB RAM..."

REM Calculate PHP memory based on RAM size
if %ram_gb% LEQ 4 (
    REM Low RAM: Conservative settings
    set php_memory=256
    set opcache_memory=64
    set max_files=2000
    set jit_buffer=32
) else if %ram_gb% LEQ 8 (
    REM Medium RAM: Balanced settings
    set php_memory=512
    set opcache_memory=128
    set max_files=4000
    set jit_buffer=64
) else if %ram_gb% LEQ 16 (
    REM High RAM: Performance settings
    set php_memory=1024
    set opcache_memory=256
    set max_files=8000
    set jit_buffer=128
) else (
    REM Very High RAM: Maximum performance
    set php_memory=2048
    set opcache_memory=512
    set max_files=16000
    set jit_buffer=256
)

REM Calculate upload sizes based on PHP memory
set /a upload_size=%php_memory%/4
if %upload_size% LSS 32 set upload_size=32
if %upload_size% GTR 512 set upload_size=512

(
echo [PHP]
echo ; Auto-generated PHP configuration for %ram_gb%GB RAM
echo ; Generated on %date% %time%
echo.
echo ; Memory settings ^(optimized for %ram_gb%GB RAM^)
echo memory_limit = %php_memory%M
echo max_execution_time = 300
echo max_input_time = 300
echo post_max_size = %upload_size%M
echo upload_max_filesize = %upload_size%M
echo max_file_uploads = 50
echo.
echo ; Error reporting
echo display_errors = On
echo display_startup_errors = On
echo log_errors = On
echo error_log = /var/log/php/error.log
echo error_reporting = E_ALL
echo.
echo ; Session settings
echo session.save_handler = files
echo session.save_path = "/tmp"
echo session.gc_maxlifetime = 1440
echo session.cookie_lifetime = 0
echo.
echo ; OPcache settings ^(optimized for %ram_gb%GB RAM^)
echo opcache.enable = 1
echo opcache.enable_cli = 1
echo opcache.memory_consumption = %opcache_memory%
echo opcache.interned_strings_buffer = %opcache_memory:~0,-1%
echo opcache.max_accelerated_files = %max_files%
echo opcache.revalidate_freq = 2
echo opcache.fast_shutdown = 1
echo opcache.validate_timestamps = 1
echo opcache.save_comments = 0
) > "%config_file%"

REM Add JIT for PHP 8.2+
if "%php_version%"=="8.2" (
    echo opcache.jit_buffer_size = %jit_buffer%M >> "%config_file%"
    echo opcache.jit = tracing >> "%config_file%"
)
if "%php_version%"=="8.4" (
    echo opcache.jit_buffer_size = %jit_buffer%M >> "%config_file%"
    echo opcache.jit = tracing >> "%config_file%"
)

(
echo.
echo ; Date settings
echo date.timezone = Asia/Ho_Chi_Minh
echo.
echo ; Security
echo expose_php = Off
echo allow_url_fopen = On
echo allow_url_include = Off
echo.
echo ; File uploads
echo file_uploads = On
echo upload_tmp_dir = /tmp
echo.
echo ; Realpath cache
echo realpath_cache_size = 4096K
echo realpath_cache_ttl = 600
) >> "%config_file%"

call :log_success "PHP %php_version% config generated: %php_memory%MB memory, %opcache_memory%MB OPcache"
goto :eof

REM Main function
:main
call :log_info "🚀 Starting RAM optimization for Docker Development Environment"

REM Detect system RAM
call :detect_ram
call :log_info "Detected system RAM: %RAM_GB%GB"

if %RAM_GB% LSS 4 (
    call :log_warning "Low RAM detected (%RAM_GB%GB). Consider upgrading to at least 8GB for optimal performance."
) else if %RAM_GB% GEQ 16 (
    call :log_success "High RAM detected (%RAM_GB%GB). Excellent for development!"
) else (
    call :log_info "Moderate RAM detected (%RAM_GB%GB). Good for development."
)

REM Generate optimized configurations
call :generate_mysql_config %RAM_GB%
call :generate_php_config %RAM_GB% "7.4"
call :generate_php_config %RAM_GB% "8.2"
call :generate_php_config %RAM_GB% "8.4"

call :log_success "🎉 RAM optimization completed!"
call :log_info "Next steps:"
echo 1. Restart services: docker-compose restart
echo 2. Check memory usage: docker stats
echo 3. Monitor performance with optimized settings

goto :eof

REM Run main function
call :main
