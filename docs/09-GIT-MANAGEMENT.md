# 🔧 Git Management - Docker Master Platform

> **Hướng dẫn quản lý Git cho Docker Master Platform**

## 🎯 Tổng quan

Docker Master Platform đã được cấu hình để **tự động loại trừ** các files không nên commit vào Git:

- **Database files** (`data/`) - Chứa dữ liệu nhạy cảm và files lớn
- **Log files** (`logs/`) - Generated tại runtime
- **Backup files** (`backups/`) - Files backup database
- **Temporary files** - Cache, temp files, etc.

## 🚀 Quick Setup

### Lần đầu setup Git:

```bash
# Chạy script tự động
scripts\git-setup.bat
```

Script này sẽ:
- ✅ Configure Git line endings cho Windows
- ✅ Add tất cả project files
- ✅ Commit với message chi tiết
- ❌ **Không** commit database files

## 📁 Files được commit

### ✅ Được commit:
```
bin/                    # Executable scripts
config/                 # Configuration files
platforms/              # Platform definitions
scripts/                # Utility scripts
tools/                  # Development tools
docs/                   # Documentation
projects/               # Application source code (không có vendor/)
docker/                 # Docker configurations
docker-compose.yml      # Main compose file
.gitignore             # Git ignore rules
README.md              # Documentation
```

### ❌ Không được commit:
```
data/mysql/            # MySQL database files
data/postgres/         # PostgreSQL database files
data/redis/            # Redis data files
data/pgadmin/          # pgAdmin settings
logs/                  # Application logs
backups/               # Database backups
*.log                  # Log files
*.tmp                  # Temporary files
.env.local             # Local environment files
vendor/                # Dependencies (Laravel)
node_modules/          # Node dependencies
```

## 🔧 Daily Git Workflow

### Commit changes:
```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "feat: your feature description"

# Push
git push origin main
```

### Kiểm tra files bị ignore:
```bash
# Xem files bị ignore
git status --ignored

# Kiểm tra .gitignore rules
git check-ignore -v data/mysql/some-file
```

## 🛡️ Security Best Practices

### 1. Không commit sensitive data:
```bash
# ❌ NEVER commit these:
data/                  # Database files
.env                   # Environment variables
*.key                  # SSL keys
*.pem                  # Certificates
secrets/               # Secret files
```

### 2. Kiểm tra trước khi commit:
```bash
# Xem files sẽ được commit
git diff --cached

# Xem files trong staging area
git status --porcelain | findstr "^A"
```

### 3. Clean up nếu commit nhầm:
```bash
# Remove file from Git but keep local
git rm --cached path/to/file

# Remove entire folder from Git
git rm -r --cached data/

# Commit the removal
git commit -m "Remove database files from tracking"
```

## 🔄 Branch Management

### Tạo feature branch:
```bash
# Tạo và switch to new branch
git checkout -b feature/new-feature

# Work on your feature
# ... make changes ...

# Commit changes
git add .
git commit -m "feat: implement new feature"

# Push branch
git push origin feature/new-feature
```

### Merge về main:
```bash
# Switch to main
git checkout main

# Pull latest changes
git pull origin main

# Merge feature branch
git merge feature/new-feature

# Push merged changes
git push origin main

# Delete feature branch
git branch -d feature/new-feature
git push origin --delete feature/new-feature
```

## 🧹 Maintenance Commands

### Cleanup Git repository:
```bash
# Remove untracked files
git clean -fd

# Remove ignored files (careful!)
git clean -fX

# Garbage collect
git gc --prune=now

# Check repository size
git count-objects -vH
```

### Fix common issues:
```bash
# Reset to last commit (lose all changes)
git reset --hard HEAD

# Unstage all files
git reset HEAD

# Undo last commit (keep changes)
git reset --soft HEAD~1
```

## 📊 Repository Statistics

### Kiểm tra repository info:
```bash
# Repository size
git count-objects -vH

# Commit history
git log --oneline -10

# Files in last commit
git show --name-only

# Contributors
git shortlog -sn
```

## 🚨 Troubleshooting

### Lỗi "LF will be replaced by CRLF":
```bash
# Configure line endings
git config core.autocrlf true
git config core.safecrlf false

# Or globally
git config --global core.autocrlf true
```

### Lỗi "unable to index file":
```bash
# Usually database files - check .gitignore
git check-ignore -v path/to/file

# If file should be ignored, add to .gitignore
echo "path/to/file" >> .gitignore
git add .gitignore
git commit -m "Add file to gitignore"
```

### Files quá lớn:
```bash
# Check large files
git ls-files | xargs ls -la | sort -k5 -rn | head -10

# Remove large file from history (careful!)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/large/file' \
  --prune-empty --tag-name-filter cat -- --all
```

## 📚 Best Practices Summary

### ✅ DO:
- **Commit often** với meaningful messages
- **Use branches** cho features
- **Review changes** trước khi commit
- **Keep .gitignore updated**
- **Use descriptive commit messages**

### ❌ DON'T:
- **Commit database files** hoặc logs
- **Commit sensitive data** (.env, keys)
- **Commit large binary files**
- **Force push** to main branch
- **Commit without testing**

## 🎯 Commit Message Convention

```bash
# Format: type(scope): description

feat: add new monitoring dashboard
fix: resolve database connection issue
docs: update installation guide
style: format code with prettier
refactor: reorganize project structure
test: add unit tests for API
chore: update dependencies
```

**🎉 Với cấu hình này, Docker Master Platform sẽ có Git repository sạch sẽ và professional!** 🚀
