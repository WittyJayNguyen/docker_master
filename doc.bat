@echo off
REM Docker Master Platform - Mở hướng dẫn sử dụng

echo.
echo ========================================
echo   Docker Master - Hướng Dẫn Sử Dụng
echo ========================================
echo.

echo 📚 Mở hướng dẫn sử dụng hoàn chỉnh...

REM Thử mở bằng VS Code trước
code HUONG-DAN-SU-DUNG.md 2>nul
if not errorlevel 1 (
    echo ✅ Đã mở bằng VS Code
    goto :end
)

REM Nếu không có VS Code, thử Notepad++
start notepad++ HUONG-DAN-SU-DUNG.md 2>nul
if not errorlevel 1 (
    echo ✅ Đã mở bằng Notepad++
    goto :end
)

REM Cuối cùng dùng Notepad
start notepad HUONG-DAN-SU-DUNG.md
echo ✅ Đã mở bằng Notepad

:end
echo.
echo 💡 File hướng dẫn: HUONG-DAN-SU-DUNG.md
echo 🎯 Lệnh chính cần nhớ: create.bat [tên-project]
echo.
pause
