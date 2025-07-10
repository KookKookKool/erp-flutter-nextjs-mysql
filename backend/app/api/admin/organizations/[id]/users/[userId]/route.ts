import { NextRequest, NextResponse } from 'next/server'
import { verifyAdmin } from '../../../../../../../lib/auth'
import { DatabaseManager } from '../../../../../../../lib/database-manager'
import prisma from '../../../../../../../lib/prisma'

// PUT - แก้ไข user
export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string, userId: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { name, email, password, role, isActive, schemaName } = body

    if (!schemaName) {
      return NextResponse.json(
        { error: 'ไม่พบข้อมูล schema ขององค์กร' },
        { status: 400 }
      )
    }

    const dbManager = DatabaseManager.getInstance()
    
    const updateData: any = {}
    if (name !== undefined) updateData.name = name
    if (email !== undefined) updateData.email = email
    if (password && password.trim() !== '') updateData.password = password
    if (role !== undefined) updateData.role = role
    if (isActive !== undefined) updateData.isActive = isActive

    await dbManager.updateOrganizationUser(schemaName, params.userId, updateData)

    return NextResponse.json({
      success: true,
      message: 'แก้ไขข้อมูลผู้ใช้เรียบร้อยแล้ว'
    })

  } catch (error: any) {
    console.error('❌ Error updating user:', error)
    
    if (error.code === 'ER_DUP_ENTRY') {
      return NextResponse.json(
        { error: 'อีเมลนี้มีผู้ใช้งานแล้ว' },
        { status: 400 }
      )
    }
    
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการแก้ไขผู้ใช้' },
      { status: 500 }
    )
  }
}

// DELETE - ลบ user
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string, userId: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { schemaName } = body

    if (!schemaName) {
      return NextResponse.json(
        { error: 'ไม่พบข้อมูล schema ขององค์กร' },
        { status: 400 }
      )
    }

    const dbManager = DatabaseManager.getInstance()
    await dbManager.deleteOrganizationUser(schemaName, params.userId)

    return NextResponse.json({
      success: true,
      message: 'ลบผู้ใช้เรียบร้อยแล้ว'
    })

  } catch (error) {
    console.error('❌ Error deleting user:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการลบผู้ใช้' },
      { status: 500 }
    )
  }
}
