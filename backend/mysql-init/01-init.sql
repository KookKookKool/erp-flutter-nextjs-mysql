-- สร้าง Database เริ่มต้น
CREATE DATABASE IF NOT EXISTS erp_main;

-- ใช้ Database หลัก
USE erp_main;

-- ตั้งค่า Character Set เป็น UTF8MB4 สำหรับ Thai และ Emoji
ALTER DATABASE erp_main CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- สร้าง User สำหรับ Application
CREATE USER IF NOT EXISTS 'erp_app'@'%' IDENTIFIED BY 'erp_app_pass123';
GRANT ALL PRIVILEGES ON *.* TO 'erp_app'@'%' WITH GRANT OPTION;

-- แสดงข้อมูล
SELECT 'ERP Database initialized successfully!' AS message;
