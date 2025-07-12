# 🤖 Auto-Discovery Quick Reference

## 🚀 Lệnh chính

```bash
# Tạo platform tự động - CHỈ CẦN 1 LỆNH!
create.bat [tên-dự-án]
```

## 🎯 Ví dụ nhanh

```bash
create.bat my-shop           # → E-commerce
create.bat food-delivery     # → Food delivery  
create.bat my-blog           # → WordPress
create.bat api-service       # → Laravel API
create.bat coffee-shop       # → Cửa hàng cà phê
create.bat news-portal       # → Website tin tức
```

## 🤖 AI Auto-Detection

| Từ khóa | Platform | Ví dụ |
|---------|----------|-------|
| shop, store, ecommerce, delivery, food, cafe | **E-commerce** (Laravel 8.4) | my-shop, food-delivery |
| blog, news, cms, content, portfolio, website | **WordPress** (PHP 7.4) | my-blog, news-portal |
| api, service, micro, backend | **Laravel API** (8.4) | api-service, user-api |

## 📁 Cấu trúc tạo tự động

```
platforms/[tên-dự-án]/
├── docker-compose.[tên-dự-án].yml
├── README.md
projects/[tên-dự-án]/
├── index.php
logs/apache/[tên-dự-án]/
data/uploads/[tên-dự-án]/
```

## 🗄️ Database tự động

- `my-shop` → `my_shop_db`
- `food-delivery` → `food_delivery_db`
- `coffee-shop` → `coffee_shop_db`

## 🚀 Khởi động platform

```bash
# Tự động (sau khi tạo)
# Platform sẽ tự động start và mở browser

# Thủ công
cd platforms/[tên-dự-án]
docker-compose -f docker-compose.[tên-dự-án].yml up -d
```

## 🌐 URLs

- **Platform đầu tiên:** http://localhost:8015
- **Platform thứ hai:** http://localhost:8016
- **Platform thứ ba:** http://localhost:8017
- *(Port tự động gán)*

## 🛠️ Quản lý nhanh

```bash
# Xem platforms đang chạy
docker ps --filter "name=_php"

# Dừng platform
cd platforms/[tên-platform]
docker-compose down

# Xem logs
docker logs [tên-platform]_php[version]

# Truy cập shell
docker exec -it [tên-platform]_php[version] bash
```

## 🔧 Lệnh khác

```bash
# Lệnh đầy đủ
auto-platform.bat [tên-dự-án]

# Lệnh nâng cao
scripts\create-platform.bat [type] [name] [port]

# Chế độ tương tác
scripts\auto-discovery.bat
```

## 🎉 Mẹo

1. **Dùng tên mô tả:** `coffee-shop` thay vì `project1`
2. **Bao gồm từ khóa:** `food-delivery` để AI detect đúng
3. **Kiểm tra port:** Hệ thống tự gán port từ 8015
4. **Đọc README:** Mỗi platform có tài liệu riêng

---

**Chỉ cần:** `create.bat [tên-dự-án]` → **Mọi thứ tự động!** 🚀
