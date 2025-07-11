import { NextRequest, NextResponse } from "next/server";
import { DatabaseManager } from "@/lib/database-manager";
import { AuthService } from "@/lib/auth";
import prisma from "@/lib/prisma";
import bcrypt from "bcryptjs";

// Helper type guard for RowDataPacket
function isRowDataPacket(obj: any): obj is Record<string, any> {
  return (
    obj &&
    typeof obj === "object" &&
    !Array.isArray(obj) &&
    !("affectedRows" in obj) &&
    !("insertId" in obj)
  );
}

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
    let user = null;
    let employeeData = null;

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

      if (
        Array.isArray(userResults) &&
        userResults.length > 0 &&
        isRowDataPacket(userResults[0])
      ) {
        user = userResults[0];
        // If found in users, try to get additional data from hrm_employees
        try {
          const empQuery = `
            SELECT * FROM hrm_employees 
            WHERE (user_id = ? OR employee_code = ? OR email = ?)
            LIMIT 1
          `;
          // Fix: Use type guard and property guard for user before passing to query
          const userId = isRowDataPacket(user) && "id" in user ? user.id : null;
          const empCode =
            isRowDataPacket(user) && "employee_id" in user
              ? user.employee_id
              : employeeId;
          const emailVal =
            isRowDataPacket(user) && "email" in user ? user.email : employeeId;
          const [empResults] = await connection.execute(empQuery, [
            userId,
            empCode,
            emailVal,
          ]);

          if (
            Array.isArray(empResults) &&
            empResults.length > 0 &&
            isRowDataPacket(empResults[0])
          ) {
            employeeData = empResults[0];
          } else {
            employeeData = null;
          }
        } catch (empError) {
          console.log("Could not fetch hrm_employees data:", empError);
        }
      } else {
        // If not found in users, do NOT allow login (do not check hrm_employees for password)
        return NextResponse.json(
          { error: "บัญชีนี้ยังไม่ได้ตั้งรหัสผ่าน กรุณาติดต่อผู้ดูแลระบบ" },
          { status: 403 }
        );
      }
    } catch (error) {
      console.error("Error finding user:", error);
      return NextResponse.json(
        { error: "เกิดข้อผิดพลาดในการค้นหาผู้ใช้" },
        { status: 500 }
      );
    }

    if (!user || !isRowDataPacket(user)) {
      return NextResponse.json(
        { error: "ไม่พบรหัสพนักงานในระบบ" },
        { status: 404 }
      );
    }

    // Check if password exists
    if (!("password" in user) || !user.password) {
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
      id: "id" in user ? user.id : null,
      employee_id: "employee_id" in user ? user.employee_id : employeeId,
      first_name:
        employeeData &&
        isRowDataPacket(employeeData) &&
        "first_name" in employeeData
          ? employeeData.first_name
          : "first_name" in user
          ? user.first_name
          : user.name?.split(" ")[0] || "",
      last_name:
        employeeData &&
        isRowDataPacket(employeeData) &&
        "last_name" in employeeData
          ? employeeData.last_name
          : "last_name" in user
          ? user.last_name
          : user.name?.split(" ").slice(1).join(" ") || "",
      email: "email" in user ? user.email : "",
      phone:
        employeeData && isRowDataPacket(employeeData) && "phone" in employeeData
          ? employeeData.phone
          : "phone" in user
          ? user.phone
          : "",
      position:
        employeeData &&
        isRowDataPacket(employeeData) &&
        "position" in employeeData
          ? employeeData.position
          : "position" in user
          ? user.position
          : "",
      department:
        employeeData &&
        isRowDataPacket(employeeData) &&
        "department" in employeeData
          ? employeeData.department
          : "department" in user
          ? user.department
          : "",
      level:
        employeeData && isRowDataPacket(employeeData) && "level" in employeeData
          ? employeeData.level
          : "level" in user
          ? user.level
          : "Employee",
      start_date:
        employeeData &&
        isRowDataPacket(employeeData) &&
        "hire_date" in employeeData
          ? employeeData.hire_date
          : "start_date" in user
          ? user.start_date
          : user.created_at,
      is_active: "is_active" in user ? user.is_active : true,
      profile_image:
        employeeData &&
        isRowDataPacket(employeeData) &&
        "profile_image" in employeeData
          ? employeeData.profile_image
          : "profile_image" in user
          ? user.profile_image
          : undefined,
      created_at: "created_at" in user ? user.created_at : undefined,
      updated_at: "updated_at" in user ? user.updated_at : undefined,
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
