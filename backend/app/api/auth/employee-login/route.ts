import { NextRequest, NextResponse } from "next/server";
import { DatabaseManager } from "@/lib/database-manager";
import { AuthService } from "@/lib/auth";
import prisma from "@/lib/prisma";
import bcrypt from "bcryptjs";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { orgCode, employeeId, password } = body;

    // Validate required fields
    if (!orgCode || !employeeId || !password) {
      return NextResponse.json(
        { error: "กรุณากรอกข้อมูลให้ครบถ้วน" },
        { status: 400 }
      );
    }

    // Get organization info from main database
    const organization = await prisma.organization.findUnique({
      where: { orgCode: orgCode.toUpperCase() },
    });

    if (!organization) {
      return NextResponse.json(
        { error: "ไม่พบรหัสองค์กรในระบบ" },
        { status: 404 }
      );
    }

    // Check organization status
    if (organization.status !== "APPROVED") {
      return NextResponse.json(
        { error: "องค์กรยังไม่ได้รับการอนุมัติ" },
        { status: 403 }
      );
    }

    if (!organization.isActive) {
      return NextResponse.json(
        { error: "องค์กรถูกระงับการใช้งาน" },
        { status: 403 }
      );
    }

    // Get connection to organization database
    const dbManager = DatabaseManager.getInstance();
    const schemaName = `org_${organization.orgCode.toLowerCase()}`;
    const connection = await dbManager.getOrganizationConnection(schemaName);

    // Find user in org database - try multiple approaches
    let user: any = null;
    let employeeData: any = null;

    try {
      // First, try to find in users table by employee_id or email
      const userQuery = `
        SELECT * FROM users 
        WHERE (employee_id = ? OR email = ?) 
        AND is_active = 1
        LIMIT 1
      `;
      const [userResults] = await connection.execute(userQuery, [
        employeeId,
        employeeId,
      ]);

      if (Array.isArray(userResults) && userResults.length > 0) {
        user = userResults[0] as any;
      }

      // If not found in users, try hrm_employees table
      if (!user) {
        try {
          const empQuery = `
            SELECT * FROM hrm_employees 
            WHERE (employee_code = ? OR email = ?) 
            AND is_active = 1
            LIMIT 1
          `;
          const [empResults] = await connection.execute(empQuery, [
            employeeId,
            employeeId,
          ]);

          if (Array.isArray(empResults) && empResults.length > 0) {
            employeeData = empResults[0] as any;

            // Create a user-like object from employee data
            user = {
              id: employeeData.id,
              employee_id: employeeData.employee_code,
              email: employeeData.email,
              password: employeeData.password || null,
              name: `${employeeData.first_name || ""} ${
                employeeData.last_name || ""
              }`.trim(),
              first_name: employeeData.first_name,
              last_name: employeeData.last_name,
              phone: employeeData.phone,
              position: employeeData.position,
              level: employeeData.level,
              is_active: employeeData.is_active,
              created_at: employeeData.created_at,
              updated_at: employeeData.updated_at,
            };
          }
        } catch (empError) {
          console.log("hrm_employees table not found or error:", empError);
        }
      } else {
        // If found in users, try to get additional data from hrm_employees
        try {
          const empQuery = `
            SELECT * FROM hrm_employees 
            WHERE (user_id = ? OR employee_code = ? OR email = ?)
            LIMIT 1
          `;
          const [empResults] = await connection.execute(empQuery, [
            user.id,
            user.employee_id || employeeId,
            user.email,
          ]);

          if (Array.isArray(empResults) && empResults.length > 0) {
            employeeData = empResults[0] as any;
          }
        } catch (empError) {
          console.log("Could not fetch hrm_employees data:", empError);
        }
      }
    } catch (error) {
      console.error("Error finding user:", error);
      return NextResponse.json(
        { error: "เกิดข้อผิดพลาดในการค้นหาผู้ใช้" },
        { status: 500 }
      );
    }

    if (!user) {
      return NextResponse.json(
        { error: "ไม่พบรหัสพนักงานในระบบ" },
        { status: 404 }
      );
    }

    // Check if password exists
    if (!user.password) {
      return NextResponse.json(
        { error: "บัญชีนี้ยังไม่ได้ตั้งรหัสผ่าน กรุณาติดต่อผู้ดูแลระบบ" },
        { status: 403 }
      );
    }

    // Verify password
    const isPasswordValid = await AuthService.verifyPassword(
      password,
      user.password
    );
    if (!isPasswordValid) {
      return NextResponse.json(
        { error: "รหัสพนักงานหรือรหัสผ่านไม่ถูกต้อง" },
        { status: 401 }
      );
    }

    // Combine user and employee data
    const employee = {
      id: user.id,
      employee_id: user.employee_id || employeeId,
      first_name:
        employeeData?.first_name ||
        user.first_name ||
        user.name?.split(" ")[0] ||
        "",
      last_name:
        employeeData?.last_name ||
        user.last_name ||
        user.name?.split(" ").slice(1).join(" ") ||
        "",
      email: user.email,
      phone: employeeData?.phone || user.phone || "",
      position: employeeData?.position || user.position || "",
      department: employeeData?.department || user.department || "",
      level: employeeData?.level || user.level || "Employee",
      start_date: employeeData?.hire_date || user.start_date || user.created_at,
      is_active: user.is_active,
      profile_image: employeeData?.profile_image || user.profile_image,
      created_at: user.created_at,
      updated_at: user.updated_at,
    };

    // Get user permissions (basic HRM permissions for employees)
    const permissions = {
      hrm: {
        employee: {
          read: true,
          create: false,
          update: true, // Can update own profile
          delete: false,
          export: false,
          import: false,
        },
        attendance: {
          read: true,
          create: true,
          update: true,
          delete: false,
          approve: false,
          export: false,
        },
        leave: {
          read: true,
          create: true,
          update: true,
          delete: true,
          approve: false,
          export: false,
        },
        announcement: {
          read: true,
          create: false,
          update: false,
          delete: false,
          export: false,
        },
      },
    };

    // Generate JWT token
    const tokenPayload = {
      userId: user.id,
      orgId: organization.id,
      orgCode: organization.orgCode,
      email: user.email,
      role: "EMPLOYEE",
      type: "org_user" as const,
    };

    const token = AuthService.generateToken(tokenPayload);

    return NextResponse.json({
      token,
      employee,
      organization: {
        id: organization.id,
        orgCode: organization.orgCode,
        orgName: organization.orgName,
        orgEmail: organization.orgEmail,
      },
      permissions,
    });
  } catch (error) {
    console.error("Employee login error:", error);
    return NextResponse.json(
      { error: "เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์" },
      { status: 500 }
    );
  }
}

export async function OPTIONS(req: Request) {
  return new Response(null, {
    status: 200,
    headers: {
      "Access-Control-Allow-Origin": req.headers.get("origin") || "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type,Authorization",
      "Access-Control-Max-Age": "86400",
      Vary: "Origin",
    },
  });
}
