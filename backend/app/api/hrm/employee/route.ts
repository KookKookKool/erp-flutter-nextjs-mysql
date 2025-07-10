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

// GET - Fetch employees
export async function GET(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { organization } = auth
    const { searchParams } = new URL(request.url)
    const search = searchParams.get('search')
    const department = searchParams.get('department')
    const isActive = searchParams.get('isActive')

    // Build where condition
    const whereCondition: any = {
      orgId: organization.id
    }

    if (search) {
      whereCondition.OR = [
        { name: { contains: search } },
        { email: { contains: search } }
      ]
    }

    if (department) {
      whereCondition.role = department // Using role as department for now
    }

    if (isActive !== null) {
      whereCondition.isActive = isActive === 'true'
    }

    const users = await prisma.orgUser.findMany({
      where: whereCondition,
      orderBy: { createdAt: 'desc' }
    })

    // Transform to employee format
    const employees = users.map(user => ({
      id: user.id,
      employee_id: user.email, // Use email as employee_id for now
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
    }))

    return NextResponse.json({
      status: 'success',
      employees
    })

  } catch (error) {
    console.error('Fetch employees error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch employees' },
      { status: 500 }
    )
  }
}

// POST - Create employee
export async function POST(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request)
    if ('error' in auth) {
      return NextResponse.json({ error: auth.error }, { status: auth.status })
    }

    const { organization } = auth
    const body = await request.json()
    const { 
      employee_id, 
      first_name, 
      last_name, 
      email, 
      phone, 
      position, 
      department, 
      level,
      password 
    } = body

    // Validate required fields
    if (!employee_id || !first_name || !email || !password) {
      return NextResponse.json(
        { error: 'Required fields missing' },
        { status: 400 }
      )
    }

    // Check if employee already exists
    const existingUser = await prisma.orgUser.findFirst({
      where: {
        orgId: organization.id,
        email: email
      }
    })

    if (existingUser) {
      return NextResponse.json(
        { error: 'Employee with this email already exists' },
        { status: 409 }
      )
    }

    // Hash password
    const hashedPassword = await AuthService.hashPassword(password)

    // Create user
    const newUser = await prisma.orgUser.create({
      data: {
        email: email,
        name: `${first_name} ${last_name}`,
        password: hashedPassword,
        role: position || 'USER',
        orgId: organization.id,
        isActive: true
      }
    })

    const employee = {
      id: newUser.id,
      employee_id: employee_id,
      first_name,
      last_name,
      email: newUser.email,
      phone: phone || '',
      position: position || 'USER',
      department: department || 'General',
      level: level || 'Employee',
      start_date: newUser.createdAt,
      is_active: newUser.isActive,
      profile_image: null,
      created_at: newUser.createdAt,
      updated_at: newUser.updatedAt
    }

    return NextResponse.json({
      status: 'success',
      employee
    })

  } catch (error) {
    console.error('Create employee error:', error)
    return NextResponse.json(
      { error: 'Failed to create employee' },
      { status: 500 }
    )
  }
}
