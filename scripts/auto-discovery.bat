@echo off
REM Docker Master Platform - Enhanced Auto-Discovery
REM Tự động phát hiện và tạo platform với AI-powered suggestions

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Docker Master - Auto-Discovery
echo ========================================
echo.

if "%~1"=="" (
    echo 🤖 AI-Powered Platform Discovery
    echo ================================================================
    echo.
    echo Choose discovery mode:
    echo   1. Interactive Mode - Answer questions to get suggestions
    echo   2. Quick Create - Direct platform creation
    echo   3. Scan Existing - Analyze current projects
    echo   4. Template Gallery - Browse pre-built templates
    echo.
    set /p mode="Enter mode (1-4): "
    
    if "!mode!"=="1" goto :interactive_mode
    if "!mode!"=="2" goto :quick_create
    if "!mode!"=="3" goto :scan_existing
    if "!mode!"=="4" goto :template_gallery
    
    echo ❌ Invalid mode selected
    pause
    exit /b 1
)

REM Direct creation mode
set PLATFORM_TYPE=%1
set PLATFORM_NAME=%2
set PLATFORM_PORT=%3

if "%PLATFORM_PORT%"=="" (
    echo ℹ️  Auto-assigning port...
    call :find_available_port
)

goto :create_platform

:interactive_mode
echo.
echo 🤖 Interactive Platform Discovery
echo ================================================================
echo.

echo What type of application are you building?
echo   1. Blog/Content Website
echo   2. E-commerce Store
echo   3. API/Microservice
echo   4. Corporate Website
echo   5. Food Delivery App
echo   6. Social Platform
echo   7. Custom Application
echo.
set /p app_type="Select application type (1-7): "

echo.
echo What's your preferred technology stack?
echo   1. WordPress (Easy, CMS-based)
echo   2. Laravel 7.4 (Stable, LTS)
echo   3. Laravel 8.4 (Modern, Latest)
echo   4. Full E-commerce Stack
echo.
set /p tech_stack="Select technology (1-4): "

echo.
set /p project_name="Enter project name: "

REM AI-powered suggestions based on inputs
call :suggest_platform !app_type! !tech_stack! !project_name!

goto :create_platform

:quick_create
echo.
echo 🚀 Quick Platform Creation
echo ================================================================
echo.
echo Available platform types:
echo   • wordpress    - WordPress PHP 7.4 + PostgreSQL
echo   • laravel74    - Laravel PHP 7.4 + PostgreSQL + Redis
echo   • laravel84    - Laravel PHP 8.4 + PostgreSQL + Redis
echo   • ecommerce    - E-commerce Laravel + Full Stack
echo.
set /p PLATFORM_TYPE="Platform type: "
set /p PLATFORM_NAME="Platform name: "

call :find_available_port
goto :create_platform

:scan_existing
echo.
echo 🔍 Scanning Existing Projects
echo ================================================================
echo.

echo Current projects:
if exist "projects" (
    for /d %%i in (projects\*) do (
        echo   • %%~ni
    )
) else (
    echo   No projects found
)

echo.
echo Current services in docker-compose:
findstr /C:"container_name:" docker-compose.low-ram.yml 2>nul | findstr /V "postgres\|redis\|mailhog"

echo.
echo Suggested next platform based on analysis:
call :analyze_and_suggest

pause
exit /b 0

:template_gallery
echo.
echo 📚 Template Gallery
echo ================================================================
echo.

echo Available templates:
echo.
echo 🍕 Food & Restaurant:
echo   • restaurant-menu    - Restaurant menu with ordering
echo   • food-delivery      - Food delivery platform
echo   • cafe-website       - Cafe/coffee shop website
echo.
echo 🛒 E-commerce:
echo   • online-store       - Complete online store
echo   • marketplace        - Multi-vendor marketplace
echo   • subscription-box   - Subscription service
echo.
echo 📝 Content & Media:
echo   • news-portal        - News and media website
echo   • portfolio-site     - Personal/company portfolio
echo   • blog-platform      - Multi-author blog
echo.
echo 🏢 Business:
echo   • corporate-site     - Corporate website
echo   • saas-platform      - SaaS application
echo   • booking-system     - Appointment booking
echo.

set /p template="Enter template name: "
call :create_from_template !template!

