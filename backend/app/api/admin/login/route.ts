import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { AuthService } from '@/lib/auth'

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json()

    if (!email || !password) {
      return NextResponse.json(
        { error: 'กรุณากรอกอีเมลและรหัสผ่าน' },
        { status: 400 }
      )
    }

    // ค้นหา Admin User
    const admin = await prisma.adminUser.findUnique({
      where: { email }
    })

    if (!admin || !admin.isActive) {
      return NextResponse.json(
        { error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' },
        { status: 401 }
      )
    }

    // ตรวจสอบรหัสผ่าน
    const isValidPassword = await AuthService.comparePassword(password, admin.password)
    
    if (!isValidPassword) {
      return NextResponse.json(
        { error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' },
        { status: 401 }
      )
    }

    // สร้าง JWT token
    const token = AuthService.generateToken({
      adminId: admin.id,
      email: admin.email,
      role: admin.role
    })

    // Log audit
    await prisma.adminAuditLog.create({
      data: {
        adminId: admin.id,
        action: 'LOGIN',
        target: admin.id,
        details: { email: admin.email },
        ipAddress: request.headers.get('x-forwarded-for') || 'unknown',
        userAgent: request.headers.get('user-agent') || 'unknown'
      }
    })

    return NextResponse.json({
      success: true,
      token,
      admin: {
        id: admin.id,
        email: admin.email,
        name: admin.name,
        role: admin.role
      }
    })

  } catch (error) {
    console.error('❌ Admin login error:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ' },
      { status: 500 }
    )
  }
}
