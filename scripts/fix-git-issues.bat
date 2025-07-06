@echo off
REM Docker Master Platform - Fix Git Issues
REM Sửa các vấn đề Git với line endings và socket files

echo.
echo ========================================
echo   Docker Master - Fix Git Issues
echo ========================================
echo.

echo 🔧 Fixing Git issues...
echo ================================================================

echo 📝 Step 1: Configure Git line endings for Windows...
git config core.autocrlf true
git config core.safecrlf false
echo ✅ Git line ending configuration updated

echo.
echo 📝 Step 2: Update .gitignore to exclude problematic files...

REM Backup existing .gitignore
if exist ".gitignore" (
    copy ".gitignore" ".gitignore.backup" >nul 2>&1
    echo ✅ Backed up existing .gitignore
)

REM Create comprehensive .gitignore
(
echo # Docker Master Platform - Git Ignore Rules
echo.
echo # Docker data directories
echo data/
echo !data/.gitkeep
echo.
echo # MySQL specific files
echo data/mysql/
echo *.sock
echo *.pid
echo *.log
echo auto.cnf
echo binlog.*
echo ib_*
echo mysql.sock*
echo.
echo # PostgreSQL specific files
echo data/postgres/
echo postmaster.pid
echo postgresql.conf.backup
echo.
echo # Redis specific files
echo data/redis/
echo dump.rdb
echo appendonly.aof
echo.
echo # Log directories
echo logs/
echo !logs/.gitkeep
echo config/logs/
echo *.log
echo.
echo # Temporary files
echo *.tmp
echo *.bak
echo *.backup
echo *~
echo .DS_Store
echo Thumbs.db
echo.
echo # Docker specific
echo .docker/
echo docker-compose.override.yml
echo.
echo # IDE files
echo .vscode/
echo .idea/
echo *.swp
echo *.swo
echo.
echo # OS specific
echo .DS_Store
echo Thumbs.db
echo desktop.ini
echo.
echo # Project specific
echo projects/*/vendor/
echo projects/*/node_modules/
echo projects/*/storage/logs/
echo projects/*/storage/framework/cache/
echo projects/*/storage/framework/sessions/
echo projects/*/storage/framework/views/
echo projects/*/.env
echo.
echo # Backup files
echo *.backup
echo *.bak
echo *~
) > .gitignore

echo ✅ Created comprehensive .gitignore

echo.
echo 📝 Step 3: Remove problematic files from Git tracking...

REM Remove data directory from tracking
git rm -r --cached data/ 2>nul
echo ✅ Removed data/ from Git tracking

REM Remove logs from tracking
git rm -r --cached logs/ 2>nul
git rm -r --cached config/logs/ 2>nul
echo ✅ Removed log directories from Git tracking

REM Remove any socket files
git rm --cached data/mysql/mysql.sock 2>nul
git rm --cached data/mysql/*.sock 2>nul
echo ✅ Removed socket files from Git tracking

echo.
echo 📝 Step 4: Create .gitkeep files for empty directories...
mkdir data 2>nul
echo. > data\.gitkeep
mkdir logs 2>nul
echo. > logs\.gitkeep
mkdir config\logs 2>nul
echo. > config\logs\.gitkeep
echo ✅ Created .gitkeep files

echo.
echo 📝 Step 5: Clean Git cache and re-add files...
git rm -r --cached . 2>nul
echo ✅ Cleared Git cache

echo 📝 Adding files with new .gitignore rules...
git add .gitignore
git add scripts/
git add docker/
git add platforms/
git add projects/
git add docker-compose*.yml
git add *.md
git add data/.gitkeep
git add logs/.gitkeep
git add config/logs/.gitkeep

echo ✅ Added files with exclusions

echo.
echo 📝 Step 6: Check Git status...
git status --porcelain

echo.
echo 🎉 Git Issues Fixed!
echo ================================================================

echo ✅ What was fixed:
echo    • Configured Git line endings for Windows
echo    • Created comprehensive .gitignore
echo    • Removed data/ and logs/ from tracking
echo    • Excluded socket files and temporary files
echo    • Added .gitkeep files for empty directories
echo    • Re-added files with proper exclusions

echo.
echo 💡 Next steps:
echo    • Review git status
echo    • Commit changes: git commit -m "Fix Git configuration and add .gitignore"
echo    • Push changes: git push

echo.
echo 📋 Safe files to commit:
echo    • All scripts in scripts/
echo    • Docker configurations
echo    • Project source code
echo    • Documentation files
echo    • .gitignore and .gitkeep files

echo.
echo ⚠️  Excluded from Git:
echo    • data/ directory (Docker volumes)
echo    • logs/ directory (log files)
echo    • Socket files (*.sock)
echo    • Temporary files (*.tmp, *.bak)
echo    • IDE and OS specific files

pause
