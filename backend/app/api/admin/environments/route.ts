import { NextRequest, NextResponse } from 'next/server';
import prisma from '@/lib/prisma';

// GET /api/admin/environments - ดึงรายการ environment configurations
export async function GET() {
  try {
    // สำหรับตอนนี้ให้ return mock data เพราะยังไม่มี table ใน database
    const environments = [
      {
        id: '1',
        name: 'Development',
        apiUrl: 'http://localhost:3000/api',
        dbUrl: 'mysql://root:root123@localhost:3306/erp_db',
        isActive: true,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      },
      {
        id: '2',
        name: 'Production',
        apiUrl: 'https://your-production-domain.com/api',
        dbUrl: 'mysql://prod_user:prod_pass@prod_host:3306/erp_prod',
        isActive: false,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      }
    ];

    return NextResponse.json({
      success: true,
      environments,
    });
  } catch (error) {
    console.error('Error fetching environments:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to fetch environments' },
      { status: 500 }
    );
  }
}

// POST /api/admin/environments - เพิ่ม environment configuration ใหม่
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { name, apiUrl, dbUrl } = body;

    if (!name || !apiUrl || !dbUrl) {
      return NextResponse.json(
        { success: false, message: 'Name, API URL, and Database URL are required' },
        { status: 400 }
      );
    }

    // สำหรับตอนนี้ให้ return success response
    // ในอนาคตจะเก็บลง database จริง
    const newEnvironment = {
      id: Date.now().toString(),
      name,
      apiUrl,
      dbUrl,
      isActive: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    return NextResponse.json({
      success: true,
      environment: newEnvironment,
      message: 'Environment configuration added successfully',
    });
  } catch (error) {
    console.error('Error creating environment:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to create environment' },
      { status: 500 }
    );
  }
}
