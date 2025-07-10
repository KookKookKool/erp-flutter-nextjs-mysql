import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { AuthService } from '@/lib/auth'

// Middleware สำหรับตรวจสอบ Admin Token
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

// GET - รายชื่อองค์กรทั้งหมด
export async function GET(request: NextRequest) {
  try {
    const admin = await verifyAdmin(request)
    if (!admin) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { searchParams } = new URL(request.url)
    const status = searchParams.get('status')
    const page = parseInt(searchParams.get('page') || '1')
    const limit = parseInt(searchParams.get('limit') || '10')
    const skip = (page - 1) * limit

    const where = status ? { status: status as any } : {}

    const [organizations, total] = await Promise.all([
      prisma.organization.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        select: {
          id: true,
          orgCode: true,
          orgName: true,
          orgEmail: true,
          adminName: true,
          adminEmail: true,
          status: true,
          subscriptionPlan: true,
          subscriptionStart: true,
          subscriptionEnd: true,
          createdAt: true,
          approvedAt: true,
          schemaName: true,
          isActive: true
        }
      }),
      prisma.organization.count({ where })
    ])

    return NextResponse.json({
      organizations,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    })

  } catch (error) {
    console.error('❌ Error fetching organizations:', error)
    return NextResponse.json(
      { error: 'เกิดข้อผิดพลาดในการดึงข้อมูล' },
      { status: 500 }
    )
  }
}
