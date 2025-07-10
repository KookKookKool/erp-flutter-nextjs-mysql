import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { AuthService } from '@/lib/auth'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { orgCode, email, password } = body

    // Validate required fields
    if (!orgCode || !email || !password) {
      return NextResponse.json(
        { error: 'กรุณากรอกข้อมูลให้ครบถ้วน' },
        { status: 400 }
      )
    }

    // Find organization
    const organization = await prisma.organization.findUnique({
      where: { orgCode: orgCode.toUpperCase() },
      include: {
        users: {
          where: { email: email.toLowerCase() },
          take: 1
        }
      }
    })

    if (!organization) {
      return NextResponse.json(
        { error: 'ไม่พบรหัสองค์กรในระบบ' },
        { status: 404 }
      )
    }

    // Check organization status
    if (organization.status !== 'APPROVED') {
      return NextResponse.json(
        { error: 'องค์กรยังไม่ได้รับการอนุมัติ' },
        { status: 403 }
      )
    }

    if (!organization.isActive) {
      return NextResponse.json(
        { error: 'องค์กรถูกระงับการใช้งาน' },
        { status: 403 }
      )
    }

    // Check subscription expiry
    if (organization.subscriptionEnd && new Date() > organization.subscriptionEnd) {
      return NextResponse.json(
        { error: 'องค์กรหมดอายุการใช้งาน' },
        { status: 403 }
      )
    }

    // Try to login with admin credentials first
    if (email.toLowerCase() === organization.adminEmail.toLowerCase()) {
      const isValidPassword = await AuthService.verifyPassword(password, organization.adminPassword)
      
      if (isValidPassword) {
        // Generate JWT token
        const token = await AuthService.generateToken({
          userId: `admin_${organization.id}`,
          orgId: organization.id,
          orgCode: organization.orgCode,
          email: organization.adminEmail,
          name: organization.adminName,
          role: 'ADMIN',
          type: 'org_admin'
        })

        return NextResponse.json({
          success: true,
          message: 'เข้าสู่ระบบสำเร็จ',
          token,
          user: {
            id: `admin_${organization.id}`,
            name: organization.adminName,
            email: organization.adminEmail,
            role: 'ADMIN',
            orgCode: organization.orgCode,
            orgName: organization.orgName,
            type: 'org_admin'
          },
          organization: {
            id: organization.id,
            orgCode: organization.orgCode,
            orgName: organization.orgName,
            subscriptionPlan: organization.subscriptionPlan,
            subscriptionEnd: organization.subscriptionEnd
          }
        })
      }
    }

    // Try to login with organization user credentials
    if (organization.users.length > 0) {
      const user = organization.users[0]
      const isValidPassword = await AuthService.verifyPassword(password, user.password)
      
      if (isValidPassword) {
        if (!user.isActive) {
          return NextResponse.json(
            { error: 'บัญชีผู้ใช้ถูกระงับการใช้งาน' },
            { status: 403 }
          )
        }

        // Generate JWT token
        const token = await AuthService.generateToken({
          userId: user.id,
          orgId: organization.id,
          orgCode: organization.orgCode,
          email: user.email,
          name: user.name,
          role: user.role,
          type: 'org_user'
        })

        return NextResponse.json({
          success: true,
          message: 'เข้าสู่ระบบสำเร็จ',
          token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            orgCode: organization.orgCode,
            orgName: organization.orgName,
            type: 'org_user'
          },
          organization: {
            id: organization.id,
            orgCode: organization.orgCode,
            orgName: organization.orgName,
            subscriptionPlan: organization.subscriptionPlan,
            subscriptionEnd: organization.subscriptionEnd
          }
        })
      }
    }

    // Invalid credentials
    return NextResponse.json(
      { error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' },
      { status: 401 }
    )

  } catch (error) {
    console.error('❌ Login error:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ' },
      { status: 500 }
    )
  }
}
