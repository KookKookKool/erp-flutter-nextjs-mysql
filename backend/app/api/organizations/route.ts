import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET(request: NextRequest) {
  try {
    // ดึงรายการองค์กรที่อนุมัติแล้วและยังใช้งานได้
    const organizations = await prisma.organization.findMany({
      where: {
        status: 'APPROVED',
        isActive: true,
        // ไม่หมดอายุ หรือยังไม่มีวันหมดอายุ
        OR: [
          { subscriptionEnd: null },
          { subscriptionEnd: { gt: new Date() } }
        ]
      },
      select: {
        orgCode: true,
        orgName: true,
        subscriptionPlan: true
      },
      orderBy: {
        orgCode: 'asc'
      }
    })

    return NextResponse.json({
      success: true,
      organizations
    })

  } catch (error) {
    console.error('❌ Get organizations error:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการดึงข้อมูลองค์กร' },
      { status: 500 }
    )
  }
}
