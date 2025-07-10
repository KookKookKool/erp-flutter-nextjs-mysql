import mysql from 'mysql2/promise'
import prisma from './prisma'
import bcrypt from 'bcryptjs'
import { v4 as uuidv4 } from 'uuid'
import { PrismaClient } from '@prisma/client'

export class DatabaseManager {
  private static instance: DatabaseManager
  private connections: Map<string, mysql.Connection> = new Map()
  private orgClients: Map<string, PrismaClient> = new Map()

  static getInstance(): DatabaseManager {
    if (!DatabaseManager.instance) {
      DatabaseManager.instance = new DatabaseManager()
    }
    return DatabaseManager.instance
  }

  // สร้าง Database Schema ใหม่สำหรับองค์กร
  async createOrganizationSchema(orgCode: string, adminData?: {
    adminName: string,
    adminEmail: string,
    orgName: string
  }): Promise<string> {
    const schemaName = `org_${orgCode.toLowerCase()}`
    
    // สร้าง connection ไปยัง MySQL
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: 'erp_main'
    })

    try {
      // สร้าง Database Schema
      await connection.query(`CREATE DATABASE IF NOT EXISTS \`${schemaName}\``)
      
      // สร้างตาราง Users สำหรับองค์กรนี้
      await connection.query(`USE \`${schemaName}\``)
      
      // สร้างตารางพื้นฐานสำหรับ ERP
      await this.createBasicTables(connection)
      
      // ปิด connection เดิม
      await connection.end()
      
      // Populate default role permissions
      await this.populateDefaultRolePermissions(schemaName)
      
      console.log(`✅ Created schema: ${schemaName}`)
      return schemaName
      
    } catch (error) {
      console.error(`❌ Error creating schema ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }

  // สร้างตารางพื้นฐานสำหรับ ERP ในแต่ละองค์กร
  private async createBasicTables(connection: mysql.Connection) {
    // สร้างตารางระบบพื้นฐาน
    await this.createSystemTables(connection)
    
    // สร้างตาราง HRM Module
    await this.createHRMTables(connection)
    
    // สร้างตาราง Accounting Module
    await this.createAccountingTables(connection)
    
    // สร้างตาราง Sales Module
    await this.createSalesTables(connection)
    
    // สร้างตาราง Inventory Module
    await this.createInventoryTables(connection)
    
    // สร้างตาราง Purchasing Module
    await this.createPurchasingTables(connection)
    
    // สร้างตาราง CRM Module
    await this.createCRMTables(connection)
    
    // สร้างตาราง Project Module
    await this.createProjectTables(connection)
    
    // สร้างตาราง Settings Module
    await this.createSettingsTables(connection)
  }

  // สร้างตารางระบบพื้นฐาน
  private async createSystemTables(connection: mysql.Connection) {
    const tables = [
      // Users table สำหรับองค์กร
      `CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        email VARCHAR(191) NOT NULL UNIQUE,
        name VARCHAR(191) NOT NULL,
        password VARCHAR(191) NOT NULL,
        role ENUM('SUPER_ADMIN', 'ADMIN', 'MANAGER', 'USER', 'VIEWER') DEFAULT 'USER',
        is_active BOOLEAN DEFAULT TRUE,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
      )`,

      // User permissions table สำหรับจัดการสิทธิ์แบบละเอียด
      `CREATE TABLE IF NOT EXISTS user_permissions (
        id VARCHAR(36) NOT NULL PRIMARY KEY,
        user_id VARCHAR(191) NOT NULL,
        module VARCHAR(100) NOT NULL,
        submodule VARCHAR(100) NOT NULL,
        permission VARCHAR(50) NOT NULL,
        has_permission BOOLEAN DEFAULT FALSE,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_user_module (user_id, module, submodule),
        INDEX idx_permission (permission),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE KEY unique_user_permission (user_id, module, submodule, permission)
      )`,

      // Role templates table สำหรับเก็บ template สิทธิ์ตาม role
      `CREATE TABLE IF NOT EXISTS role_templates (
        id INT AUTO_INCREMENT PRIMARY KEY,
        role VARCHAR(50) NOT NULL,
        module VARCHAR(100) NOT NULL,
        submodule VARCHAR(100) NOT NULL,
        permission VARCHAR(50) NOT NULL,
        granted BOOLEAN DEFAULT FALSE,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_role_module (role, module, submodule),
        UNIQUE KEY unique_role_permission (role, module, submodule, permission)
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง HRM Module
  private async createHRMTables(connection: mysql.Connection) {
    const tables = [
      // HRM_EMPLOYEES - จัดการข้อมูลพนักงาน
      `CREATE TABLE IF NOT EXISTS hrm_employees (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        employee_code VARCHAR(100) NOT NULL UNIQUE,
        user_id VARCHAR(191),
        department_id VARCHAR(191),
        first_name VARCHAR(191) NOT NULL,
        last_name VARCHAR(191) NOT NULL,
        full_name VARCHAR(191) GENERATED ALWAYS AS (CONCAT(first_name, ' ', last_name)) STORED,
        position VARCHAR(191),
        email VARCHAR(191),
        phone VARCHAR(50),
        address TEXT,
        hire_date DATE,
        birth_date DATE,
        id_card VARCHAR(20),
        salary DECIMAL(15,2),
        status ENUM('ACTIVE', 'INACTIVE', 'TERMINATED') DEFAULT 'ACTIVE',
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_employee_code (employee_code),
        INDEX idx_department (department_id),
        INDEX idx_user (user_id),
        INDEX idx_status (status),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // HRM_DEPARTMENTS - หน่วยงาน/แผนก
      `CREATE TABLE IF NOT EXISTS hrm_departments (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        name VARCHAR(191) NOT NULL,
        description TEXT,
        manager_id VARCHAR(191),
        parent_id VARCHAR(191),
        is_active BOOLEAN DEFAULT TRUE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_manager (manager_id),
        INDEX idx_parent (parent_id),
        FOREIGN KEY (manager_id) REFERENCES hrm_employees(id) ON DELETE SET NULL
      )`,

      // HRM_ATTENDANCE - บันทึกเวลาเข้า-ออกงาน
      `CREATE TABLE IF NOT EXISTS hrm_attendance (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        employee_id VARCHAR(191) NOT NULL,
        date DATE NOT NULL,
        check_in_time TIME,
        check_out_time TIME,
        break_time_minutes INT DEFAULT 0,
        overtime_minutes INT DEFAULT 0,
        late_minutes INT DEFAULT 0,
        status ENUM('PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'HOLIDAY') DEFAULT 'PRESENT',
        notes TEXT,
        approved_by VARCHAR(191),
        approved_at DATETIME(3),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_employee_date (employee_id, date),
        INDEX idx_date (date),
        INDEX idx_status (status),
        FOREIGN KEY (employee_id) REFERENCES hrm_employees(id) ON DELETE CASCADE,
        FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
        UNIQUE KEY unique_employee_date (employee_id, date)
      )`,

      // HRM_LEAVE_REQUESTS - คำขอลางาน
      `CREATE TABLE IF NOT EXISTS hrm_leave_requests (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        employee_id VARCHAR(191) NOT NULL,
        leave_type ENUM('SICK', 'ANNUAL', 'PERSONAL', 'MATERNITY', 'PATERNITY', 'OTHER') NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        days_requested DECIMAL(3,1) NOT NULL,
        reason TEXT NOT NULL,
        status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED') DEFAULT 'PENDING',
        approved_by VARCHAR(191),
        approved_at DATETIME(3),
        rejection_reason TEXT,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_employee (employee_id),
        INDEX idx_dates (start_date, end_date),
        INDEX idx_status (status),
        INDEX idx_leave_type (leave_type),
        FOREIGN KEY (employee_id) REFERENCES hrm_employees(id) ON DELETE CASCADE,
        FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // HRM_PAYROLL - เงินเดือนและสวัสดิการ
      `CREATE TABLE IF NOT EXISTS hrm_payroll (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        employee_id VARCHAR(191) NOT NULL,
        period_year INT NOT NULL,
        period_month INT NOT NULL,
        base_salary DECIMAL(15,2) NOT NULL,
        overtime_pay DECIMAL(15,2) DEFAULT 0,
        bonus DECIMAL(15,2) DEFAULT 0,
        allowances DECIMAL(15,2) DEFAULT 0,
        deductions DECIMAL(15,2) DEFAULT 0,
        tax_deduction DECIMAL(15,2) DEFAULT 0,
        social_security DECIMAL(15,2) DEFAULT 0,
        net_salary DECIMAL(15,2) NOT NULL,
        status ENUM('DRAFT', 'CALCULATED', 'APPROVED', 'PAID') DEFAULT 'DRAFT',
        paid_date DATE,
        notes TEXT,
        approved_by VARCHAR(191),
        approved_at DATETIME(3),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_employee_period (employee_id, period_year, period_month),
        INDEX idx_period (period_year, period_month),
        INDEX idx_status (status),
        FOREIGN KEY (employee_id) REFERENCES hrm_employees(id) ON DELETE CASCADE,
        FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
        UNIQUE KEY unique_employee_period (employee_id, period_year, period_month)
      )`,

      // HRM_ANNOUNCEMENTS - ประกาศข่าวสาร
      `CREATE TABLE IF NOT EXISTS hrm_announcements (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        content TEXT NOT NULL,
        type ENUM('GENERAL', 'URGENT', 'POLICY', 'EVENT', 'NOTICE') DEFAULT 'GENERAL',
        target_departments JSON,
        target_employees JSON,
        is_published BOOLEAN DEFAULT FALSE,
        published_at DATETIME(3),
        expires_at DATETIME(3),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_type (type),
        INDEX idx_published (is_published, published_at),
        INDEX idx_expires (expires_at),
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้าง Accounting Module
  private async createAccountingTables(connection: mysql.Connection) {
    const tables = [
      // ACCOUNTING_INCOME - จัดการรายได้
      `CREATE TABLE IF NOT EXISTS accounting_income (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        income_code VARCHAR(100) NOT NULL UNIQUE,
        category ENUM('SALES', 'SERVICE', 'INTEREST', 'OTHER') NOT NULL,
        description TEXT NOT NULL,
        amount DECIMAL(15,2) NOT NULL,
        tax_amount DECIMAL(15,2) DEFAULT 0,
        net_amount DECIMAL(15,2) NOT NULL,
        income_date DATE NOT NULL,
        payment_method ENUM('CASH', 'BANK_TRANSFER', 'CREDIT_CARD', 'CHEQUE') DEFAULT 'CASH',
        customer_id VARCHAR(191),
        reference_number VARCHAR(100),
        status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'PENDING',
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_income_code (income_code),
        INDEX idx_category (category),
        INDEX idx_income_date (income_date),
        INDEX idx_customer (customer_id),
        INDEX idx_status (status)
      )`,

      // ACCOUNTING_EXPENSES - จัดการรายจ่าย
      `CREATE TABLE IF NOT EXISTS accounting_expenses (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        expense_code VARCHAR(100) NOT NULL UNIQUE,
        category ENUM('SALARY', 'RENT', 'UTILITIES', 'SUPPLIES', 'MARKETING', 'OTHER') NOT NULL,
        description TEXT NOT NULL,
        amount DECIMAL(15,2) NOT NULL,
        tax_amount DECIMAL(15,2) DEFAULT 0,
        net_amount DECIMAL(15,2) NOT NULL,
        expense_date DATE NOT NULL,
        payment_method ENUM('CASH', 'BANK_TRANSFER', 'CREDIT_CARD', 'CHEQUE') DEFAULT 'CASH',
        supplier_id VARCHAR(191),
        reference_number VARCHAR(100),
        receipt_number VARCHAR(100),
        status ENUM('PENDING', 'PAID', 'CANCELLED') DEFAULT 'PENDING',
        approved_by VARCHAR(191),
        approved_at DATETIME(3),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_expense_code (expense_code),
        INDEX idx_category (category),
        INDEX idx_expense_date (expense_date),
        INDEX idx_supplier (supplier_id),
        INDEX idx_status (status),
        FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // ACCOUNTING_TRANSACTIONS - รายการบัญชี
      `CREATE TABLE IF NOT EXISTS accounting_transactions (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        transaction_code VARCHAR(100) NOT NULL UNIQUE,
        type ENUM('INCOME', 'EXPENSE', 'TRANSFER') NOT NULL,
        description TEXT NOT NULL,
        amount DECIMAL(15,2) NOT NULL,
        transaction_date DATE NOT NULL,
        account_from VARCHAR(100),
        account_to VARCHAR(100),
        reference_id VARCHAR(191),
        reference_type VARCHAR(50),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_transaction_code (transaction_code),
        INDEX idx_type (type),
        INDEX idx_transaction_date (transaction_date),
        INDEX idx_reference (reference_id, reference_type)
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง Sales Module
  private async createSalesTables(connection: mysql.Connection) {
    const tables = [
      // SALES_CUSTOMERS - ลูกค้า
      `CREATE TABLE IF NOT EXISTS sales_customers (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        customer_code VARCHAR(100) NOT NULL UNIQUE,
        customer_type ENUM('INDIVIDUAL', 'BUSINESS') NOT NULL,
        name VARCHAR(191) NOT NULL,
        email VARCHAR(191),
        phone VARCHAR(50),
        address TEXT,
        tax_id VARCHAR(20),
        credit_limit DECIMAL(15,2) DEFAULT 0,
        payment_terms INT DEFAULT 30,
        contact_person VARCHAR(191),
        notes TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_customer_code (customer_code),
        INDEX idx_customer_type (customer_type),
        INDEX idx_email (email),
        INDEX idx_is_active (is_active)
      )`,

      // SALES_QUOTATIONS - ใบเสนอราคา
      `CREATE TABLE IF NOT EXISTS sales_quotations (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        quotation_number VARCHAR(100) NOT NULL UNIQUE,
        customer_id VARCHAR(191) NOT NULL,
        quotation_date DATE NOT NULL,
        valid_until DATE NOT NULL,
        subtotal DECIMAL(15,2) NOT NULL,
        discount_amount DECIMAL(15,2) DEFAULT 0,
        tax_amount DECIMAL(15,2) DEFAULT 0,
        total_amount DECIMAL(15,2) NOT NULL,
        status ENUM('DRAFT', 'SENT', 'ACCEPTED', 'REJECTED', 'EXPIRED') DEFAULT 'DRAFT',
        notes TEXT,
        terms_conditions TEXT,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        approved_by VARCHAR(191),
        approved_at DATETIME(3),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_quotation_number (quotation_number),
        INDEX idx_customer (customer_id),
        INDEX idx_quotation_date (quotation_date),
        INDEX idx_status (status),
        FOREIGN KEY (customer_id) REFERENCES sales_customers(id) ON DELETE CASCADE,
        FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // SALES_QUOTATION_ITEMS - รายการสินค้าในใบเสนอราคา
      `CREATE TABLE IF NOT EXISTS sales_quotation_items (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        quotation_id VARCHAR(191) NOT NULL,
        product_id VARCHAR(191),
        product_name VARCHAR(191) NOT NULL,
        product_description TEXT,
        quantity DECIMAL(10,2) NOT NULL,
        unit_price DECIMAL(15,2) NOT NULL,
        discount_percent DECIMAL(5,2) DEFAULT 0,
        line_total DECIMAL(15,2) NOT NULL,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_quotation (quotation_id),
        INDEX idx_product (product_id),
        FOREIGN KEY (quotation_id) REFERENCES sales_quotations(id) ON DELETE CASCADE
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง Inventory Module
  private async createInventoryTables(connection: mysql.Connection) {
    const tables = [
      // INVENTORY_PRODUCTS - สินค้า
      `CREATE TABLE IF NOT EXISTS inventory_products (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        sku VARCHAR(100) NOT NULL UNIQUE,
        barcode VARCHAR(100),
        name VARCHAR(191) NOT NULL,
        description TEXT,
        category_id VARCHAR(191),
        unit VARCHAR(50) DEFAULT 'PCS',
        cost_price DECIMAL(15,2) DEFAULT 0,
        selling_price DECIMAL(15,2) DEFAULT 0,
        min_stock_level INT DEFAULT 0,
        max_stock_level INT DEFAULT 0,
        reorder_point INT DEFAULT 0,
        weight DECIMAL(8,2),
        dimensions VARCHAR(100),
        is_active BOOLEAN DEFAULT TRUE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_sku (sku),
        INDEX idx_barcode (barcode),
        INDEX idx_category (category_id),
        INDEX idx_is_active (is_active)
      )`,

      // INVENTORY_CATEGORIES - หมวดหมู่สินค้า
      `CREATE TABLE IF NOT EXISTS inventory_categories (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        name VARCHAR(191) NOT NULL,
        description TEXT,
        parent_id VARCHAR(191),
        is_active BOOLEAN DEFAULT TRUE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_parent (parent_id),
        INDEX idx_is_active (is_active)
      )`,

      // INVENTORY_STOCK - คลังสินค้า
      `CREATE TABLE IF NOT EXISTS inventory_stock (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        product_id VARCHAR(191) NOT NULL,
        location VARCHAR(100) DEFAULT 'MAIN_WAREHOUSE',
        quantity_on_hand DECIMAL(10,2) DEFAULT 0,
        quantity_reserved DECIMAL(10,2) DEFAULT 0,
        quantity_available DECIMAL(10,2) GENERATED ALWAYS AS (quantity_on_hand - quantity_reserved) STORED,
        last_counted_at DATETIME(3),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_product (product_id),
        INDEX idx_location (location),
        FOREIGN KEY (product_id) REFERENCES inventory_products(id) ON DELETE CASCADE,
        UNIQUE KEY unique_product_location (product_id, location)
      )`,

      // INVENTORY_TRANSACTIONS - การเคลื่อนไหวสต็อก
      `CREATE TABLE IF NOT EXISTS inventory_transactions (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        transaction_code VARCHAR(100) NOT NULL UNIQUE,
        product_id VARCHAR(191) NOT NULL,
        transaction_type ENUM('IN', 'OUT', 'ADJUST', 'TRANSFER') NOT NULL,
        quantity DECIMAL(10,2) NOT NULL,
        unit_cost DECIMAL(15,2),
        total_cost DECIMAL(15,2),
        reference_type VARCHAR(50),
        reference_id VARCHAR(191),
        location VARCHAR(100) DEFAULT 'MAIN_WAREHOUSE',
        notes TEXT,
        transaction_date DATETIME(3) NOT NULL,
        created_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        INDEX idx_transaction_code (transaction_code),
        INDEX idx_product (product_id),
        INDEX idx_transaction_type (transaction_type),
        INDEX idx_transaction_date (transaction_date),
        INDEX idx_reference (reference_type, reference_id),
        FOREIGN KEY (product_id) REFERENCES inventory_products(id) ON DELETE CASCADE
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง Purchasing Module
  private async createPurchasingTables(connection: mysql.Connection) {
    const tables = [
      // PURCHASING_SUPPLIERS - ผู้จำหน่าย
      `CREATE TABLE IF NOT EXISTS purchasing_suppliers (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        supplier_code VARCHAR(100) NOT NULL UNIQUE,
        name VARCHAR(191) NOT NULL,
        contact_person VARCHAR(191),
        email VARCHAR(191),
        phone VARCHAR(50),
        address TEXT,
        tax_id VARCHAR(20),
        payment_terms INT DEFAULT 30,
        credit_limit DECIMAL(15,2) DEFAULT 0,
        bank_account VARCHAR(100),
        notes TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_supplier_code (supplier_code),
        INDEX idx_email (email),
        INDEX idx_is_active (is_active)
      )`,

      // PURCHASING_ORDERS - ใบสั่งซื้อ
      `CREATE TABLE IF NOT EXISTS purchasing_orders (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        order_number VARCHAR(100) NOT NULL UNIQUE,
        supplier_id VARCHAR(191) NOT NULL,
        order_date DATE NOT NULL,
        expected_delivery_date DATE,
        subtotal DECIMAL(15,2) NOT NULL,
        discount_amount DECIMAL(15,2) DEFAULT 0,
        tax_amount DECIMAL(15,2) DEFAULT 0,
        total_amount DECIMAL(15,2) NOT NULL,
        status ENUM('DRAFT', 'SENT', 'CONFIRMED', 'RECEIVED', 'CANCELLED') DEFAULT 'DRAFT',
        notes TEXT,
        terms_conditions TEXT,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        approved_by VARCHAR(191),
        approved_at DATETIME(3),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_order_number (order_number),
        INDEX idx_supplier (supplier_id),
        INDEX idx_order_date (order_date),
        INDEX idx_status (status),
        FOREIGN KEY (supplier_id) REFERENCES purchasing_suppliers(id) ON DELETE CASCADE,
        FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // PURCHASING_ORDER_ITEMS - รายการสินค้าในใบสั่งซื้อ
      `CREATE TABLE IF NOT EXISTS purchasing_order_items (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        order_id VARCHAR(191) NOT NULL,
        product_id VARCHAR(191),
        product_name VARCHAR(191) NOT NULL,
        product_description TEXT,
        quantity DECIMAL(10,2) NOT NULL,
        unit_cost DECIMAL(15,2) NOT NULL,
        line_total DECIMAL(15,2) NOT NULL,
        received_quantity DECIMAL(10,2) DEFAULT 0,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_order (order_id),
        INDEX idx_product (product_id),
        FOREIGN KEY (order_id) REFERENCES purchasing_orders(id) ON DELETE CASCADE
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง CRM Module
  private async createCRMTables(connection: mysql.Connection) {
    const tables = [
      // CRM_CUSTOMERS - ลูกค้า CRM
      `CREATE TABLE IF NOT EXISTS crm_customers (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        customer_code VARCHAR(100) NOT NULL UNIQUE,
        first_name VARCHAR(191) NOT NULL,
        last_name VARCHAR(191) NOT NULL,
        full_name VARCHAR(191) GENERATED ALWAYS AS (CONCAT(first_name, ' ', last_name)) STORED,
        company VARCHAR(191),
        position VARCHAR(191),
        email VARCHAR(191),
        phone VARCHAR(50),
        mobile VARCHAR(50),
        address TEXT,
        source ENUM('WEBSITE', 'REFERRAL', 'MARKETING', 'COLD_CALL', 'OTHER') DEFAULT 'OTHER',
        status ENUM('LEAD', 'PROSPECT', 'CUSTOMER', 'INACTIVE') DEFAULT 'LEAD',
        assigned_to VARCHAR(191),
        notes TEXT,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_customer_code (customer_code),
        INDEX idx_email (email),
        INDEX idx_status (status),
        INDEX idx_assigned_to (assigned_to),
        FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // CRM_INTERACTIONS - ประวัติการติดต่อ
      `CREATE TABLE IF NOT EXISTS crm_interactions (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        customer_id VARCHAR(191) NOT NULL,
        interaction_type ENUM('CALL', 'EMAIL', 'MEETING', 'NOTE', 'TASK') NOT NULL,
        subject VARCHAR(255) NOT NULL,
        description TEXT,
        interaction_date DATETIME(3) NOT NULL,
        duration_minutes INT,
        outcome VARCHAR(255),
        follow_up_date DATE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_customer (customer_id),
        INDEX idx_interaction_type (interaction_type),
        INDEX idx_interaction_date (interaction_date),
        INDEX idx_follow_up (follow_up_date),
        FOREIGN KEY (customer_id) REFERENCES crm_customers(id) ON DELETE CASCADE,
        FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // CRM_ACTIVITIES - กิจกรรม/งาน
      `CREATE TABLE IF NOT EXISTS crm_activities (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        customer_id VARCHAR(191) NOT NULL,
        activity_type ENUM('CALL', 'EMAIL', 'MEETING', 'TASK', 'APPOINTMENT') NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
        status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
        due_date DATETIME(3),
        completed_at DATETIME(3),
        assigned_to VARCHAR(191),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_customer (customer_id),
        INDEX idx_activity_type (activity_type),
        INDEX idx_status (status),
        INDEX idx_due_date (due_date),
        INDEX idx_assigned_to (assigned_to),
        FOREIGN KEY (customer_id) REFERENCES crm_customers(id) ON DELETE CASCADE,
        FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง Project Module
  private async createProjectTables(connection: mysql.Connection) {
    const tables = [
      // PROJECT_PROJECTS - โครงการ
      `CREATE TABLE IF NOT EXISTS project_projects (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        project_code VARCHAR(100) NOT NULL UNIQUE,
        name VARCHAR(191) NOT NULL,
        description TEXT,
        start_date DATE,
        end_date DATE,
        estimated_hours DECIMAL(8,2),
        actual_hours DECIMAL(8,2) DEFAULT 0,
        budget DECIMAL(15,2),
        actual_cost DECIMAL(15,2) DEFAULT 0,
        status ENUM('PLANNING', 'IN_PROGRESS', 'ON_HOLD', 'COMPLETED', 'CANCELLED') DEFAULT 'PLANNING',
        priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
        manager_id VARCHAR(191),
        client_id VARCHAR(191),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_project_code (project_code),
        INDEX idx_status (status),
        INDEX idx_manager (manager_id),
        INDEX idx_client (client_id),
        FOREIGN KEY (manager_id) REFERENCES users(id) ON DELETE SET NULL
      )`,

      // PROJECT_TASKS - งาน/หน้าที่
      `CREATE TABLE IF NOT EXISTS project_tasks (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        project_id VARCHAR(191) NOT NULL,
        task_code VARCHAR(100) NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        parent_task_id VARCHAR(191),
        start_date DATE,
        due_date DATE,
        estimated_hours DECIMAL(8,2),
        actual_hours DECIMAL(8,2) DEFAULT 0,
        progress_percent DECIMAL(5,2) DEFAULT 0,
        status ENUM('TODO', 'IN_PROGRESS', 'REVIEW', 'COMPLETED', 'CANCELLED') DEFAULT 'TODO',
        priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
        assigned_to VARCHAR(191),
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_project (project_id),
        INDEX idx_task_code (project_id, task_code),
        INDEX idx_status (status),
        INDEX idx_assigned_to (assigned_to),
        INDEX idx_parent_task (parent_task_id),
        FOREIGN KEY (project_id) REFERENCES project_projects(id) ON DELETE CASCADE,
        FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
        UNIQUE KEY unique_project_task_code (project_id, task_code)
      )`,

      // PROJECT_NOTIFICATIONS - การแจ้งเตือน
      `CREATE TABLE IF NOT EXISTS project_notifications (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        project_id VARCHAR(191),
        task_id VARCHAR(191),
        type ENUM('TASK_ASSIGNED', 'TASK_COMPLETED', 'DEADLINE_APPROACHING', 'STATUS_CHANGED', 'GENERAL') NOT NULL,
        title VARCHAR(255) NOT NULL,
        message TEXT NOT NULL,
        recipient_id VARCHAR(191) NOT NULL,
        is_read BOOLEAN DEFAULT FALSE,
        read_at DATETIME(3),
        created_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        INDEX idx_project (project_id),
        INDEX idx_task (task_id),
        INDEX idx_recipient (recipient_id, is_read),
        INDEX idx_type (type),
        FOREIGN KEY (project_id) REFERENCES project_projects(id) ON DELETE CASCADE,
        FOREIGN KEY (task_id) REFERENCES project_tasks(id) ON DELETE CASCADE,
        FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้างตาราง Settings Module
  private async createSettingsTables(connection: mysql.Connection) {
    const tables = [
      // SETTINGS_SYSTEM_CONFIG - การตั้งค่าระบบ
      `CREATE TABLE IF NOT EXISTS settings_system_config (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        config_key VARCHAR(100) NOT NULL UNIQUE,
        config_value TEXT,
        data_type ENUM('STRING', 'INTEGER', 'DECIMAL', 'BOOLEAN', 'JSON') DEFAULT 'STRING',
        category VARCHAR(100),
        description TEXT,
        is_editable BOOLEAN DEFAULT TRUE,
        created_by VARCHAR(191),
        updated_by VARCHAR(191),
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_config_key (config_key),
        INDEX idx_category (category)
      )`,

      // SETTINGS_USER_PREFERENCES - การตั้งค่าผู้ใช้
      `CREATE TABLE IF NOT EXISTS settings_user_preferences (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        user_id VARCHAR(191) NOT NULL,
        preference_key VARCHAR(100) NOT NULL,
        preference_value TEXT,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_user_preference (user_id, preference_key),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE KEY unique_user_preference (user_id, preference_key)
      )`,

      // SETTINGS_NOTIFICATIONS - การตั้งค่าการแจ้งเตือน
      `CREATE TABLE IF NOT EXISTS settings_notifications (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        user_id VARCHAR(191) NOT NULL,
        notification_type VARCHAR(100) NOT NULL,
        email_enabled BOOLEAN DEFAULT TRUE,
        sms_enabled BOOLEAN DEFAULT FALSE,
        push_enabled BOOLEAN DEFAULT TRUE,
        frequency ENUM('IMMEDIATE', 'DAILY', 'WEEKLY', 'NEVER') DEFAULT 'IMMEDIATE',
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_user_notification (user_id, notification_type),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE KEY unique_user_notification_type (user_id, notification_type)
      )`
    ]

    for (const sql of tables) {
      await connection.query(sql)
    }
  }

  // สร้าง Super Admin User เริ่มต้นสำหรับองค์กร
  async createInitialAdminUser(schemaName: string, adminData: {
    email: string
    name: string
    orgCode: string
    password?: string
  }): Promise<{ email: string, password: string }> {
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      const userId = uuidv4()
      const defaultPassword = adminData.password || '123456'
      const hashedPassword = await bcrypt.hash(defaultPassword, 10)
      
      // สร้างอีเมลในรูปแบบ admin_รหัสองค์กร
      const adminEmail = `admin_${adminData.orgCode}`
      const adminName = 'Super Admin'

      // สร้าง Super Admin User
      await connection.query(`
        INSERT INTO users (id, email, name, password, role, is_active, created_at, updated_at)
        VALUES (?, ?, ?, ?, 'SUPER_ADMIN', TRUE, NOW(), NOW())
      `, [userId, adminEmail, adminName, hashedPassword])

      // เพิ่มสิทธิ์ทุกสิทธิ์ให้กับ Super Admin
      await this.grantAllPermissions(connection, userId)

      console.log(`✅ Created Super Admin user for schema: ${schemaName}`)
      console.log(`📧 Super Admin Email: ${adminEmail}`)
      console.log(`🔑 Super Admin Password: ${defaultPassword}`)
      
      return {
        email: adminEmail,
        password: defaultPassword
      }
      
    } catch (error) {
      console.error(`❌ Error creating Super Admin user for ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }

  // เพิ่มสิทธิ์ทุกสิทธิ์ให้กับ Super Admin
  private async grantAllPermissions(connection: mysql.Connection, userId: string): Promise<void> {
    const allPermissions = [
      // HRM Module
      { module: 'HRM', submodule: 'employees', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'HRM', submodule: 'payroll', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'HRM', submodule: 'attendance', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'HRM', submodule: 'leave', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'HRM', submodule: 'performance', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // Accounting Module
      { module: 'Accounting', submodule: 'accounts', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Accounting', submodule: 'journal', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Accounting', submodule: 'reports', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Accounting', submodule: 'budget', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Accounting', submodule: 'assets', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // Sales Module
      { module: 'Sales', submodule: 'customers', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Sales', submodule: 'orders', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Sales', submodule: 'invoices', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Sales', submodule: 'quotes', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Sales', submodule: 'reports', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // Inventory Module
      { module: 'Inventory', submodule: 'products', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Inventory', submodule: 'stock', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Inventory', submodule: 'warehouse', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Inventory', submodule: 'categories', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Inventory', submodule: 'adjustments', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // Purchasing Module
      { module: 'Purchasing', submodule: 'suppliers', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Purchasing', submodule: 'purchase_orders', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Purchasing', submodule: 'receipts', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Purchasing', submodule: 'payments', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Purchasing', submodule: 'reports', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // CRM Module
      { module: 'CRM', submodule: 'leads', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'CRM', submodule: 'contacts', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'CRM', submodule: 'opportunities', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'CRM', submodule: 'campaigns', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'CRM', submodule: 'reports', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // Project Module
      { module: 'Project', submodule: 'projects', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Project', submodule: 'tasks', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Project', submodule: 'time_tracking', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Project', submodule: 'resources', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Project', submodule: 'reports', permissions: ['view', 'create', 'edit', 'delete'] },
      
      // Settings Module
      { module: 'Settings', submodule: 'users', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Settings', submodule: 'roles', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Settings', submodule: 'permissions', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Settings', submodule: 'system', permissions: ['view', 'create', 'edit', 'delete'] },
      { module: 'Settings', submodule: 'backup', permissions: ['view', 'create', 'edit', 'delete'] }
    ]

    const permissionQueries = []
    for (const modulePerms of allPermissions) {
      for (const permission of modulePerms.permissions) {
        permissionQueries.push([
          uuidv4(),
          userId,
          modulePerms.module,
          modulePerms.submodule,
          permission,
          true // has_permission
        ])
      }
    }

    if (permissionQueries.length > 0) {
      const sql = `
        INSERT INTO user_permissions (id, user_id, module, submodule, permission, has_permission)
        VALUES ${permissionQueries.map(() => '(?, ?, ?, ?, ?, ?)').join(', ')}
      `
      const flatValues = permissionQueries.flat()
      await connection.query(sql, flatValues)
      
      console.log(`✅ Granted ${permissionQueries.length} permissions to Super Admin`)
    }
  }

  // รับ Connection สำหรับ Schema ขององค์กร
  async getOrganizationConnection(schemaName: string): Promise<mysql.Connection> {
    if (this.connections.has(schemaName)) {
      return this.connections.get(schemaName)!
    }

    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    this.connections.set(schemaName, connection)
    return connection
  }

  // Get Prisma client for organization schema
  async getOrganizationClient(orgId: string): Promise<PrismaClient | null> {
    try {
      // Get organization from main database
      const org = await prisma.organization.findUnique({
        where: { id: orgId }
      })

      if (!org) {
        return null
      }

      const schemaName = `org_${org.orgCode.toLowerCase()}`
      
      // Check if client already exists
      if (this.orgClients.has(schemaName)) {
        return this.orgClients.get(schemaName)!
      }

      // Create new Prisma client for this organization schema
      const orgClient = new PrismaClient({
        datasources: {
          db: {
            url: `mysql://erp_app:erp_app_pass123@localhost:3306/${schemaName}`
          }
        }
      })

      // Test connection
      await orgClient.$connect()
      
      // Cache the client
      this.orgClients.set(schemaName, orgClient)
      
      return orgClient
    } catch (error) {
      console.error(`Error getting organization client for org ${orgId}:`, error)
      return null
    }
  }

  // Clean up organization client
  async disconnectOrganizationClient(orgId: string): Promise<void> {
    try {
      const org = await prisma.organization.findUnique({
        where: { id: orgId }
      })

      if (!org) return

      const schemaName = `org_${org.orgCode.toLowerCase()}`
      const client = this.orgClients.get(schemaName)
      
      if (client) {
        await client.$disconnect()
        this.orgClients.delete(schemaName)
      }
    } catch (error) {
      console.error(`Error disconnecting organization client for org ${orgId}:`, error)
    }
  }

  // ลบ Schema ขององค์กร (ใช้เมื่อปฏิเสธหรือลบองค์กร)
  async deleteOrganizationSchema(schemaNameOrOrgCode: string): Promise<void> {
    // ตรวจสอบว่าเป็น schema name หรือ org code
    let schemaName: string
    if (schemaNameOrOrgCode.startsWith('org_')) {
      schemaName = schemaNameOrOrgCode
    } else {
      schemaName = `org_${schemaNameOrOrgCode.toLowerCase()}`
    }
    
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123'
    })

    try {
      // ลบ database schema
      await connection.query(`DROP DATABASE IF EXISTS \`${schemaName}\``)
      
      // ลบ connection จาก Map ถ้ามี
      this.connections.delete(schemaName)
      this.orgClients.delete(schemaName)
      
      console.log(`🗑️ Deleted schema: ${schemaName}`)
      
    } catch (error) {
      console.error(`❌ Error deleting schema ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }

  // ปิด Connection ทั้งหมด
  async closeAllConnections(): Promise<void> {
    for (const [schemaName, connection] of this.connections) {
      try {
        await connection.end()
        console.log(`🔌 Closed connection for: ${schemaName}`)
      } catch (error) {
        console.error(`❌ Error closing connection for ${schemaName}:`, error)
      }
    }
    this.connections.clear()
  }

  // ดึงข้อมูล users จาก organization schema
  async getOrganizationUsers(schemaName: string): Promise<any[]> {
    if (!schemaName) return []
    
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      const [rows] = await connection.query(`
        SELECT id, email, name, role, is_active as isActive, created_at as createdAt
        FROM users
        ORDER BY created_at DESC
      `)
      
      return rows as any[]
      
    } catch (error) {
      console.error(`❌ Error fetching users from ${schemaName}:`, error)
      return []
    } finally {
      await connection.end()
    }
  }

  // สร้าง User ใหม่ใน Organization Schema
  async createOrganizationUser(schemaName: string, userData: {
    name: string
    email: string
    password: string
    role: string
    isActive: boolean
  }): Promise<string> {
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      const userId = uuidv4()
      const hashedPassword = await bcrypt.hash(userData.password, 10)

      await connection.query(`
        INSERT INTO users (id, email, name, password, role, is_active, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())
      `, [userId, userData.email, userData.name, hashedPassword, userData.role, userData.isActive])

      console.log(`✅ Created user: ${userData.email} in schema: ${schemaName}`)
      return userId
      
    } catch (error) {
      console.error(`❌ Error creating user in ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }

  // แก้ไข User ใน Organization Schema
  async updateOrganizationUser(schemaName: string, userId: string, userData: {
    name?: string
    email?: string
    password?: string
    role?: string
    isActive?: boolean
  }): Promise<void> {
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      const updates: string[] = []
      const values: any[] = []

      if (userData.name !== undefined) {
        updates.push('name = ?')
        values.push(userData.name)
      }
      if (userData.email !== undefined) {
        updates.push('email = ?')
        values.push(userData.email)
      }
      if (userData.password !== undefined) {
        const hashedPassword = await bcrypt.hash(userData.password, 10)
        updates.push('password = ?')
        values.push(hashedPassword)
      }
      if (userData.role !== undefined) {
        updates.push('role = ?')
        values.push(userData.role)
      }
      if (userData.isActive !== undefined) {
        updates.push('is_active = ?')
        values.push(userData.isActive)
      }

      if (updates.length === 0) return

      updates.push('updated_at = NOW()')
      values.push(userId)

      await connection.query(`
        UPDATE users SET ${updates.join(', ')} WHERE id = ?
      `, values)

      console.log(`✅ Updated user: ${userId} in schema: ${schemaName}`)
      
    } catch (error) {
      console.error(`❌ Error updating user in ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }

  // ลบ User จาก Organization Schema
  async deleteOrganizationUser(schemaName: string, userId: string): Promise<void> {
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      await connection.query('DELETE FROM users WHERE id = ?', [userId])
      console.log(`✅ Deleted user: ${userId} from schema: ${schemaName}`)
      
    } catch (error) {
      console.error(`❌ Error deleting user from ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }

  // สร้าง Role Templates เริ่มต้น
  async populateDefaultRolePermissions(schemaName: string): Promise<void> {
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      // Define default role permissions directly here to avoid import issues
      const DEFAULT_ROLE_PERMISSIONS = {
        ADMIN: {
          hrm: {
            employee: { read: true, create: true, update: true, delete: true, export: true, import: true },
            attendance: { read: true, create: true, update: true, delete: true, approve: true, export: true },
            payroll: { read: true, create: true, update: true, delete: true, approve: true, export: true },
            leave: { read: true, create: true, update: true, delete: true, approve: true, export: true },
            announcement: { read: true, create: true, update: true, delete: true }
          },
          accounting: {
            income: { read: true, create: true, update: true, delete: true, export: true },
            finance: { read: true, create: true, update: true, delete: true, approve: true, export: true },
            report: { read: true, export: true }
          },
          sales: {
            customer: { read: true, create: true, update: true, delete: true, export: true, import: true },
            quotation: { read: true, create: true, update: true, delete: true, approve: true, export: true },
            report: { read: true, export: true }
          },
          inventory: {
            product: { read: true, create: true, update: true, delete: true, export: true, import: true },
            stock: { read: true, create: true, update: true, delete: true, export: true },
            transaction: { read: true, create: true, update: true, delete: true, export: true }
          },
          purchasing: {
            order: { read: true, create: true, update: true, delete: true, approve: true, export: true },
            supplier: { read: true, create: true, update: true, delete: true, export: true, import: true },
            report: { read: true, export: true }
          },
          crm: {
            customer: { read: true, create: true, update: true, delete: true, export: true, import: true },
            history: { read: true, export: true },
            activity: { read: true, create: true, update: true, delete: true, export: true }
          },
          project: {
            task: { read: true, create: true, update: true, delete: true, export: true },
            status: { read: true, update: true, export: true },
            notification: { read: true, create: true, update: true, delete: true }
          },
          settings: {
            user: { read: true, create: true, update: true, delete: true, export: true },
            permission: { read: true, create: true, update: true, delete: true },
            config: { read: true, update: true },
            notification: { read: true, update: true }
          }
        },
        MANAGER: {
          hrm: {
            employee: { read: true, create: true, update: true, delete: false, export: true, import: false },
            attendance: { read: true, create: false, update: true, delete: false, approve: true, export: true },
            payroll: { read: true, create: false, update: false, delete: false, approve: true, export: true },
            leave: { read: true, create: true, update: true, delete: false, approve: true, export: true },
            announcement: { read: true, create: true, update: true, delete: false }
          },
          accounting: {
            income: { read: true, create: true, update: true, delete: false, export: true },
            finance: { read: true, create: false, update: false, delete: false, approve: true, export: true },
            report: { read: true, export: true }
          },
          sales: {
            customer: { read: true, create: true, update: true, delete: false, export: true, import: false },
            quotation: { read: true, create: true, update: true, delete: false, approve: true, export: true },
            report: { read: true, export: true }
          },
          inventory: {
            product: { read: true, create: true, update: true, delete: false, export: true, import: false },
            stock: { read: true, create: true, update: true, delete: false, export: true },
            transaction: { read: true, create: true, update: true, delete: false, export: true }
          },
          purchasing: {
            order: { read: true, create: true, update: true, delete: false, approve: true, export: true },
            supplier: { read: true, create: true, update: true, delete: false, export: true, import: false },
            report: { read: true, export: true }
          },
          crm: {
            customer: { read: true, create: true, update: true, delete: false, export: true, import: false },
            history: { read: true, export: false },
            activity: { read: true, create: true, update: true, delete: false, export: true }
          },
          project: {
            task: { read: true, create: true, update: true, delete: false, export: true },
            status: { read: true, update: true, export: true },
            notification: { read: true, create: true, update: true, delete: false }
          },
          settings: {
            user: { read: true, create: false, update: false, delete: false, export: false },
            permission: { read: true, create: false, update: false, delete: false },
            config: { read: true, update: false },
            notification: { read: true, update: true }
          }
        },
        USER: {
          hrm: {
            employee: { read: true, create: false, update: false, delete: false, export: false, import: false },
            attendance: { read: true, create: true, update: true, delete: false, approve: false, export: false },
            payroll: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            leave: { read: true, create: true, update: true, delete: true, approve: false, export: false },
            announcement: { read: true, create: false, update: false, delete: false }
          },
          accounting: {
            income: { read: false, create: false, update: false, delete: false, export: false },
            finance: { read: false, create: false, update: false, delete: false, approve: false, export: false },
            report: { read: false, export: false }
          },
          sales: {
            customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
            quotation: { read: true, create: true, update: true, delete: false, approve: false, export: false },
            report: { read: true, export: false }
          },
          inventory: {
            product: { read: true, create: false, update: false, delete: false, export: false, import: false },
            stock: { read: true, create: false, update: false, delete: false, export: false },
            transaction: { read: true, create: true, update: false, delete: false, export: false }
          },
          purchasing: {
            order: { read: true, create: true, update: true, delete: false, approve: false, export: false },
            supplier: { read: true, create: false, update: false, delete: false, export: false, import: false },
            report: { read: true, export: false }
          },
          crm: {
            customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
            history: { read: true, export: false },
            activity: { read: true, create: true, update: true, delete: false, export: false }
          },
          project: {
            task: { read: true, create: true, update: true, delete: false, export: false },
            status: { read: true, update: false, export: false },
            notification: { read: true, create: false, update: false, delete: false }
          },
          settings: {
            user: { read: false, create: false, update: false, delete: false, export: false },
            permission: { read: false, create: false, update: false, delete: false },
            config: { read: false, update: false },
            notification: { read: true, update: true }
          }
        },
        VIEWER: {
          hrm: {
            employee: { read: true, create: false, update: false, delete: false, export: false, import: false },
            attendance: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            payroll: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            leave: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            announcement: { read: true, create: false, update: false, delete: false }
          },
          accounting: {
            income: { read: true, create: false, update: false, delete: false, export: false },
            finance: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            report: { read: true, export: false }
          },
          sales: {
            customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
            quotation: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            report: { read: true, export: false }
          },
          inventory: {
            product: { read: true, create: false, update: false, delete: false, export: false, import: false },
            stock: { read: true, create: false, update: false, delete: false, export: false },
            transaction: { read: true, create: false, update: false, delete: false, export: false }
          },
          purchasing: {
            order: { read: true, create: false, update: false, delete: false, approve: false, export: false },
            supplier: { read: true, create: false, update: false, delete: false, export: false, import: false },
            report: { read: true, export: false }
          },
          crm: {
            customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
            history: { read: true, export: false },
            activity: { read: true, create: false, update: false, delete: false, export: false }
          },
          project: {
            task: { read: true, create: false, update: false, delete: false, export: false },
            status: { read: true, update: false, export: false },
            notification: { read: true, create: false, update: false, delete: false }
          },
          settings: {
            user: { read: false, create: false, update: false, delete: false, export: false },
            permission: { read: false, create: false, update: false, delete: false },
            config: { read: false, update: false },
            notification: { read: true, update: false }
          }
        }
      }
      
      // Clear existing role templates
      await connection.query('DELETE FROM role_templates')

      const rolePermissionRecords = []

      // Create records for each role and their permissions
      for (const [roleName, rolePermissions] of Object.entries(DEFAULT_ROLE_PERMISSIONS)) {
        for (const [module, modulePermissions] of Object.entries(rolePermissions as any)) {
          for (const [submodule, submodulePermissions] of Object.entries(modulePermissions as any)) {
            for (const [permission, granted] of Object.entries(submodulePermissions as any)) {
              rolePermissionRecords.push([
                roleName,
                module,
                submodule,
                permission,
                granted
              ])
            }
          }
        }
      }

      // Insert role permissions in batches
      if (rolePermissionRecords.length > 0) {
        await connection.query(`
          INSERT INTO role_templates (role, module, submodule, permission, granted)
          VALUES ?
        `, [rolePermissionRecords])
      }

      console.log(`✅ Populated role templates for schema: ${schemaName}`)
    } catch (error) {
      console.error(`❌ Error populating role templates for ${schemaName}:`, error)
      throw error
    } finally {
      await connection.end()
    }
  }
}
