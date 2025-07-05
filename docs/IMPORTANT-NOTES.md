# ⚠️ IMPORTANT NOTES - Docker Master Platform

## 🚨 Lỗi phổ biến nhất: Database Connection

### 🔍 Triệu chứng:
- **phpMyAdmin** báo: "Không thể kết nối: cài đặt sai"
- **MySQL error**: "mysqli::real_connect(): php_network_getaddresses: getaddrinfo for mysql failed"
- **Containers restart** liên tục khi chạy `bin\status.bat`

### ✅ Giải pháp (1 lệnh):
```bash
scripts\fix-database-corruption.bat
```

**Script này sẽ:**
- ✅ Tự động stop tất cả services
- ✅ Xóa database directories bị corrupted
- ✅ Tạo lại fresh databases
- ✅ Restart tất cả services
- ⚠️ **Lưu ý**: Sẽ xóa tất cả database data

---

## 🎯 Khi nào cần chạy script này?

### ✅ Chạy khi gặp:
- phpMyAdmin không connect được
- MySQL/PostgreSQL containers restart liên tục
- Services "Not responding" trong status check
- Sau khi Git operations xóa database files
- Sau khi improper shutdown

### ❌ Không cần chạy khi:
- Services start bình thường
- Chỉ muốn restart services (dùng `bin\restart.bat`)
- Chỉ muốn check status (dùng `bin\status.bat`)

---

## 📋 Quick Reference

### 🚀 Daily Commands:
```bash
bin\start.bat          # Start everything
bin\stop.bat           # Stop everything  
bin\status.bat         # Check status
```

### 🆘 Emergency Commands:
```bash
scripts\fix-database-corruption.bat    # Fix database issues
bin\restart.bat                        # Restart all services
scripts\cleanup.bat                    # Clean up junk files
```

### 🌐 Service URLs:
- **phpMyAdmin**: http://localhost:8080 (root/rootpassword123)
- **pgAdmin**: http://localhost:8081 (admin@example.com/admin123)
- **Laravel PHP 8.4**: http://localhost:8010
- **WordPress**: http://localhost:8012 (admin/admin)
- **RAM Dashboard**: http://localhost:8090

---

## 💡 Pro Tips

1. **Luôn đợi 2-3 phút** sau `bin\start.bat` để services khởi động hoàn toàn
2. **Sử dụng `bin\status.bat`** để kiểm tra trạng thái thực tế
3. **Nếu có nghi ngờ**, chạy `scripts\fix-database-corruption.bat`
4. **Stop services** bằng `bin\stop.bat` trước khi tắt máy
5. **Không xóa** thư mục `data/` khi containers đang chạy

---

## 📞 Cần thêm help?

- **Quick help**: `QUICK-HELP.md`
- **Detailed troubleshooting**: `TROUBLESHOOTING.md`
- **Full documentation**: `README.md`

---

## 🎯 Remember

**90% các vấn đề được giải quyết bằng:**
```bash
scripts\fix-database-corruption.bat
```

**Nếu vẫn không được, thử:**
```bash
bin\stop.bat
# Wait 30 seconds
bin\start.bat
```

**🚀 Chúc bạn sử dụng Docker Master Platform hiệu quả!** 🎉
