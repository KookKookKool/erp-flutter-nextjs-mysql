import { NextRequest, NextResponse } from 'next/server'
import { DatabaseManager } from '@/lib/database-manager'
import { AuthService } from '@/lib/auth'
import prisma from '@/lib/prisma'

// Helper function to verify token and get organization
async function verifyTokenAndGetOrg(request: NextRequest) {
  try {
    const authHeader = request.headers.get('authorization')
    const orgCode = request.headers.get('x-org-code')
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return { error: 'No authorization token provided', status: 401 }
    }

    if (!orgCode) {
      return { error: 'Organization code is required', status: 400 }
    }

    const token = authHeader.substring(7)
    const payload = AuthService.verifyToken(token)
    
    if (!payload) {
      return { error: 'Invalid token', status: 401 }
    }

    const organization = await prisma.organization.findUnique({
      where: { orgCode: orgCode.toUpperCase() }
    })

    if (!organization) {
      return { error: 'Organization not found', status: 404 }
    }

    // Get database connection
    const dbManager = DatabaseManager.getInstance()
    const schemaName = `org_${organization.orgCode.toLowerCase()}`
    const connection = await dbManager.getOrganizationConnection(schemaName)

    return { organization, payload, connection }
  } catch (error) {
    return { error: 'Authentication error', status: 500 }
  }
}

// GET - Fetch employees
export async function GET(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { organization, connection } = auth
    const { searchParams } = new URL(request.url)
    const search = searchParams.get('search')
    const department = searchParams.get('department')
    const isActive = searchParams.get('isActive')

    // Check what columns exist in users table first
    const [tableColumns] = await connection.execute(`SHOW COLUMNS FROM users`)
    const columnNames = (tableColumns as any[]).map(col => col.Field)

    // Build query conditions
    let whereConditions = ['u.is_active = 1']
    const queryParams: any[] = []

    if (search) {
      const searchConditions = ['u.email LIKE ?', 'u.name LIKE ?']
      if (columnNames.includes('employee_id')) {
        searchConditions.push('u.employee_id LIKE ?')
        queryParams.push(`%${search}%`, `%${search}%`, `%${search}%`)
      } else {
        queryParams.push(`%${search}%`, `%${search}%`)
      }
      whereConditions.push(`(${searchConditions.join(' OR ')})`)
    }

    if (department) {
      if (columnNames.includes('department')) {
        whereConditions.push('(e.department_id = ? OR u.department = ?)')
        queryParams.push(department, department)
      } else {
        whereConditions.push('e.department_id = ?')
        queryParams.push(department)
      }
    }

    if (isActive !== null) {
      const activeValue = isActive === 'true' ? 1 : 0
      whereConditions.push('u.is_active = ?')
      queryParams.push(activeValue)
    }

    // Query to get users and their employee data
    const employeesQuery = `
      SELECT 
        u.id,
        ${columnNames.includes('employee_id') ? 'u.employee_id,' : ''}
        u.name,
        ${columnNames.includes('first_name') ? 'u.first_name,' : ''}
        ${columnNames.includes('last_name') ? 'u.last_name,' : ''}
        u.email,
        ${columnNames.includes('phone') ? 'u.phone,' : ''}
        ${columnNames.includes('position') ? 'u.position,' : ''}
        ${columnNames.includes('department') ? 'u.department,' : ''}
        ${columnNames.includes('level') ? 'u.level,' : ''}
        ${columnNames.includes('start_date') ? 'u.start_date,' : ''}
        u.is_active,
        ${columnNames.includes('profile_image') ? 'u.profile_image,' : ''}
        u.created_at,
        u.updated_at,
        e.employee_code,
        e.first_name as emp_first_name,
        e.last_name as emp_last_name,
        e.position as emp_position,
        e.department_id as emp_department,
        e.hire_date as emp_hire_date,
        e.phone as emp_phone,
        e.status as emp_status
      FROM users u
      LEFT JOIN hrm_employees e ON (u.id = e.user_id ${columnNames.includes('employee_id') ? 'OR u.employee_id = e.employee_code' : ''})
      WHERE ${whereConditions.join(' AND ')}
      ORDER BY u.created_at DESC
    `

    const [results] = await connection.execute(employeesQuery, queryParams)
    const employees = (results as any[]).map((row: any) => ({
      id: row.id,
      employee_id: row.employee_id || row.employee_code || row.email,
      first_name: row.emp_first_name || row.first_name || row.name?.split(' ')[0] || '',
      last_name: row.emp_last_name || row.last_name || row.name?.split(' ').slice(1).join(' ') || '',
      email: row.email,
      phone: row.emp_phone || row.phone || '',
      position: row.emp_position || row.position || '',
      department: row.emp_department || row.department || '',
      level: row.level || 'Employee',
      start_date: row.emp_hire_date || row.start_date || row.created_at,
      is_active: row.is_active,
      profile_image: row.profile_image || null,
      created_at: row.created_at,
      updated_at: row.updated_at
    }))

    return NextResponse.json({
      status: 'success',
      employees
    })

  } catch (error) {
    console.error('Fetch employees error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch employees' },
      { status: 500 }
    )
  }
}

