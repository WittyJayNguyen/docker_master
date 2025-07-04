# 🚀 Auto-Discovery Platform System

## ✨ Tính Năng Mới: Tự Động Phát Hiện Platform

**Không cần thêm platform vào array trong `platform-manager.sh` nữa!**

### 🎯 Cách Hoạt Động

Platform-manager.sh sẽ **tự động quét** thư mục `platforms/` và phát hiện tất cả platforms có sẵn.

```bash
# Trước đây (cũ)
PLATFORMS=("shared" "laravel-ecommerce" "wordpress" "vue")  # ← Phải thêm thủ công

# Bây giờ (mới)
PLATFORMS=($(get_platforms))  # ← Tự động phát hiện!
```

### 🆕 Tạo Platform Mới - Siêu Đơn Giản

#### Cách 1: Sử dụng Script (Khuyến nghị)
```bash
# Chỉ 1 lệnh - Mọi thứ tự động!
./create-platform.sh laravel my-new-shop 8015

# ✅ Tự động tạo thư mục platforms/my-new-shop/
# ✅ Tự động tạo docker-compose file từ template  
# ✅ Tự động thêm vào main docker-compose.yml
# ✅ Tự động được phát hiện bởi platform-manager.sh
# ✅ Sẵn sàng chạy: ./platform-manager.sh start my-new-shop
```

#### Cách 2: Thủ Công
```bash
# Bước 1: Tạo thư mục
mkdir platforms/my-manual-project

# Bước 2: Tạo docker-compose file
cp platforms/templates/laravel.template.yml \
   platforms/my-manual-project/docker-compose.my-manual-project.yml

# Bước 3: Chỉnh sửa cấu hình (thay {{PROJECT_NAME}}, {{PORT}})

# Bước 4: Xong! Platform tự động được phát hiện
./platform-manager.sh list  # ← Sẽ thấy platform mới
```

### 📋 Xem Danh Sách Platform

```bash
./platform-manager.sh list
```

**Output:**
```
📋 Available Platforms (auto-discovered):
  ✓ shared (docker-compose.shared.yml)
  ✓ laravel-ecommerce (docker-compose.laravel-ecommerce.yml)
  ✓ my-new-shop (docker-compose.my-new-shop.yml)
  ✓ wordpress (docker-compose.wordpress.yml)
  ✓ vue (docker-compose.vue.yml)

💡 To add new platform:
   1. Create folder: mkdir platforms/my-new-project
   2. Add docker-compose file: platforms/my-new-project/docker-compose.my-new-project.yml
   3. Platform will be auto-discovered!
```

### 🔍 Quy Tắc Auto-Discovery

Platform sẽ được phát hiện nếu:
- ✅ Có thư mục trong `platforms/`
- ✅ Thư mục chứa file `docker-compose.*.yml`
- ✅ Không phải thư mục `templates` hoặc `base`

### 🛠️ Scripts Hỗ Trợ

| Script | Mô tả |
|--------|-------|
| `platform-manager.sh` | Quản lý platforms (auto-discovery) |
| `create-platform.sh` | Tạo platform mới từ template |
| `sync-platforms.sh` | Rebuild main docker-compose.yml |
| `demo-auto-discovery.sh` | Demo tính năng auto-discovery |

### 🎬 Demo

```bash
# Chạy demo để xem auto-discovery hoạt động
./demo-auto-discovery.sh
```

### 💡 Lợi Ích

- ✅ **Không cần config thủ công** - Chỉ tạo thư mục + file
- ✅ **Tự động phát hiện** - Platform xuất hiện ngay trong danh sách
- ✅ **Dễ mở rộng** - Thêm bao nhiêu platform cũng được
- ✅ **Không lỗi** - Không cần nhớ thêm vào array
- ✅ **Linh hoạt** - Hỗ trợ cả script và thủ công

### 🔄 Migration từ Hệ Thống Cũ

Nếu bạn đang dùng hệ thống cũ:

1. **Platforms hiện tại vẫn hoạt động bình thường**
2. **Platforms mới sẽ tự động được phát hiện**
3. **Không cần thay đổi gì cả!**

### 🚀 Bắt Đầu Ngay

```bash
# Tạo platform Laravel mới
./create-platform.sh laravel my-awesome-project 8020

# Xem danh sách (sẽ thấy platform mới)
./platform-manager.sh list

# Khởi chạy
./platform-manager.sh start my-awesome-project
```

---

**🎉 Enjoy the magic of Auto-Discovery!**
