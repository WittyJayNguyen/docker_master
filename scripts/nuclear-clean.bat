@echo off
REM Docker Master Platform - Nuclear Clean
REM Xóa tất cả và rebuild hoàn toàn

echo.
echo ========================================
echo   Docker Master - NUCLEAR CLEAN
echo ========================================
echo.

echo ⚠️  This will DESTROY EVERYTHING and rebuild!
echo.
pause

echo 🧹 Step 1: Stop all containers...
docker-compose down 2>nul
docker-compose -f docker-compose.low-ram.yml down 2>nul

echo 🧹 Step 2: Remove all containers...
docker container prune -f

echo 🧹 Step 3: Remove all images...
docker image prune -a -f

echo 🧹 Step 4: Remove all volumes...
docker volume prune -f

echo 🧹 Step 5: Remove all networks...
docker network prune -f

echo 🧹 Step 6: System prune...
docker system prune -a -f --volumes

echo 🧹 Step 7: Clean build cache...
docker builder prune -a -f

echo.
echo ✅ Nuclear cleanup completed!
echo.

echo 📊 Current status:
docker system df

echo.
echo 🚀 Starting fresh rebuild...
echo.

echo 🏗️  Building images (this may take 5-10 minutes)...
docker-compose -f docker-compose.low-ram.yml build --no-cache

echo 🚀 Starting services...
docker-compose -f docker-compose.low-ram.yml up -d

echo ⏳ Waiting 30 seconds for startup...
timeout /t 30 /nobreak

echo.
echo 🗄️ Creating databases...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE laravel_php84_psql;" 2>nul
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "CREATE DATABASE wordpress_php74;" 2>nul

echo.
echo 🎉 REBUILD COMPLETED!
echo.

echo 📊 Final status:
docker ps

echo.
echo 🌐 Test URLs:
echo    • Laravel PHP 8.4: http://localhost:8010
echo    • WordPress PHP 7.4: http://localhost:8030
echo    • Mailhog: http://localhost:8025

pause