// POST - Create employee
export async function POST(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { organization, connection } = auth
    const body = await request.json()
    const { 
      employee_id, 
      first_name, 
      last_name, 
      email, 
      phone, 
      position, 
      department, 
      level,
      password 
    } = body

    // Validate required fields
    if (!employee_id || !first_name || !email || !password) {
      return NextResponse.json(
        { error: 'Required fields missing' },
        { status: 400 }
      )
    }

    // Check if users table has employee_id column, if not, check by email only
    let checkQuery = `SELECT id FROM users WHERE email = ?`
    let checkParams = [email]
    
    try {
      // Try to check if employee_id column exists
      const [columns] = await connection.execute(`SHOW COLUMNS FROM users LIKE 'employee_id'`)
      if (Array.isArray(columns) && columns.length > 0) {
        // Column exists, check both email and employee_id
        checkQuery = `SELECT id FROM users WHERE email = ? OR employee_id = ? LIMIT 1`
        checkParams = [email, employee_id]
      }
    } catch (error) {
      // Column doesn't exist, use email only check
      console.log('employee_id column not found, checking email only')
    }

    const [existingResults] = await connection.execute(checkQuery, checkParams)
    
    if (Array.isArray(existingResults) && existingResults.length > 0) {
      return NextResponse.json(
        { error: 'Employee with this email or employee ID already exists' },
        { status: 409 }
      )
    }

    // Hash password
    const hashedPassword = await AuthService.hashPassword(password)

    // Generate UUID for new user
    const userId = require('crypto').randomUUID()

    // Check what columns exist in users table and build INSERT query accordingly
    const [tableColumns] = await connection.execute(`SHOW COLUMNS FROM users`)
    const columnNames = (tableColumns as any[]).map(col => col.Field)
    
    let insertColumns = ['id', 'email', 'name', 'password', 'is_active']
    let insertValues = [userId, email, `${first_name} ${last_name}`, hashedPassword, 1]
    let placeholders = ['?', '?', '?', '?', '?']

    // Add optional columns if they exist
    if (columnNames.includes('employee_id')) {
      insertColumns.push('employee_id')
      insertValues.push(employee_id)
      placeholders.push('?')
    }
    if (columnNames.includes('first_name')) {
      insertColumns.push('first_name')
      insertValues.push(first_name)
      placeholders.push('?')
    }
    if (columnNames.includes('last_name')) {
      insertColumns.push('last_name')
      insertValues.push(last_name)
      placeholders.push('?')
    }
    if (columnNames.includes('phone')) {
      insertColumns.push('phone')
      insertValues.push(phone || '')
      placeholders.push('?')
    }
    if (columnNames.includes('position')) {
      insertColumns.push('position')
      insertValues.push(position || '')
      placeholders.push('?')
    }
    if (columnNames.includes('department')) {
      insertColumns.push('department')
      insertValues.push(department || '')
      placeholders.push('?')
    }
    if (columnNames.includes('level')) {
      insertColumns.push('level')
      insertValues.push(level || 'Employee')
      placeholders.push('?')
    }
    if (columnNames.includes('start_date')) {
      insertColumns.push('start_date')
      insertValues.push(new Date().toISOString().split('T')[0])
      placeholders.push('?')
    }

    // Add timestamps
    insertColumns.push('created_at', 'updated_at')
    placeholders.push('NOW()', 'NOW()')

    // Create user in users table
    const createUserQuery = `
      INSERT INTO users (${insertColumns.join(', ')}) 
      VALUES (${placeholders.join(', ')})
    `
    
    await connection.execute(createUserQuery, insertValues)

    // Try to create corresponding record in hrm_employees table if it exists
    try {
      const createEmployeeQuery = `
        INSERT INTO hrm_employees (
          id, employee_code, user_id, first_name, last_name, 
          email, phone, position, hire_date, status, 
          created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), 'ACTIVE', NOW(), NOW())
      `
      
      const empId = require('crypto').randomUUID()
      await connection.execute(createEmployeeQuery, [
        empId,
        employee_id,
        userId,
        first_name,
        last_name,
        email,
        phone || '',
        position || ''
      ])
    } catch (error) {
      // hrm_employees table might not exist, continue
      console.log('hrm_employees table not found, created user only')
    }

    const employee = {
      id: userId,
      employee_id,
      first_name,
      last_name,
      email,
      phone: phone || '',
      position: position || '',
      department: department || '',
      level: level || 'Employee',
      start_date: new Date(),
      is_active: true,
      profile_image: null,
      created_at: new Date(),
      updated_at: new Date()
    }

    return NextResponse.json({
      status: 'success',
      employee
    })

  } catch (error) {
    console.error('Create employee error:', error)
    return NextResponse.json(
      { error: 'Failed to create employee' },
      { status: 500 }
    )
  }
}

