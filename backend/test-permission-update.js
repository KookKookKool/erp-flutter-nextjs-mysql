const mysql = require('mysql2/promise')
require('dotenv').config()

async function testPermissionUpdate() {
  // Parse DATABASE_URL
  const dbUrl = process.env.DATABASE_URL
  if (!dbUrl) {
    throw new Error('DATABASE_URL not found in environment')
  }
  
  const urlParts = dbUrl.match(/mysql:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)
  if (!urlParts) {
    throw new Error('Invalid DATABASE_URL format')
  }
  
  const [, user, password, host, port, database] = urlParts
  
  console.log('🧪 Testing Permission Update with UUID IDs...')
  
  const connection = await mysql.createConnection({
    host,
    user,
    password,
    port: parseInt(port),
    multipleStatements: true
  })

  let testSchema = null

  try {
    // Create test schema
    const testOrgCode = 'PERMTEST' + Date.now().toString().slice(-6)
    testSchema = `org_${testOrgCode.toLowerCase()}`
    
    console.log(`📋 Creating test schema: ${testSchema}`)
    
    await connection.query(`CREATE DATABASE \`${testSchema}\``)
    await connection.query(`USE \`${testSchema}\``)
    
    // Create tables
    await connection.query(`
      CREATE TABLE users (
        id VARCHAR(36) NOT NULL PRIMARY KEY,
        email VARCHAR(191) NOT NULL UNIQUE,
        name VARCHAR(191) NOT NULL,
        role ENUM('SUPER_ADMIN', 'ADMIN', 'MANAGER', 'USER') DEFAULT 'USER',
        password_hash VARCHAR(255) NOT NULL,
        is_active BOOLEAN DEFAULT TRUE,
        created_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
        updated_at DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
      )
    `)
    
    await connection.query(`
      CREATE TABLE user_permissions (
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
      )
    `)
    
    // Create test user
    const testUserId = '12345678-1234-1234-1234-123456789012'
    await connection.query(`
      INSERT INTO users (id, email, name, role, password_hash)
      VALUES (?, 'test@example.com', 'Test User', 'USER', 'hash123')
    `, [testUserId])
    
    console.log('✅ Created test user')
    
    // Test permission insert with proper UUIDs and all required fields
    const { v4: uuidv4 } = require('uuid')
    
    const permissionRecords = [
      {
        id: uuidv4(),
        user_id: testUserId,
        module: 'hrm',
        submodule: 'employee',
        permission: 'read',
        has_permission: true
      },
      {
        id: uuidv4(),
        user_id: testUserId,
        module: 'hrm',
        submodule: 'employee',
        permission: 'create',
        has_permission: true
      },
      {
        id: uuidv4(),
        user_id: testUserId,
        module: 'hrm',
        submodule: 'employee',
        permission: 'update',
        has_permission: false
      }
    ]
    
    // Delete existing permissions
    await connection.query('DELETE FROM user_permissions WHERE user_id = ?', [testUserId])
    
    // Insert new permissions with all required fields including UUIDs
    const values = permissionRecords.map(record => [
      record.id,
      record.user_id,
      record.module,
      record.submodule,
      record.permission,
      record.has_permission
    ])

    await connection.query(`
      INSERT INTO user_permissions (id, user_id, module, submodule, permission, has_permission)
      VALUES ?
    `, [values])
    
    console.log('✅ Inserted permissions with UUID IDs successfully')
    
    // Verify the data
    const [results] = await connection.query(`
      SELECT id, user_id, module, submodule, permission, has_permission
      FROM user_permissions 
      WHERE user_id = ?
      ORDER BY permission
    `, [testUserId])
    
    console.log('📊 Verification results:')
    results.forEach((perm, index) => {
      console.log(`   ${index + 1}. ${perm.module}.${perm.submodule}.${perm.permission} = ${perm.has_permission ? 'TRUE' : 'FALSE'}`)
      console.log(`      ID: ${perm.id}`)
    })
    
    if (results.length === 3) {
      console.log('🎉 Permission update test PASSED!')
    } else {
      console.log(`❌ Expected 3 permissions, got ${results.length}`)
    }
    
  } catch (error) {
    console.error('❌ Test failed:', error)
  } finally {
    // Cleanup
    if (testSchema) {
      try {
        await connection.query(`DROP DATABASE IF EXISTS \`${testSchema}\``)
        console.log('✅ Cleanup completed')
      } catch (cleanupError) {
        console.error('⚠️  Cleanup error:', cleanupError.message)
      }
    }
    await connection.end()
  }
}

testPermissionUpdate()
