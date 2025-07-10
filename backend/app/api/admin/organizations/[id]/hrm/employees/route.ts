import { NextRequest, NextResponse } from 'next/server'
import mysql from 'mysql2/promise'
import prisma from '../../../../../../../lib/prisma'
import { checkPermission } from '../../../../../../../lib/permission-middleware'
import { v4 as uuidv4 } from 'uuid'

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const orgId = params.id
    const { searchParams } = new URL(request.url)
    const page = parseInt(searchParams.get('page') || '1')
    const limit = parseInt(searchParams.get('limit') || '10')
    const search = searchParams.get('search') || ''
    const status = searchParams.get('status') || ''
    const department = searchParams.get('department') || ''

    // For demo purposes, we'll skip permission check in admin endpoints
    // In production, you would extract userId from JWT token
    // const userId = 'current-user-id'
    // const hasPermission = await checkPermission(orgId, userId, 'hrm', 'employee', 'read')
    // if (!hasPermission) {
    //   return NextResponse.json({ error: 'Insufficient permissions' }, { status: 403 })
    // }

    // Get organization
    const org = await prisma.organization.findUnique({
      where: { id: orgId }
    })

    if (!org) {
      return NextResponse.json(
        { error: 'Organization not found' },
        { status: 404 }
      )
    }

    const schemaName = `org_${org.orgCode.toLowerCase()}`
    
    // Create connection to organization schema
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      const offset = (page - 1) * limit
      let whereClause = 'WHERE 1=1'
      const queryParams: any[] = []

      if (search) {
        whereClause += ' AND (first_name LIKE ? OR last_name LIKE ? OR employee_code LIKE ? OR email LIKE ?)'
        const searchPattern = `%${search}%`
        queryParams.push(searchPattern, searchPattern, searchPattern, searchPattern)
      }

      if (status) {
        whereClause += ' AND status = ?'
        queryParams.push(status)
      }

      if (department) {
        whereClause += ' AND department_id = ?'
        queryParams.push(department)
      }

      // Get employees with pagination
      const [employees] = await connection.query(`
        SELECT 
          e.*,
          d.name as department_name,
          u.email as user_email
        FROM hrm_employees e
        LEFT JOIN hrm_departments d ON e.department_id = d.id
        LEFT JOIN users u ON e.user_id = u.id
        ${whereClause}
        ORDER BY e.created_at DESC
        LIMIT ? OFFSET ?
      `, [...queryParams, limit, offset]) as any[]

      // Get total count
      const [countResult] = await connection.query(`
        SELECT COUNT(*) as total
        FROM hrm_employees e
        ${whereClause}
      `, queryParams) as any[]

      const total = countResult[0].total

      return NextResponse.json({
        employees,
        pagination: {
          current_page: page,
          per_page: limit,
          total,
          total_pages: Math.ceil(total / limit)
        }
      })
    } finally {
      await connection.end()
    }
  } catch (error) {
    console.error('Error fetching employees:', error)
    return NextResponse.json(
      { error: 'Failed to fetch employees' },
      { status: 500 }
    )
  }
}

export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const orgId = params.id
    const employeeData = await request.json()

    // Get organization
    const org = await prisma.organization.findUnique({
      where: { id: orgId }
    })

    if (!org) {
      return NextResponse.json(
        { error: 'Organization not found' },
        { status: 404 }
      )
    }

    const schemaName = `org_${org.orgCode.toLowerCase()}`
    
    // Create connection to organization schema
    const connection = await mysql.createConnection({
      host: 'localhost',
      port: 3306,
      user: 'erp_app',
      password: 'erp_app_pass123',
      database: schemaName
    })

    try {
      const employeeId = uuidv4()
      
      // Generate employee code if not provided
      let employeeCode = employeeData.employee_code
      if (!employeeCode) {
        const [lastEmployee] = await connection.query(`
          SELECT employee_code FROM hrm_employees 
          WHERE employee_code LIKE 'EMP%' 
          ORDER BY employee_code DESC 
          LIMIT 1
        `) as any[]
        
        const lastNumber = lastEmployee.length > 0 
          ? parseInt(lastEmployee[0].employee_code.replace('EMP', '')) || 0
          : 0
        employeeCode = `EMP${String(lastNumber + 1).padStart(4, '0')}`
      }

      await connection.query(`
        INSERT INTO hrm_employees (
          id, employee_code, user_id, department_id, first_name, last_name,
          position, email, phone, address, hire_date, birth_date, id_card,
          salary, status, created_by, updated_by
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        employeeId,
        employeeCode,
        employeeData.user_id || null,
        employeeData.department_id || null,
        employeeData.first_name,
        employeeData.last_name,
        employeeData.position || null,
        employeeData.email || null,
        employeeData.phone || null,
        employeeData.address || null,
        employeeData.hire_date || null,
        employeeData.birth_date || null,
        employeeData.id_card || null,
        employeeData.salary || null,
        employeeData.status || 'ACTIVE',
        employeeData.created_by || null,
        employeeData.created_by || null
      ])

      return NextResponse.json({
        message: 'Employee created successfully',
        employee: {
          id: employeeId,
          employee_code: employeeCode,
          ...employeeData
        }
      })
    } finally {
      await connection.end()
    }
  } catch (error) {
    console.error('Error creating employee:', error)
    return NextResponse.json(
      { error: 'Failed to create employee' },
      { status: 500 }
    )
  }
}
