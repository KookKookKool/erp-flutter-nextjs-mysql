import { NextRequest, NextResponse } from 'next/server'
import mysql from 'mysql2/promise'
import prisma from './prisma'

export async function checkPermission(
  orgId: string,
  userId: string,
  module: string,
  submodule: string,
  permission: string
): Promise<boolean> {
  try {
    // Get organization
    const org = await prisma.organization.findUnique({
      where: { id: orgId }
    })

    if (!org) {
      return false
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
      // Check user-specific permission first
      const [permissionRows] = await connection.query(`
        SELECT has_permission FROM user_permissions 
        WHERE user_id = ? AND module = ? AND submodule = ? AND permission = ?
      `, [userId, module, submodule, permission]) as any[]

      if (permissionRows.length > 0) {
        return permissionRows[0].has_permission
      }

      // If no specific permission found, check role-based permissions
      const [userRows] = await connection.query(`
        SELECT role FROM users WHERE id = ?
      `, [userId]) as any[]

      if (userRows.length > 0) {
        const userRole = userRows[0].role
        
        const [rolePermissionRows] = await connection.query(`
          SELECT granted FROM role_templates 
          WHERE role = ? AND module = ? AND submodule = ? AND permission = ?
        `, [userRole, module, submodule, permission]) as any[]

        if (rolePermissionRows.length > 0) {
          return rolePermissionRows[0].granted
        }
      }

      return false
    } finally {
      await connection.end()
    }
  } catch (error) {
    console.error('Error checking permission:', error)
    return false
  }
}

export function withPermission(
  module: string,
  submodule: string,
  permission: string
) {
  return function(handler: Function) {
    return async function(request: NextRequest, context: any) {
      try {
        // Extract orgId and userId from request
        const orgId = context.params?.id
        const authHeader = request.headers.get('authorization')
        
        if (!authHeader) {
          return NextResponse.json(
            { error: 'Authorization header required' },
            { status: 401 }
          )
        }

        // Here you would typically decode the JWT token to get userId
        // For now, we'll get it from a header or query param
        const userId = request.headers.get('x-user-id') || request.nextUrl.searchParams.get('userId')
        
        if (!userId) {
          return NextResponse.json(
            { error: 'User ID required' },
            { status: 401 }
          )
        }

        const hasPermission = await checkPermission(orgId, userId, module, submodule, permission)

        if (!hasPermission) {
          return NextResponse.json(
            { error: 'Insufficient permissions' },
            { status: 403 }
          )
        }

        return handler(request, context)
      } catch (error) {
        console.error('Permission middleware error:', error)
        return NextResponse.json(
          { error: 'Internal server error' },
          { status: 500 }
        )
      }
    }
  }
}

// Helper function to check multiple permissions
export async function checkMultiplePermissions(
  orgId: string,
  userId: string,
  permissions: Array<{ module: string; submodule: string; permission: string }>
): Promise<{ [key: string]: boolean }> {
  const results: { [key: string]: boolean } = {}
  
  for (const perm of permissions) {
    const key = `${perm.module}.${perm.submodule}.${perm.permission}`
    results[key] = await checkPermission(
      orgId,
      userId,
      perm.module,
      perm.submodule,
      perm.permission
    )
  }
  
  return results
}

// Permission constants for easy reference
export const PERMISSIONS = {
  HRM: {
    EMPLOYEE: {
      READ: 'read',
      CREATE: 'create',
      UPDATE: 'update',
      DELETE: 'delete',
      EXPORT: 'export',
      IMPORT: 'import'
    },
    ATTENDANCE: {
      READ: 'read',
      CREATE: 'create',
      UPDATE: 'update',
      DELETE: 'delete',
      APPROVE: 'approve',
      EXPORT: 'export'
    },
    PAYROLL: {
      READ: 'read',
      CREATE: 'create',
      UPDATE: 'update',
      DELETE: 'delete',
      APPROVE: 'approve',
      EXPORT: 'export'
    },
    LEAVE: {
      READ: 'read',
      CREATE: 'create',
      UPDATE: 'update',
      DELETE: 'delete',
      APPROVE: 'approve',
      EXPORT: 'export'
    },
    ANNOUNCEMENT: {
      READ: 'read',
      CREATE: 'create',
      UPDATE: 'update',
      DELETE: 'delete'
    }
  },
  // Add other modules as needed
}