exit /b 0

:suggest_platform
set app=%1
set tech=%2
set name=%3

echo.
echo 🤖 AI Suggestions based on your inputs:
echo ================================================================

if "%app%"=="1" (
    set PLATFORM_TYPE=wordpress
    echo ✅ Recommended: WordPress platform
    echo   Perfect for blogs and content websites
)
if "%app%"=="2" (
    set PLATFORM_TYPE=ecommerce
    echo ✅ Recommended: E-commerce platform
    echo   Full-featured online store with Laravel
)
if "%app%"=="3" (
    set PLATFORM_TYPE=laravel84
    echo ✅ Recommended: Laravel 8.4 API
    echo   Modern PHP for APIs and microservices
)
if "%app%"=="4" (
    set PLATFORM_TYPE=wordpress
    echo ✅ Recommended: WordPress corporate
    echo   Professional business website
)
if "%app%"=="5" (
    set PLATFORM_TYPE=ecommerce
    echo ✅ Recommended: Food delivery platform
    echo   E-commerce with food-specific features
)
if "%app%"=="6" (
    set PLATFORM_TYPE=laravel84
    echo ✅ Recommended: Laravel social platform
    echo   Modern framework for social features
)
if "%app%"=="7" (
    if "%tech%"=="2" set PLATFORM_TYPE=laravel74
    if "%tech%"=="3" set PLATFORM_TYPE=laravel84
    if "%tech%"=="4" set PLATFORM_TYPE=ecommerce
    echo ✅ Recommended: Custom %PLATFORM_TYPE%
)

set PLATFORM_NAME=%name%
call :find_available_port

echo.
echo 📋 Platform Configuration:
echo   • Type: %PLATFORM_TYPE%
echo   • Name: %PLATFORM_NAME%
echo   • Port: %PLATFORM_PORT%
echo.

set /p confirm="Create this platform? (y/n): "
if /i not "%confirm%"=="y" exit /b 0

goto :create_platform

:find_available_port
set /a port=8015
:port_loop
findstr /C:"%port%:80" docker-compose.low-ram.yml >nul 2>&1
if not errorlevel 1 (
    set /a port+=1
    goto :port_loop
)
set PLATFORM_PORT=%port%
exit /b 0

:analyze_and_suggest
echo.
echo Based on your current setup, consider:
echo   • Adding a monitoring dashboard (Grafana)
echo   • Creating a staging environment
echo   • Setting up a reverse proxy (Nginx)
echo   • Adding a backup solution
exit /b 0

:create_from_template
set template_name=%1

echo.
echo 🏗️  Creating from template: %template_name%
echo ================================================================

REM Map templates to platform types
if "%template_name%"=="restaurant-menu" (
    set PLATFORM_TYPE=wordpress
    set PLATFORM_NAME=restaurant-menu
)
if "%template_name%"=="food-delivery" (
    set PLATFORM_TYPE=ecommerce
    set PLATFORM_NAME=food-delivery
)
if "%template_name%"=="online-store" (
    set PLATFORM_TYPE=ecommerce
    set PLATFORM_NAME=online-store
)
if "%template_name%"=="blog-platform" (
    set PLATFORM_TYPE=wordpress
    set PLATFORM_NAME=blog-platform
)

if "%PLATFORM_TYPE%"=="" (
    echo ❌ Template not found: %template_name%
    pause
    exit /b 1
)

call :find_available_port
goto :create_platform

:create_platform
echo.
echo 🏗️  Creating Platform: %PLATFORM_NAME%
echo ================================================================

echo ℹ️  Calling main creation script...
call create-platform.bat %PLATFORM_TYPE% %PLATFORM_NAME% %PLATFORM_PORT%

if errorlevel 1 (
    echo ❌ Platform creation failed
    pause
    exit /b 1
)

echo.
echo 🎉 Auto-Discovery Completed Successfully!
echo ================================================================
echo.
echo ✅ Platform created and ready:
echo   • Name: %PLATFORM_NAME%
echo   • Type: %PLATFORM_TYPE%
echo   • URL: http://localhost:%PLATFORM_PORT%
echo.
echo 💡 Next steps:
echo   • Add service to docker-compose.low-ram.yml
echo   • Start the service
echo   • Begin development!
echo.

pause