// PUT - Update employee
export async function PUT(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { connection } = auth
    const { searchParams } = new URL(request.url)
    const employeeId = searchParams.get('id')
    const body = await request.json()

    if (!employeeId) {
      return NextResponse.json(
        { error: 'Employee ID is required' },
        { status: 400 }
      )
    }

    const { 
      first_name, 
      last_name, 
      phone, 
      position, 
      department, 
      level,
      password
    } = body

    // Check what columns exist in users table
    const [tableColumns] = await connection.execute(`SHOW COLUMNS FROM users`)
    const columnNames = (tableColumns as any[]).map(col => col.Field)

    // Build update query based on available columns
    let updateFields = ['name = ?', 'updated_at = NOW()']
    const updateParams = [`${first_name} ${last_name}`]

    if (columnNames.includes('first_name')) {
      updateFields.push('first_name = ?')
      updateParams.push(first_name)
    }
    if (columnNames.includes('last_name')) {
      updateFields.push('last_name = ?')
      updateParams.push(last_name)
    }
    if (columnNames.includes('phone')) {
      updateFields.push('phone = ?')
      updateParams.push(phone || '')
    }
    if (columnNames.includes('position')) {
      updateFields.push('position = ?')
      updateParams.push(position || '')
    }
    if (columnNames.includes('department')) {
      updateFields.push('department = ?')
      updateParams.push(department || '')
    }
    if (columnNames.includes('level')) {
      updateFields.push('level = ?')
      updateParams.push(level || 'Employee')
    }

    if (password) {
      const hashedPassword = await AuthService.hashPassword(password)
      updateFields.push('password = ?')
      updateParams.push(hashedPassword)
    }

    // Build WHERE clause based on available columns
    let whereClause = 'WHERE id = ?'
    updateParams.push(employeeId)
    
    if (columnNames.includes('employee_id')) {
      whereClause = 'WHERE id = ? OR employee_id = ?'
      updateParams.push(employeeId)
    }

    const updateUserQuery = `
      UPDATE users 
      SET ${updateFields.join(', ')}
      ${whereClause}
    `

    await connection.execute(updateUserQuery, updateParams)

    // Update hrm_employees table if it exists
    try {
      let empWhereClause = 'WHERE user_id = ?'
      let empWhereParams = [employeeId]
      
      if (columnNames.includes('employee_id')) {
        empWhereClause = 'WHERE user_id = ? OR employee_code = ?'
        empWhereParams = [employeeId, employeeId]
      }
      
      const updateEmpQuery = `
        UPDATE hrm_employees 
        SET first_name = ?, last_name = ?, phone = ?, 
            position = ?, updated_at = NOW()
        ${empWhereClause}
      `
      
      await connection.execute(updateEmpQuery, [
        first_name,
        last_name,
        phone || '',
        position || '',
        ...empWhereParams
      ])
    } catch (error) {
      // hrm_employees table might not exist
      console.log('hrm_employees table not found, updated user only')
    }

    return NextResponse.json({
      status: 'success',
      message: 'Employee updated successfully'
    })

  } catch (error) {
    console.error('Update employee error:', error)
    return NextResponse.json(
      { error: 'Failed to update employee' },
      { status: 500 }
    )
  }
}

