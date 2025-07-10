# 📚 ERP Backend - Complete Documentation

> **เอกสารฉบับรวม** สำหรับระบบ ERP Backend ที่ครอบคลุมทุกด้าน
> 
> **อัปเดตล่าสุด**: 10 กรกฎาคม 2025

---

## 📖 สารบัญ

- [🚀 ภาพรวมระบบ](#-ภาพรวมระบบ)
- [⚡ Quick Start](#-quick-start)
- [🏗️ สถาปัตยกรรม](#-สถาปัตยกรรม)
- [👥 การจัดการผู้ใช้](#-การจัดการผู้ใช้)
- [🔐 ระบบสิทธิ์](#-ระบบสิทธิ์)
- [🧪 การทดสอบ](#-การทดสอบ)
- [🗄️ โครงสร้างฐานข้อมูล](#-โครงสร้างฐานข้อมูล)
- [🔧 การใช้งาน](#-การใช้งาน)
- [❓ แก้ปัญหา](#-แก้ปัญหา)

---

## 🚀 ภาพรวมระบบ

### คุณสมบัติหลัก
- **Multi-Tenant Architecture** - แยก database schema สำหรับแต่ละองค์กร
- **Admin Panel** - จัดการองค์กรและผู้ใช้แบบ centralized
- **Super Admin System** - สร้าง Super Admin อัตโนมัติเมื่ออนุมัติองค์กร
- **Permission Management** - ระบบสิทธิ์แบบละเอียด (100+ permissions)
- **Subscription Management** - จัดการแพลนและวันหมดอายุ
- **RESTful API** - เชื่อมต่อกับ Flutter frontend
- **Audit Logging** - บันทึกการกระทำทั้งหมด

### เทคโนโลยี
- **Backend**: Next.js 14 + TypeScript
- **Database**: MySQL 8.0 + Prisma ORM
- **Authentication**: JWT
- **Styling**: Tailwind CSS
- **Containerization**: Docker + Docker Compose

---

## ⚡ Quick Start

### 🎯 วิธีที่เร็วที่สุด
```bash
# 1. รันไฟล์ batch manager
erp-manager.bat

# 2. เลือก "1" สำหรับ Full Setup
# 3. รอติดตั้งเสร็จ (2-3 นาที)
# 4. เข้าใช้งาน Admin Panel
```

### 🔗 URLs สำคัญ
- **Admin Panel**: http://localhost:3000/admin/login
- **Test Registration**: http://localhost:3000/test-registration.html
- **phpMyAdmin**: http://localhost:8080

### 🔑 ข้อมูลเข้าใช้งาน
```
Admin Panel:
📧 Email: admin@sunerp.com
🔐 Password: admin123

Database:
🖥️ Host: localhost:3306
👤 Username: erp_app
🔐 Password: erp_app_pass123
```

---

## 🏗️ สถาปัตยกรรม

### Database Structure

#### Main Database (`erp_main`)
```sql
📊 organizations        -- ข้อมูลองค์กรทั้งหมด
👤 admin_users          -- Super Admin ระบบ
📋 admin_audit_logs     -- บันทึกการทำงาน
⚙️ admin_settings       -- การตั้งค่าระบบ
```

#### Organization Schemas (`org_xxxxx`)
```sql
👥 users                -- ผู้ใช้ในองค์กร
🔐 user_permissions     -- สิทธิ์แบบละเอียด
📋 role_templates       -- template สิทธิ์

-- โมดูล ERP
🏢 hrm_*               -- Human Resource Management
💰 accounting_*        -- การบัญชี
🛒 sales_*             -- การขาย
📦 inventory_*         -- คลังสินค้า
🛍️ purchasing_*        -- การจัดซื้อ
📞 crm_*               -- Customer Relationship
📋 project_*           -- การจัดการโครงการ
```

### Multi-Tenant Flow
```
1. Organization Registration
   ↓
2. Admin Approval
   ↓
3. Auto Schema Creation (org_xxxxx)
   ↓
4. Super Admin Creation
   ↓
5. Ready to Use
```

---

## 👥 การจัดการผู้ใช้

### User Roles

#### 🔴 SUPER_ADMIN
- **ที่มา**: สร้างอัตโนมัติเมื่ออนุมัติองค์กร
- **อีเมล**: `admin_[ORG_CODE]` (เช่น admin_ORG2507101234)
- **รหัสผ่าน**: `123456` (เปลี่ยนได้)
- **สิทธิ์**: ครบทุกสิทธิ์ (100 permissions)
- **ข้อจำกัด**: ไม่สามารถลบหรือปิดใช้งานได้

#### 🔵 ADMIN
- **ที่มา**: สร้างโดย Super Admin
- **สิทธิ์**: ตามที่ Super Admin กำหนด
- **ข้อจำกัด**: สามารถลบและปิดใช้งานได้

#### 🟡 MANAGER / USER / VIEWER
- **ที่มา**: สร้างโดย Admin ขึ้นไป
- **สิทธิ์**: ตาม role template + custom permissions
- **ข้อจำกัด**: สามารถจัดการได้ตามสิทธิ์

### User Management Flow

#### การสร้างองค์กรใหม่
```
1. กรอกข้อมูลองค์กรใน Test Registration
2. Admin Panel → Organizations → Approve
3. ระบบสร้าง schema org_xxxxx อัตโนมัติ
4. ระบบสร้าง Super Admin อัตโนมัติ
5. Super Admin ใช้ Flutter App ได้ทันที
```

#### การจัดการผู้ใช้ใน Admin Panel
```
1. เข้า Organization Detail
2. ดูรายการ Users
3. Add/Edit/Delete/Toggle Status
4. Manage Permissions (ยกเว้น Super Admin)
5. Change Password (Super Admin เปลี่ยนได้เฉพาะรหัสผ่าน)
```

---

## 🔐 ระบบสิทธิ์

### Permission Structure
```
Module
├── Submodule
    ├── view     (ดู)
    ├── create   (สร้าง)
    ├── edit     (แก้ไข)
    └── delete   (ลบ)
```

### Modules & Submodules

#### 🏢 HRM (Human Resource Management)
- **employees** - จัดการพนักงาน
- **payroll** - เงินเดือนและสวัสดิการ
- **attendance** - เวลาเข้า-ออกงาน
- **leave** - การลางาน
- **performance** - ประเมินผลงาน

#### 💰 Accounting (การบัญชี)
- **accounts** - บัญชี
- **journal** - รายการบัญชี
- **reports** - รายงานทางการเงิน
- **budget** - งบประมาณ
- **assets** - สินทรัพย์

#### 🛒 Sales (การขาย)
- **customers** - ลูกค้า
- **orders** - คำสั่งซื้อ
- **invoices** - ใบแจ้งหนี้
- **quotes** - ใบเสนอราคา
- **reports** - รายงานการขาย

#### 📦 Inventory (คลังสินค้า)
- **products** - สินค้า
- **stock** - สต็อก
- **warehouse** - คลังสินค้า
- **categories** - หมวดหมู่
- **adjustments** - ปรับปรุงสต็อก

#### 🛍️ Purchasing (การจัดซื้อ)
- **suppliers** - ผู้จำหน่าย
- **purchase_orders** - ใบสั่งซื้อ
- **receipts** - ใบรับสินค้า
- **payments** - การชำระเงิน
- **reports** - รายงานการจัดซื้อ

#### 📞 CRM (Customer Relationship)
- **leads** - ลูกค้าเป้าหมาย
- **contacts** - รายชื่อติดต่อ
- **opportunities** - โอกาสทางการขาย
- **campaigns** - แคมเปญ
- **reports** - รายงาน CRM

#### 📋 Project (การจัดการโครงการ)
- **projects** - โครงการ
- **tasks** - งาน
- **time_tracking** - ติดตามเวลา
- **resources** - ทรัพยากร
- **reports** - รายงานโครงการ

#### ⚙️ Settings (การตั้งค่า)
- **users** - ผู้ใช้งาน
- **roles** - บทบาท
- **permissions** - สิทธิ์
- **system** - ระบบ
- **backup** - สำรองข้อมูล

### Total Permissions
**25 submodules × 4 permissions = 100 permissions**

---

## 🧪 การทดสอบ

### Integration Test

#### วิธีรัน
```bash
npm run test:integration
```

#### สิ่งที่ทดสอบ
- ✅ การสร้าง database schema
- ✅ การสร้างตาราง users และ user_permissions
- ✅ การสร้าง Super Admin อัตโนมัติ
- ✅ รูปแบบอีเมล admin_[ORG_CODE]
- ✅ การให้สิทธิ์ครบทุกสิทธิ์
- ✅ การทำความสะอาดข้อมูลทดสอบ

#### ผลลัพธ์ที่คาดหวัง
```
🎉 Super Admin creation test PASSED!

📋 Summary:
   ✅ Email format: admin_[ORG_CODE]
   ✅ Name: Super Admin
   ✅ Role: SUPER_ADMIN
   ✅ Password: 123456 (changeable)
   ✅ Permissions: Full access to all modules
```

### Manual Testing

#### 1. Organization Registration
```
1. เปิด http://localhost:3000/test-registration.html
2. กรอกข้อมูลองค์กร
3. ส่งฟอร์ม
4. ตรวจสอบใน Admin Panel
```

#### 2. Organization Approval
```
1. เข้า Admin Panel
2. ไปที่ Organizations
3. คลิก organization ที่ต้องการ
4. คลิก Approve
5. ตรวจสอบ Super Admin ใน Users section
```

#### 3. Super Admin Login
```
1. ใช้ Flutter App
2. ล็อกอินด้วย admin_[ORG_CODE]
3. รหัสผ่าน 123456
4. ทดสอบสิทธิ์ต่างๆ
```

---

## 🗄️ โครงสร้างฐานข้อมูล

### Schema Naming Convention
```
Main Database: erp_main
Organization Schemas: org_[orgcode_lowercase]

ตัวอย่าง:
- org_company123
- org_test2507101234
- org_abcltd
```

### Table Naming Convention
```
System Tables: table_name
Module Tables: module_table_name

ตัวอย่าง:
- users, user_permissions
- hrm_employees, hrm_departments
- accounting_transactions
- sales_customers, sales_orders
```

### Key Tables

#### users
```sql
id               VARCHAR(191) PRIMARY KEY
email            VARCHAR(191) UNIQUE
name             VARCHAR(191)
password         VARCHAR(191)
role             ENUM('SUPER_ADMIN', 'ADMIN', 'MANAGER', 'USER', 'VIEWER')
is_active        BOOLEAN DEFAULT TRUE
created_at       DATETIME(3)
updated_at       DATETIME(3)
```

#### user_permissions
```sql
id               INT AUTO_INCREMENT PRIMARY KEY
user_id          VARCHAR(191)
module           VARCHAR(100)
submodule        VARCHAR(100)
permission       VARCHAR(50)
granted          BOOLEAN DEFAULT FALSE
created_at       DATETIME(3)
updated_at       DATETIME(3)
```

---

## 🔧 การใช้งาน

### ERP Manager Tool (`erp-manager.bat`)

#### คำสั่งหลัก
1. **🏗️ Full Setup** - ติดตั้งครั้งแรก
2. **🐳 Start Docker** - เริ่ม Docker เท่านั้น
3. **🖥️ Start Dev Server** - เริ่ม development server
4. **🧪 Run Tests** - รันการทดสอบ
5. **📊 Admin Dashboard** - เปิด Admin Panel
6. **🗄️ phpMyAdmin** - เปิดฐานข้อมูล
7. **🔄 Reset Database** - ล้างข้อมูลทั้งหมด
8. **🛑 Stop Services** - หยุดบริการทั้งหมด

### NPM Scripts
```bash
npm run dev          # เริ่ม development server
npm run build        # build สำหรับ production
npm run start        # เริ่ม production server
npm run db:push      # อัปเดต database schema
npm run db:generate  # สร้าง Prisma client
npm run db:seed      # เพิ่มข้อมูลเริ่มต้น
npm run test:integration  # รันการทดสอบ
```

### Docker Commands
```bash
docker-compose up -d     # เริ่ม services
docker-compose down      # หยุด services
docker-compose logs -f   # ดู logs
```

---

## ❓ แก้ปัญหา

### ปัญหาที่พบบ่อย

#### 1. 🚫 Connection Error
```
❌ Error: connect ECONNREFUSED 127.0.0.1:3306
```
**วิธีแก้:**
```bash
# ตรวจสอบ Docker
docker-compose ps

# เริ่มใหม่
docker-compose up -d
```

#### 2. 🔐 Permission Denied
```
❌ Error: Access denied for user 'erp_app'
```
**วิธีแก้:**
```bash
# ตรวจสอบไฟล์ .env
# ตรวจสอบ database credentials
```

#### 3. 📊 Admin Login Failed
```
❌ Invalid credentials
```
**วิธีแก้:**
```bash
# รัน seed ใหม่
npm run db:seed

# ใช้ข้อมูล default:
# Email: admin@sunerp.com
# Password: admin123
```

#### 4. 🗄️ Schema Not Created
```
❌ Schema org_xxxxx not found
```
**วิธีแก้:**
```bash
# ตรวจสอบ user permissions ใน MySQL
# อนุมัติองค์กรใหม่ผ่าน Admin Panel
```

#### 5. 🧪 Test Failed
```
❌ Integration test failed
```
**วิธีแก้:**
```bash
# ตรวจสอบ MySQL connection
# ตรวจสอบ ENUM values ในตาราง users
npm run test:integration
```

### Debug Mode

#### เปิด Verbose Logging
```javascript
// ใน .env
NODE_ENV=development
DEBUG=true
```

#### ตรวจสอบ Database
```sql
-- ดู schemas ทั้งหมด
SHOW DATABASES LIKE 'org_%';

-- ดู users ใน schema
USE org_xxxxx;
SELECT * FROM users;

-- ดู permissions
SELECT * FROM user_permissions WHERE user_id = 'xxx';
```

### Performance Tips

#### 1. Database
- ใช้ indexes ที่เหมาะสม
- ล้างข้อมูลทดสอบเป็นประจำ
- Monitor connection pool

#### 2. Application
- ใช้ Prisma connection pooling
- Cache static data
- Optimize API responses

---

## 📞 ติดต่อและสนับสนุน

### การรายงานปัญหา
1. รัน integration test ก่อน
2. รวบรวม error logs
3. ระบุขั้นตอนที่ทำให้เกิดปัญหา
4. รวม environment information

### การพัฒนาต่อ
1. สร้าง feature branch
2. เขียน tests สำหรับ feature ใหม่
3. อัปเดตเอกสาร
4. ทดสอบ integration

---

## 📝 เวอร์ชั่นและการอัปเดต

### Version History
- **v1.0** - ระบบพื้นฐาน Multi-tenant
- **v1.1** - เพิ่ม Super Admin auto-creation
- **v1.2** - ระบบสิทธิ์แบบละเอียด
- **v1.3** - Admin Panel UI/UX improvements
- **v1.4** - Integration testing framework
- **v1.5** - รวมเอกสารและจัดการไฟล์

### Roadmap
- [ ] API Rate Limiting
- [ ] Advanced Audit Logging
- [ ] Multi-language Support
- [ ] Mobile Admin App
- [ ] Advanced Analytics

---

**🎉 ขขอบคุณที่ใช้ ERP Backend System!**

> หากมีคำถามหรือต้องการความช่วยเหลือเพิ่มเติม กรุณาอ่านส่วน [แก้ปัญหา](#-แก้ปัญหา) หรือรันการทดสอบด้วย `npm run test:integration`
