import { NextRequest, NextResponse } from 'next/server'
import mysql from 'mysql2/promise'
import prisma from '../../../../../../../../../lib/prisma'

// Check if user has permission for specific module and action
export async function POST(
  request: NextRequest,
  { params }: { params: { id: string; userId: string } }
) {
  try {
    const orgId = params.id
    const userId = params.userId
    const { module, submodule, permission } = await request.json()

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
      // Check user permission
      const [permissionRows] = await connection.query(`
        SELECT has_permission FROM user_permissions 
        WHERE user_id = ? AND module = ? AND submodule = ? AND permission = ?
      `, [userId, module, submodule, permission]) as any[]

      const hasPermission = permissionRows.length > 0 && permissionRows[0].has_permission

      // If no specific permission found, check role-based permissions
      if (!hasPermission) {
        const [userRows] = await connection.query(`
          SELECT role FROM users WHERE id = ?
        `, [userId]) as any[]

        if (userRows.length > 0) {
          const userRole = userRows[0].role
          
          const [rolePermissionRows] = await connection.query(`
            SELECT granted FROM role_templates 
            WHERE role = ? AND module = ? AND submodule = ? AND permission = ?
          `, [userRole, module, submodule, permission]) as any[]

          const hasRolePermission = rolePermissionRows.length > 0 && rolePermissionRows[0].granted

          return NextResponse.json({
            hasPermission: hasRolePermission,
            source: 'role'
          })
        }
      }

      return NextResponse.json({
        hasPermission,
        source: hasPermission ? 'user' : 'none'
      })
    } finally {
      await connection.end()
    }
  } catch (error) {
    console.error('Error checking permission:', error)
    return NextResponse.json(
      { error: 'Failed to check permission' },
      { status: 500 }
    )
  }
}
