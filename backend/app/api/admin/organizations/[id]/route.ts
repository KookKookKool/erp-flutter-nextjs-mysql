import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { AuthService } from '@/lib/auth'
import { DatabaseManager } from '@/lib/database-manager'

async function verifyAdmin(request: NextRequest) {
  const authorization = request.headers.get('authorization')
  if (!authorization || !authorization.startsWith('Bearer ')) {
    return null
  }

  const token = authorization.split(' ')[1]
  const payload = AuthService.verifyToken(token)
  
  if (!payload) {
    return null
  }

  const admin = await prisma.adminUser.findUnique({
    where: { id: payload.adminId }
  })

  return admin?.isActive ? admin : null
}

// GET - รายละเอียดองค์กร
export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const organization = await prisma.organization.findUnique({
      where: { id: params.id },
      include: {
        users: {
          select: {
            id: true,
            email: true,
            name: true,
            role: true,
            isActive: true,
            createdAt: true
          }
        }
      }
    })

    if (!organization) {
      return NextResponse.json(
        { error: 'ไม่พบองค์กรนี้' },
        { status: 404 }
      )
    }

    // ดึงข้อมูล users จาก organization schema
    let users: any[] = []
    if (organization.schemaName) {
      const dbManager = DatabaseManager.getInstance()
      users = await dbManager.getOrganizationUsers(organization.schemaName)
    }

    return NextResponse.json({ 
      organization: {
        ...organization,
        users
      }
    })

  } catch (error) {
    console.error('❌ Error fetching organization:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการดึงข้อมูล' },
      { status: 500 }
    )
  }
}

