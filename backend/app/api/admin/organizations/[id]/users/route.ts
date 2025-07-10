import { NextRequest, NextResponse } from 'next/server'
import { verifyAdmin } from '../../../../../../lib/auth'
import { DatabaseManager } from '../../../../../../lib/database-manager'
import prisma from '../../../../../../lib/prisma'
import bcrypt from 'bcryptjs'
import { v4 as uuidv4 } from 'uuid'

// GET - ดึงรายการ users ในองค์กร
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const dbManager = DatabaseManager.getInstance()
    const organization = await prisma.organization.findUnique({
      where: { id: params.id }
    })

    if (!organization || !organization.schemaName) {
      return NextResponse.json(
        { error: 'ไม่พบองค์กรหรือองค์กรยังไม่ได้รับการอนุมัติ' },
        { status: 404 }
      )
    }

    const users = await dbManager.getOrganizationUsers(organization.schemaName)

    return NextResponse.json({ users })

  } catch (error) {
    console.error('❌ Error fetching users:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้' },
      { status: 500 }
    )
  }
}

// POST - สร้าง user ใหม่ในองค์กร
export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { name, email, password, role = 'USER', isActive = true, schemaName } = body

    if (!name || !email || !password) {
      return NextResponse.json(
        { error: 'กรุณากรอกข้อมูลให้ครบถ้วน' },
        { status: 400 }
      )
    }

    if (!schemaName) {
      return NextResponse.json(
        { error: 'ไม่พบข้อมูล schema ขององค์กร' },
        { status: 400 }
      )
    }

    const dbManager = DatabaseManager.getInstance()
    
    // สร้าง user ในองค์กร
    const userId = await dbManager.createOrganizationUser(schemaName, {
      name,
      email,
      password,
      role,
      isActive
    })

    return NextResponse.json({
      success: true,
      message: 'สร้างผู้ใช้เรียบร้อยแล้ว',
      userId
    })

  } catch (error: any) {
    console.error('❌ Error creating user:', error)
    
    if (error.code === 'ER_DUP_ENTRY') {
      return NextResponse.json(
        { error: 'อีเมลนี้มีผู้ใช้งานแล้ว' },
        { status: 400 }
      )
    }
    
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการสร้างผู้ใช้' },
      { status: 500 }
    )
  }
}
