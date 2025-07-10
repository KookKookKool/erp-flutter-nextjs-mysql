import { NextRequest, NextResponse } from 'next/server'
import { DatabaseManager } from '../../../../../../../../lib/database-manager'
import { MODULE_STRUCTURE, createPermissionRecords, getUserPermissions } from '../../../../../../../../lib/permissions'
import mysql from 'mysql2/promise'
import prisma from '../../../../../../../../lib/prisma'

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string; userId: string } }
) {
  try {
    const orgId = params.id
    const userId = params.userId
    
    // Get organization from main database
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
      // Check if user exists
      const [userRows] = await connection.query(
        'SELECT id FROM users WHERE id = ?',
        [userId]
      ) as any[]

      if (!userRows || userRows.length === 0) {
        return NextResponse.json(
          { error: 'User not found' },
          { status: 404 }
        )
      }

      // Get user permissions from database
      const [permissionRows] = await connection.query(
        'SELECT * FROM user_permissions WHERE user_id = ?',
        [userId]
      ) as any[]

      // Convert to structured format
      const permissions = getUserPermissions(permissionRows || [])
      
      return NextResponse.json({
        permissions,
        moduleStructure: MODULE_STRUCTURE
      })
    } finally {
      await connection.end()
    }
  } catch (error) {
    console.error('Error fetching user permissions:', error)
    return NextResponse.json(
      { error: 'Failed to fetch user permissions' },
      { status: 500 }
    )
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string; userId: string } }
) {
  try {
    const orgId = params.id
    const userId = params.userId
    const { permissions } = await request.json()
    
    // Get organization from main database
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
      // Check if user exists
      const [userRows] = await connection.query(
        'SELECT id FROM users WHERE id = ?',
        [userId]
      ) as any[]

      if (!userRows || userRows.length === 0) {
        return NextResponse.json(
          { error: 'User not found' },
          { status: 404 }
        )
      }

      // Delete existing permissions
      await connection.query(
        'DELETE FROM user_permissions WHERE user_id = ?',
        [userId]
      )

      // Create new permission records
      const permissionRecords = createPermissionRecords(userId, permissions)
      
      // Insert new permissions
      if (permissionRecords.length > 0) {
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
      }

      return NextResponse.json({ 
        message: 'Permissions updated successfully',
        permissions 
      })
    } finally {
      await connection.end()
    }
  } catch (error) {
    console.error('Error updating user permissions:', error)
    return NextResponse.json(
      { error: 'Failed to update user permissions' },
      { status: 500 }
    )
  }
}