// PATCH - อัพเดทสถานะองค์กร (อนุมัติ/ปฏิเสธ)
export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const { action, subscriptionPlan, subscriptionEnd, orgName, orgEmail, orgPhone, orgAddress, orgDescription, adminName, adminEmail } = body

    const organization = await prisma.organization.findUnique({
      where: { id: params.id }
    })

    if (!organization) {
      return NextResponse.json(
        { error: 'ไม่พบองค์กรนี้' },
        { status: 404 }
      )
    }

    let updateData: any = {}
    let auditAction = ''
    let dbManager: DatabaseManager | null = null

    switch (action) {
      case 'approve':
        if (organization.status !== 'PENDING') {
          return NextResponse.json(
            { error: 'สามารถอนุมัติได้เฉพาะองค์กรที่มีสถานะรอการอนุมัติเท่านั้น' },
            { status: 400 }
          )
        }

        // สร้าง Database Schema สำหรับองค์กร
        dbManager = DatabaseManager.getInstance()
        const schemaName = await dbManager.createOrganizationSchema(organization.orgCode)
        
        // สร้าง Super Admin User เริ่มต้น
        const adminCredentials = await dbManager.createInitialAdminUser(schemaName, {
          email: organization.adminEmail, // ไม่ใช้อีเมลนี้แล้ว
          name: organization.adminName,   // ไม่ใช้ชื่อนี้แล้ว
          orgCode: organization.orgCode   // ใช้รหัสองค์กรสำหรับสร้างอีเมล admin_รหัสองค์กร
        })
        
        console.log(`📧 Super Admin credentials for ${organization.orgCode}:`, adminCredentials)
        console.log(`🔑 Login URL: http://localhost:3000/admin/login`)
        console.log(`📧 Email: ${adminCredentials.email}`)
        console.log(`🔐 Password: ${adminCredentials.password}`)

        updateData = {
          status: 'APPROVED',
          isActive: true,
          approvedAt: new Date(),
          approvedBy: admin.id,
          schemaName,
          subscriptionPlan: subscriptionPlan || 'BASIC',
          subscriptionStart: new Date(),
          subscriptionEnd: subscriptionEnd ? new Date(subscriptionEnd) : new Date(Date.now() + 365 * 24 * 60 * 60 * 1000) // 1 ปี
        }
        auditAction = 'APPROVE_ORGANIZATION'
        break

      case 'reject':
        updateData = {
          status: 'REJECTED',
          isActive: false
        }
        auditAction = 'REJECT_ORGANIZATION'
        break

      case 'suspend':
        updateData = {
          status: 'SUSPENDED',
          isActive: false
        }
        auditAction = 'SUSPEND_ORGANIZATION'
        break

      case 'reactivate':
        // Handle reactivation for different statuses
        if (organization.status === 'SUSPENDED') {
          updateData = {
            status: 'APPROVED',
            isActive: true
          }
        } else if (organization.status === 'REJECTED') {
          // Re-approve rejected organization
          dbManager = DatabaseManager.getInstance()
          const schemaName = await dbManager.createOrganizationSchema(organization.orgCode)
          
          updateData = {
            status: 'APPROVED',
            isActive: true,
            approvedAt: new Date(),
            approvedBy: admin.id,
            schemaName,
            subscriptionPlan: subscriptionPlan || 'BASIC',
            subscriptionStart: new Date(),
            subscriptionEnd: subscriptionEnd ? new Date(subscriptionEnd) : new Date(Date.now() + 365 * 24 * 60 * 60 * 1000)
          }
        } else if (organization.status === 'EXPIRED') {
          updateData = {
            status: 'APPROVED',
            isActive: true,
            subscriptionEnd: subscriptionEnd ? new Date(subscriptionEnd) : new Date(Date.now() + 365 * 24 * 60 * 60 * 1000)
          }
        }
        auditAction = 'REACTIVATE_ORGANIZATION'
        break

      case 'delete':
        // Delete organization and its schema if exists
        if (organization.schemaName) {
          try {
            dbManager = DatabaseManager.getInstance()
            await dbManager.deleteOrganizationSchema(organization.schemaName)
          } catch (error) {
            console.warn('Warning: Could not drop schema:', error)
          }
        }

        // Delete the organization record
        await prisma.organization.delete({
          where: { id: params.id }
        })

        // Log the deletion
        await prisma.adminAuditLog.create({
          data: {
            adminId: admin.id,
            action: 'DELETE_ORGANIZATION',
            target: params.id,
            details: {
              orgCode: organization.orgCode,
              orgName: organization.orgName,
              schemaName: organization.schemaName
            },
            ipAddress: request.headers.get('x-forwarded-for') || 'unknown',
            userAgent: request.headers.get('user-agent') || 'unknown'
          }
        })

        return NextResponse.json({
          success: true,
          message: 'ลบองค์กรเรียบร้อยแล้ว'
        })

      case 'extend':
        if (!subscriptionEnd) {
          return NextResponse.json(
            { error: 'กรุณาระบุวันหมดอายุใหม่' },
            { status: 400 }
          )
        }

        updateData = {
          subscriptionEnd: new Date(subscriptionEnd),
          isActive: true,
          status: 'APPROVED'
        }
        auditAction = 'EXTEND_SUBSCRIPTION'
        break

      case 'reactivate':
        updateData = {
          status: 'APPROVED',
          isActive: true
        }
        auditAction = 'REACTIVATE_ORGANIZATION'
        break

      case 'update':
        // อัปเดตข้อมูลองค์กร
        updateData = {}
        
        if (orgName !== undefined) updateData.orgName = orgName
        if (orgEmail !== undefined) updateData.orgEmail = orgEmail
        if (orgPhone !== undefined) updateData.orgPhone = orgPhone
        if (orgAddress !== undefined) updateData.orgAddress = orgAddress
        if (orgDescription !== undefined) updateData.orgDescription = orgDescription
        if (adminName !== undefined) updateData.adminName = adminName
        if (adminEmail !== undefined) updateData.adminEmail = adminEmail

        auditAction = 'UPDATE_ORGANIZATION'
        break

      default:
        return NextResponse.json(
          { error: 'Action ไม่ถูกต้อง' },
          { status: 400 }
        )
    }

    // อัพเดทข้อมูลองค์กร
    const updatedOrganization = await prisma.organization.update({
      where: { id: params.id },
      data: updateData
    })

    // บันทึก Audit Log
    await prisma.adminAuditLog.create({
      data: {
        adminId: admin.id,
        action: auditAction,
        target: params.id,
        details: {
          orgCode: organization.orgCode,
          orgName: organization.orgName,
          previousStatus: organization.status,
          newStatus: updateData.status
        },
        ipAddress: request.headers.get('x-forwarded-for') || 'unknown',
        userAgent: request.headers.get('user-agent') || 'unknown'
      }
    })

    console.log(`✅ Organization ${organization.orgCode} ${action}ed by ${admin.email}`)

    return NextResponse.json({
      success: true,
      message: `${
        action === 'approve' ? 'อนุมัติ' : 
        action === 'reject' ? 'ปฏิเสธ' : 
        action === 'suspend' ? 'ระงับ' : 
        action === 'extend' ? 'ต่ออายุ' :
        action === 'update' ? 'แก้ไขข้อมูล' :
        action === 'reactivate' ? 'เปิดใช้งาน' :
        'อัปเดต'
      }องค์กรเรียบร้อยแล้ว`,
      organization: updatedOrganization
    })

  } catch (error) {
    console.error('❌ Error updating organization:', error)
    
    // ส่ง error message ที่ละเอียดกว่า
    let errorMessage = 'เกิดข้อผิดพลาดในการอัพเดทข้อมูล'
    
    if (error instanceof Error) {
      if (error.message.includes('Access denied')) {
        errorMessage = 'ไม่มีสิทธิ์ในการสร้าง Database Schema โปรดตรวจสอบการตั้งค่า Database'
      } else if (error.message.includes('Connection')) {
        errorMessage = 'ไม่สามารถเชื่อมต่อกับฐานข้อมูลได้'
      } else {
        errorMessage = `เกิดข้อผิดพลาด: ${error.message}`
      }
    }
    
    return NextResponse.json(
      { error: errorMessage },
      { status: 500 }
    )
  }
}

// DELETE - ลบองค์กร
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const organization = await prisma.organization.findUnique({
      where: { id: params.id }
    })

    if (!organization) {
      return NextResponse.json(
        { error: 'ไม่พบองค์กรนี้' },
        { status: 404 }
      )
    }

    // ลบ Database Schema ถ้ามี
    if (organization.schemaName) {
      const dbManager = DatabaseManager.getInstance()
      await dbManager.deleteOrganizationSchema(organization.schemaName)
    }

    // ลบข้อมูลองค์กร
    await prisma.organization.delete({
      where: { id: params.id }
    })

    // บันทึก Audit Log
    await prisma.adminAuditLog.create({
      data: {
        adminId: admin.id,
        action: 'DELETE_ORGANIZATION',
        target: params.id,
        details: {
          orgCode: organization.orgCode,
          orgName: organization.orgName,
          schemaName: organization.schemaName
        },
        ipAddress: request.headers.get('x-forwarded-for') || 'unknown',
        userAgent: request.headers.get('user-agent') || 'unknown'
      }
    })

    console.log(`🗑️ Organization ${organization.orgCode} deleted by ${admin.email}`)

    return NextResponse.json({
      success: true,
      message: 'ลบองค์กรเรียบร้อยแล้ว'
    })

  } catch (error) {
    console.error('❌ Error deleting organization:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการลบข้อมูล' },
      { status: 500 }
    )
  }
}
