import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET(
  request: NextRequest,
  { params }: { params: { orgCode: string } }
) {
  try {
    const { orgCode } = params

    if (!orgCode) {
      return NextResponse.json(
        { error: 'กรุณาระบุรหัสองค์กร' },
        { status: 400 }
      )
    }

    // ค้นหาองค์กรจากรหัส
    const organization = await prisma.organization.findUnique({
      where: { 
        orgCode: orgCode.toUpperCase() 
      },
      select: {
        id: true,
        orgCode: true,
        orgName: true,
        status: true,
        isActive: true,
        subscriptionPlan: true,
        subscriptionStart: true,
        subscriptionEnd: true,
        createdAt: true,
        approvedAt: true
      }
    })

    if (!organization) {
      return NextResponse.json(
        { 
          error: 'ไม่พบรหัสองค์กร',
          message: 'ไม่พบรหัสองค์กรนี้ในระบบ กรุณาตรวจสอบรหัสองค์กรอีกครั้ง หรือสมัครสมาชิกใหม่' 
        },
        { status: 404 }
      )
    }

    // ตรวจสอบสถานะองค์กร
    let message = ''
    let canLogin = false
    let isExpired = false

    switch (organization.status) {
      case 'PENDING':
        message = 'องค์กรอยู่ระหว่างการตรวจสอบ กรุณารอการอนุมัติจากผู้ดูแลระบบ'
        break
      case 'APPROVED':
        if (!organization.isActive) {
          message = 'องค์กรถูกระงับการใช้งาน กรุณาติดต่อผู้ดูแลระบบ'
        } else {
          // ตรวจสอบวันหมดอายุ
          if (organization.subscriptionEnd && new Date() > organization.subscriptionEnd) {
            message = 'องค์กรหมดอายุการใช้งาน กรุณาต่ออายุการใช้งาน'
            isExpired = true
          } else {
            message = 'องค์กรพร้อมใช้งาน'
            canLogin = true
          }
        }
        break
      case 'REJECTED':
        message = 'องค์กรถูกปฏิเสธ กรุณาติดต่อผู้ดูแลระบบเพื่อสอบถามรายละเอียด'
        break
      case 'SUSPENDED':
        message = 'องค์กรถูกระงับการใช้งาน กรุณาติดต่อผู้ดูแลระบบ'
        break
      case 'EXPIRED':
        message = 'องค์กรหมดอายุการใช้งาน กรุณาต่ออายุการใช้งาน'
        isExpired = true
        break
      default:
        message = 'สถานะองค์กรไม่ชัดเจน กรุณาติดต่อผู้ดูแลระบบ'
    }

    return NextResponse.json({
      status: organization.status,
      message,
      canLogin,
      organization: {
        id: organization.id,
        orgCode: organization.orgCode,
        orgName: organization.orgName,
        isActive: organization.isActive,
        isExpired,
        subscriptionPlan: organization.subscriptionPlan,
        subscriptionEnd: organization.subscriptionEnd,
        approvedAt: organization.approvedAt
      }
    })

  } catch (error) {
    console.error('❌ Org status check error:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการตรวจสอบสถานะองค์กร' },
      { status: 500 }
    )
  }
}
