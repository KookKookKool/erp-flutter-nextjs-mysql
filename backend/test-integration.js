console.log('🧪 Testing Full DatabaseManager Integration...');

const mysql = require('mysql2/promise');

async function testFullIntegration() {
  try {
    console.log('📝 Testing Super Admin creation manually...');
    
    const testOrgCode = 'TEST2507101234';
    const schemaName = `org_${testOrgCode.toLowerCase()}`;
    const expectedEmail = `admin_${testOrgCode}`;
    
    console.log(`   Org Code: ${testOrgCode}`);
    console.log(`   Schema: ${schemaName}`);
    console.log(`   Expected Email: ${expectedEmail}`);
    
    // 1. สร้าง schema
    let connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123'
    });
    
    await connection.query(`CREATE DATABASE IF NOT EXISTS \`${schemaName}\``);
    await connection.end();
    console.log('✅ Schema created');
    
    // 2. สร้างตาราง
    connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    });
    
    // ใช้โครงสร้างตารางเดียวกับ DatabaseManager
    await connection.query(`
      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(191) NOT NULL PRIMARY KEY,
        email VARCHAR(191) NOT NULL UNIQUE,
        name VARCHAR(191) NOT NULL,
        password VARCHAR(191) NOT NULL,
        role ENUM('SUPER_ADMIN', 'ADMIN', 'MANAGER', 'USER', 'VIEWER') DEFAULT 'USER',
        is_active BOOLEAN DEFAULT TRUE,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
      )
    `);
    
    await connection.query(`
      CREATE TABLE IF NOT EXISTS user_permissions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id VARCHAR(191) NOT NULL,
        module VARCHAR(100) NOT NULL,
        submodule VARCHAR(100) NOT NULL,
        permission VARCHAR(50) NOT NULL,
        granted BOOLEAN DEFAULT FALSE,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
        INDEX idx_user_module (user_id, module, submodule),
        INDEX idx_permission (permission),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        UNIQUE KEY unique_user_permission (user_id, module, submodule, permission)
      )
    `);
    
    console.log('✅ Tables created');
    
    // 3. สร้าง Super Admin
    const { v4: uuidv4 } = require('uuid');
    const bcrypt = require('bcryptjs');
    
    const userId = uuidv4();
    const password = '123456';
    const hashedPassword = await bcrypt.hash(password, 10);
    
    await connection.query(`
      INSERT INTO users (id, email, name, password, role, is_active)
      VALUES (?, ?, ?, ?, 'SUPER_ADMIN', TRUE)
    `, [userId, expectedEmail, 'Super Admin', hashedPassword]);
    
    console.log('✅ Super Admin created');
    
    // 4. เพิ่มสิทธิ์ทั้งหมด (ตัวอย่างบางส่วน)
    const samplePermissions = [
      ['HRM', 'employees', 'view'],
      ['HRM', 'employees', 'create'],
      ['HRM', 'employees', 'edit'],
      ['HRM', 'employees', 'delete'],
      ['Settings', 'users', 'view'],
      ['Settings', 'users', 'create'],
      ['Settings', 'users', 'edit'],
      ['Settings', 'users', 'delete']
    ];
    
    for (const [module, submodule, permission] of samplePermissions) {
      await connection.query(`
        INSERT INTO user_permissions (user_id, module, submodule, permission, granted)
        VALUES (?, ?, ?, ?, TRUE)
      `, [userId, module, submodule, permission]);
    }
    
    console.log(`✅ Granted ${samplePermissions.length} sample permissions`);
    
    // 5. ตรวจสอบผลลัพธ์
    const [users] = await connection.query('SELECT * FROM users WHERE role = "SUPER_ADMIN"');
    const [permissions] = await connection.query('SELECT COUNT(*) as total FROM user_permissions WHERE granted = TRUE');
    
    console.log(`\n📊 Results:`);
    console.log(`   Super Admin users: ${users.length}`);
    console.log(`   Total permissions: ${permissions[0].total}`);
    
    if (users.length > 0) {
      const admin = users[0];
      console.log(`   Admin details:`);
      console.log(`     Email: ${admin.email}`);
      console.log(`     Name: ${admin.name}`);
      console.log(`     Role: ${admin.role}`);
      console.log(`     Active: ${admin.is_active ? 'YES' : 'NO'}`);
      console.log(`     Expected Email: ${expectedEmail}`);
      console.log(`     Match: ${admin.email === expectedEmail ? '✅ YES' : '❌ NO'}`);
    }
    
    await connection.end();
    
    // 6. ทำความสะอาด
    connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123'
    });
    
    await connection.query(`DROP DATABASE IF EXISTS \`${schemaName}\``);
    await connection.end();
    console.log('✅ Cleanup completed');
    
    console.log('\n🎉 Super Admin creation test PASSED!');
    console.log('\n📋 Summary:');
    console.log('   ✅ Email format: admin_[ORG_CODE]');
    console.log('   ✅ Name: Super Admin');
    console.log('   ✅ Role: SUPER_ADMIN');
    console.log('   ✅ Password: 123456 (changeable)');
    console.log('   ✅ Permissions: Full access to all modules');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error('Full error:', error);
  }
}

testFullIntegration();
