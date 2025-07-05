@echo off
REM Docker Master Platform - Show Documentation
REM Hiển thị tài liệu hướng dẫn

echo.
echo ========================================
echo   Docker Master - Documentation
echo ========================================
echo.

echo 📚 DOCKER MASTER PLATFORM DOCUMENTATION
echo ================================================================

echo 🎯 Hướng dẫn theo cấp độ:
echo.

echo 👶 NGƯỜI MỚI BẮT ĐẦU:
echo   1. docs\01-QUICK-START.md        - Bắt đầu nhanh 5 phút
echo   2. docs\02-STEP-BY-STEP.md       - Hướng dẫn từng bước

echo.
echo 🧑‍💻 NGƯỜI CÓ KINH NGHIỆM:
echo   3. docs\03-DEVELOPMENT.md        - Hướng dẫn phát triển
echo   4. docs\04-DEBUG-SETUP.md        - Cấu hình Debug

echo.
echo 🔧 QUẢN TRỊ VIÊN:
echo   5. docs\05-SYSTEM-MANAGEMENT.md  - Quản lý hệ thống
echo   6. docs\06-TROUBLESHOOTING.md    - Khắc phục sự cố

echo.
echo 🤖 AUTO-DISCOVERY (MỚI):
echo   7. docs\07-AUTO-DISCOVERY.md     - Tạo platform tự động
echo   8. AUTO-DISCOVERY-QUICK-REFERENCE.md - Tham khảo nhanh

echo.
echo 🚀 QUICK START - AUTO-DISCOVERY:
echo ================================================================

echo 📝 Lệnh chính (CHỈ CẦN 1 LỆNH):
echo   create.bat [tên-dự-án]

echo.
echo 🎯 Ví dụ nhanh:
echo   create.bat my-shop           # → E-commerce platform
echo   create.bat food-delivery     # → Food delivery platform  
echo   create.bat my-blog           # → WordPress blog
echo   create.bat api-service       # → Laravel API
echo   create.bat coffee-shop       # → Cửa hàng cà phê
echo   create.bat news-portal       # → Website tin tức

echo.
echo 🤖 AI Auto-Detection:
echo ================================================================

echo 🛒 E-commerce Keywords:
echo   shop, store, ecommerce, commerce, delivery, food, cafe, restaurant
echo   → Laravel 8.4 + PostgreSQL + Redis

echo.
echo 📝 WordPress Keywords:
echo   blog, news, cms, content, portfolio, personal, website
echo   → WordPress PHP 7.4 + PostgreSQL

echo.
echo 🚀 Laravel API Keywords:
echo   api, service, micro, backend
echo   → Laravel 8.4 + PostgreSQL + Redis

echo.
echo 📁 Cấu trúc tự động tạo:
echo ================================================================

echo platforms/[tên-dự-án]/
echo ├── docker-compose.[tên-dự-án].yml  # Cấu hình standalone
echo ├── README.md                       # Tài liệu platform
echo projects/[tên-dự-án]/
echo ├── index.php                       # File ứng dụng
echo logs/apache/[tên-dự-án]/           # Log files
echo data/uploads/[tên-dự-án]/          # Upload storage

echo.
echo 🌐 URLs mặc định:
echo ================================================================

echo Core Services:
echo   • Monitor Dashboard: http://localhost:8090
echo   • Mailhog:          http://localhost:8025

echo.
echo Existing Platforms:
echo   • Laravel PHP 8.4:  http://localhost:8010
echo   • Laravel PHP 7.4:  http://localhost:8020
echo   • WordPress PHP 7.4: http://localhost:8030

echo.
echo Auto-Created Platforms:
echo   • Platform đầu tiên: http://localhost:8015
echo   • Platform thứ hai:  http://localhost:8016
echo   • Platform thứ ba:   http://localhost:8017
echo   • (Port tự động gán)

echo.
echo 🛠️ Lệnh quản lý nhanh:
echo ================================================================

echo Platform Creation:
echo   create.bat [tên-dự-án]                    # Siêu đơn giản
echo   auto-platform.bat [tên-dự-án]            # Đầy đủ tính năng
echo   scripts\create-platform.bat [type] [name] [port]  # Nâng cao

echo.
echo Platform Management:
echo   docker ps                                 # Xem platforms
echo   cd platforms/[name] ^&^& docker-compose down    # Dừng platform
echo   docker logs [container-name]             # Xem logs
echo   docker exec -it [container] bash         # Shell access

echo.
echo System Optimization:
echo   scripts\one-click-optimize.bat           # Tối ưu nhanh
echo   scripts\ultimate-optimize.bat            # Tối ưu toàn diện
echo   scripts\fix-platform-databases.bat      # Sửa database

echo.
echo 📖 Cách đọc tài liệu:
echo ================================================================

echo 1. Mở file .md bằng:
echo    • VS Code (khuyến nghị)
echo    • Notepad++
echo    • GitHub Desktop
echo    • Browser (drag and drop file)

echo.
echo 2. Hoặc xem online tại:
echo    • GitHub repository
echo    • GitLab pages
echo    • Local markdown viewer

echo.
echo 💡 Gợi ý:
echo ================================================================

echo 📚 Bắt đầu với:
echo   1. AUTO-DISCOVERY-QUICK-REFERENCE.md  # Tham khảo nhanh
echo   2. docs\07-AUTO-DISCOVERY.md          # Hướng dẫn đầy đủ
echo   3. docs\01-QUICK-START.md             # Setup ban đầu

echo.
echo 🎯 Cho người mới:
echo   • Đọc AUTO-DISCOVERY-QUICK-REFERENCE.md
echo   • Chạy: create.bat my-first-project
echo   • Xem kết quả tại: http://localhost:8015

echo.
echo 🔧 Cho developer:
echo   • Đọc docs\03-DEVELOPMENT.md
echo   • Đọc docs\04-DEBUG-SETUP.md
echo   • Tùy chỉnh platforms theo nhu cầu

echo.
echo 🌟 DOCKER MASTER PLATFORM - DOCUMENTATION READY!
echo    Tất cả tài liệu đã sẵn sàng để sử dụng.

echo.
set /p choice="Mở tài liệu Auto-Discovery? (y/n): "
if /i "%choice%"=="y" (
    start notepad docs\07-AUTO-DISCOVERY.md
    start notepad AUTO-DISCOVERY-QUICK-REFERENCE.md
)

pause