// DELETE - Delete employee
export async function DELETE(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { connection } = auth
    const { searchParams } = new URL(request.url)
    const employeeId = searchParams.get('id')

    if (!employeeId) {
      return NextResponse.json(
        { error: 'Employee ID is required' },
        { status: 400 }
      )
    }

    // Check what columns exist in users table
    const [tableColumns] = await connection.execute(`SHOW COLUMNS FROM users`)
    const columnNames = (tableColumns as any[]).map(col => col.Field)

    // Check if employee exists and is not Super Admin
    let checkQuery = `SELECT id, level FROM users WHERE id = ? LIMIT 1`
    let checkParams = [employeeId]
    
    if (columnNames.includes('employee_id')) {
      checkQuery = `SELECT id, level FROM users WHERE id = ? OR employee_id = ? LIMIT 1`
      checkParams = [employeeId, employeeId]
    }
    
    const [checkResults] = await connection.execute(checkQuery, checkParams)
    
    if (!Array.isArray(checkResults) || checkResults.length === 0) {
      return NextResponse.json(
        { error: 'Employee not found' },
        { status: 404 }
      )
    }

    const employee = checkResults[0] as any
    if (employee.level === 'SuperAdmin') {
      return NextResponse.json(
        { error: 'Cannot delete Super Admin' },
        { status: 403 }
      )
    }

    // Delete from hrm_employees table first (if exists)
    try {
      let empDeleteQuery = `DELETE FROM hrm_employees WHERE user_id = ?`
      let empDeleteParams = [employeeId]
      
      if (columnNames.includes('employee_id')) {
        empDeleteQuery = `DELETE FROM hrm_employees WHERE user_id = ? OR employee_code = ?`
        empDeleteParams = [employeeId, employeeId]
      }
      
      await connection.execute(empDeleteQuery, empDeleteParams)
    } catch (error) {
      // hrm_employees table might not exist
      console.log('hrm_employees table not found, deleting user only')
    }

    // Delete from users table
    let deleteUserQuery = `DELETE FROM users WHERE id = ?`
    let deleteUserParams = [employeeId]
    
    if (columnNames.includes('employee_id')) {
      deleteUserQuery = `DELETE FROM users WHERE id = ? OR employee_id = ?`
      deleteUserParams = [employeeId, employeeId]
    }

    await connection.execute(deleteUserQuery, deleteUserParams)

    return NextResponse.json({
      status: 'success',
      message: 'Employee deleted successfully'
    })

  } catch (error) {
    console.error('Delete employee error:', error)
    return NextResponse.json(
      { error: 'Failed to delete employee' },
      { status: 500 }
    )
  }
}
