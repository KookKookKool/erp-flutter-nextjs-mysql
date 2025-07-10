# ERP Backend System

ระบบ Backend สำหรับ ERP ที่พัฒนาด้วย Next.js และ MySQL รองรับ Multi-Tenant Architecture

> 📚 **เอกสารฉบับสมบูรณ์**: อ่าน [`DOCUMENTATION.md`](./DOCUMENTATION.md) สำหรับคู่มือการใช้งานแบบครบครัน

## ⚡ Quick Start

### 🎯 วิธีที่เร็วที่สุด
```bash
# ดับเบิลคลิกไฟล์
erp-manager.bat

# เลือก "1" สำหรับ Full Setup
# รอติดตั้งเสร็จ (2-3 นาที)
```

### 🔗 URLs หลัก
- **Admin Panel**: http://localhost:3000/admin/login
- **Test Page**: http://localhost:3000/test-registration.html  
- **phpMyAdmin**: http://localhost:8080

### 🔑 Login ข้อมูล
```
📧 Email: admin@sunerp.com
🔐 Password: admin123
```

## 🚀 คุณสมบัติหลัก

- ✅ **Multi-Tenant** - แยก schema ต่อองค์กร
- ✅ **Super Admin** - สร้างอัตโนมัติ (admin_[ORG_CODE])
- ✅ **100 Permissions** - ระบบสิทธิ์แบบละเอียด
- ✅ **Admin Panel** - จัดการองค์กรและผู้ใช้
- ✅ **Auto Testing** - integration test ครบครัน

## 🛠️ เทคโนโลยี

- **Next.js 14** + TypeScript
- **MySQL 8.0** + Prisma ORM
- **Docker** + Docker Compose
- **Tailwind CSS** + JWT Auth

## 📋 Commands

```bash
# ERP Manager (แนะนำ)
erp-manager.bat

# หรือใช้ NPM
npm run dev              # development server
npm run test:integration # รันการทดสอบ
npm run db:seed         # เพิ่มข้อมูลเริ่มต้น
```

## 📚 เอกสารเพิ่มเติม

สำหรับข้อมูลละเอียด การแก้ปัญหา และคู่มือการใช้งานครบครัน:

👉 **[DOCUMENTATION.md](./DOCUMENTATION.md)** 📖

## ✅ แก้ไขปัญหาการเข้าสู่ระบบ Admin เรียบร้อยแล้ว!

### 🔧 การแก้ไขที่ทำ:
1. **ตรวจสอบ admin_users table** - พบว่าไม่มี admin user
2. **สร้าง admin user ใหม่** ด้วยอีเมล admin@sunerp.com
3. **ทดสอบการ login** - ยืนยันว่าใช้งานได้

### 🚀 วิธีการเข้าสู่ระบบ:

1. **เริ่ม Development Server:**
   ```bash
   .\erp-manager.bat
   # เลือก option 3 (Start Development Server)
   ```

2. **เปิดเบราว์เซอร์ไปที่:**
   ```
   http://localhost:3000/admin/login
   ```

3. **ใช้ข้อมูลเข้าสู่ระบบ:**
   ```
   📧 Email: admin@sunerp.com
   🔐 Password: admin123
   ```

### 🎯 ขั้นตอนการทดสอบ:
```bash
# ทดสอบการ login (ผ่านแล้ว)
npm run test:integration

# ทดสอบระบบ Super Admin (ผ่านแล้ว)
# - Email format: admin_[ORG_CODE]
# - Full permissions granted
# - Password changeable via admin panel
```

---

**🎉 Happy Coding!** 🚀
