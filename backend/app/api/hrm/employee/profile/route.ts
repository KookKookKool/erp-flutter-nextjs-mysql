import { NextRequest, NextResponse } from 'next/server'
import prisma from '@/lib/prisma'
import { AuthService } from '@/lib/auth'

// Helper function to verify token and get organization
async function verifyTokenAndGetOrg(request: NextRequest) {
  try {
    const authHeader = request.headers.get('authorization')
    const orgCode = request.headers.get('x-org-code')
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return { error: 'No authorization token provided', status: 401 }
    }

    if (!orgCode) {
      return { error: 'Organization code is required', status: 400 }
    }

    const token = authHeader.substring(7)
    const payload = AuthService.verifyToken(token)
    
    if (!payload) {
      return { error: 'Invalid token', status: 401 }
    }

    const organization = await prisma.organization.findUnique({
      where: { orgCode: orgCode.toUpperCase() }
    })

    if (!organization) {
      return { error: 'Organization not found', status: 404 }
    }

    return { organization, payload }
  } catch (error) {
    return { error: 'Authentication error', status: 500 }
  }
}

// GET - Fetch employee profile
export async function GET(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { organization } = auth
    const { searchParams } = new URL(request.url)
    const employeeId = searchParams.get('employeeId')

    if (!employeeId) {
      return NextResponse.json(
        { error: 'Employee ID is required' },
        { status: 400 }
      )
    }

    // Find employee by email (using email as employee_id for now)
    const user = await prisma.orgUser.findFirst({
      where: {
        orgId: organization.id,
        email: employeeId,
        isActive: true
      }
    })

    if (!user) {
      return NextResponse.json(
        { error: 'Employee not found' },
        { status: 404 }
      )
    }

    // Transform to employee format
    const employee = {
      id: user.id,
      employee_id: employeeId,
      first_name: user.name.split(' ')[0] || '',
      last_name: user.name.split(' ').slice(1).join(' ') || '',
      email: user.email,
      phone: '',
      position: user.role,
      department: 'General',
      level: user.role,
      start_date: user.createdAt,
      is_active: user.isActive,
      profile_image: null,
      created_at: user.createdAt,
      updated_at: user.updatedAt
    }

    return NextResponse.json({
      status: 'success',
      employee
    })

  } catch (error) {
    console.error('Fetch employee profile error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch employee profile' },
      { status: 500 }
    )
  }
}

// PUT - Update employee profile
export async function PUT(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { organization, payload } = auth
    const body = await request.json()
    const { 
      first_name, 
      last_name, 
      phone, 
      position, 
      department, 
      level 
    } = body

    // Find employee by user ID from token
    const user = await prisma.orgUser.findFirst({
      where: {
        id: payload.userId,
        orgId: organization.id,
        isActive: true
      }
    })

    if (!user) {
      return NextResponse.json(
        { error: 'Employee not found' },
        { status: 404 }
      )
    }

    // Update user
    const updatedUser = await prisma.orgUser.update({
      where: { id: user.id },
      data: {
        name: `${first_name} ${last_name}`,
        role: position || user.role,
        updatedAt: new Date()
      }
    })

    const employee = {
      id: updatedUser.id,
      employee_id: user.email,
      first_name,
      last_name,
      email: updatedUser.email,
      phone: phone || '',
      position: position || updatedUser.role,
      department: department || 'General',
      level: level || updatedUser.role,
      start_date: updatedUser.createdAt,
      is_active: updatedUser.isActive,
      profile_image: null,
      created_at: updatedUser.createdAt,
      updated_at: updatedUser.updatedAt
    }

    return NextResponse.json({
      status: 'success',
      employee
    })

  } catch (error) {
    console.error('Update employee profile error:', error)
    return NextResponse.json(
      { error: 'Failed to update employee profile' },
      { status: 500 }
    )
  }
}
