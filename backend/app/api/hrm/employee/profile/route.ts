import { NextRequest, NextResponse } from "next/server";
import prisma from "@/lib/prisma";
import { AuthService } from "@/lib/auth";
import mysql from "mysql2/promise";
import { getUserPermissions } from "@/lib/permissions";

// OPTIONS - CORS preflight handler
export async function OPTIONS(request: NextRequest) {
  const origin = request.headers.get("origin") || "*";
  const res = new NextResponse(null, { status: 204 });
  res.headers.set("Access-Control-Allow-Origin", origin);
  res.headers.set("Vary", "Origin");
  res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
  res.headers.set(
    "Access-Control-Allow-Headers",
    "Content-Type,Authorization,x-org-code"
  );
  return res;
}

// Helper function to verify token and get organization
async function verifyTokenAndGetOrg(request: NextRequest) {
  try {
    const authHeader = request.headers.get("authorization");
    const orgCode = request.headers.get("x-org-code");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return { error: "No authorization token provided", status: 401 };
    }
    if (!orgCode) {
      return { error: "Organization code is required", status: 400 };
    }
    const token = authHeader.substring(7);
    const payload = AuthService.verifyToken(token);
    if (!payload) {
      return { error: "Invalid token", status: 401 };
    }
    const organization = await prisma.organization.findUnique({
      where: { orgCode: orgCode.toUpperCase() },
    });
    if (!organization) {
      return { error: "Organization not found", status: 404 };
    }
    return { organization, payload };
  } catch (error) {
    return { error: "Authentication error", status: 500 };
  }
}

// GET - Fetch employee profile
export async function GET(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request);
    if ("error" in auth) {
      const origin = request.headers.get("origin") || "*";
      const res = NextResponse.json(
        { error: auth.error },
        { status: auth.status }
      );
      res.headers.set("Access-Control-Allow-Origin", origin);
      res.headers.set("Vary", "Origin");
      res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
      res.headers.set(
        "Access-Control-Allow-Headers",
        "Content-Type,Authorization,x-org-code"
      );
      return res;
    }
    const { organization } = auth;
    const { searchParams } = new URL(request.url);
    const employeeId = searchParams.get("employeeId");
    if (!employeeId) {
      const origin = request.headers.get("origin") || "*";
      const res = NextResponse.json(
        { error: "Employee ID is required" },
        { status: 400 }
      );
      res.headers.set("Access-Control-Allow-Origin", origin);
      res.headers.set("Vary", "Origin");
      res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
      res.headers.set(
        "Access-Control-Allow-Headers",
        "Content-Type,Authorization,x-org-code"
      );
      return res;
    }
    // Connect to organization schema for employee and permissions
    const schemaName = `org_${organization.orgCode.toLowerCase()}`;
    const connection = await mysql.createConnection({
      host: "localhost",
      port: 3306,
      user: "erp_app",
      password: "erp_app_pass123",
      database: schemaName,
    });
    // Find employee in hrm_employees by employee_code
    const [employeeRows] = await connection.query(
      "SELECT * FROM hrm_employees WHERE employee_code = ? LIMIT 1",
      [employeeId]
    );
    const employeeRow =
      Array.isArray(employeeRows) && employeeRows.length > 0
        ? employeeRows[0]
        : null;
    if (!employeeRow) {
      await connection.end();
      const origin = request.headers.get("origin") || "*";
      const res = NextResponse.json(
        { error: "Employee not found in hrm_employees" },
        { status: 404 }
      );
      res.headers.set("Access-Control-Allow-Origin", origin);
      res.headers.set("Vary", "Origin");
      res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
      res.headers.set(
        "Access-Control-Allow-Headers",
        "Content-Type,Authorization,x-org-code"
      );
      return res;
    }
    // Cast employeeRow to any to access fields
    const emp: any = employeeRow;
    let userId = emp.user_id;
    if (!userId) {
      // fallback: try to find user by employee_code in users table
      const [userRows] = await connection.query(
        "SELECT id FROM users WHERE employee_id = ? LIMIT 1",
        [employeeId]
      );
      if (Array.isArray(userRows) && userRows.length > 0) {
        userId = (userRows[0] as any).id;
      }
    }
    let permissions = {};
    if (userId) {
      const [permissionRows] = await connection.query(
        "SELECT * FROM user_permissions WHERE user_id = ?",
        [userId]
      );
      permissions = Array.isArray(permissionRows)
        ? getUserPermissions(permissionRows)
        : {};
    }
    await connection.end();
    // Transform to employee format
    const employee = {
      id: emp.id,
      employee_id: emp.employee_code,
      first_name: emp.first_name,
      last_name: emp.last_name,
      email: emp.email,
      phone: emp.phone || "",
      position: emp.position || "",
      department: emp.department_id || "",
      level: emp.level || "",
      start_date: emp.hire_date,
      is_active: emp.is_active,
      profile_image: emp.profile_image,
      created_at: emp.created_at,
      updated_at: emp.updated_at,
    };
    const origin = request.headers.get("origin") || "*";
    const res = NextResponse.json({
      status: "success",
      employee,
      permissions,
    });
    res.headers.set("Access-Control-Allow-Origin", origin);
    res.headers.set("Vary", "Origin");
    res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
    res.headers.set(
      "Access-Control-Allow-Headers",
      "Content-Type,Authorization,x-org-code"
    );
    return res;
  } catch (error) {
    console.error("Fetch employee profile error:", error);
    const origin = request.headers.get("origin") || "*";
    const res = NextResponse.json(
      { error: "Failed to fetch employee profile" },
      { status: 500 }
    );
    res.headers.set("Access-Control-Allow-Origin", origin);
    res.headers.set("Vary", "Origin");
    res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
    res.headers.set(
      "Access-Control-Allow-Headers",
      "Content-Type,Authorization,x-org-code"
    );
    return res;
  }
}

// PUT - Update employee profile
export async function PUT(request: NextRequest) {
  try {
    const auth = await verifyTokenAndGetOrg(request);
    if ("error" in auth) {
      const origin = request.headers.get("origin") || "*";
      const res = NextResponse.json(
        { error: auth.error },
        { status: auth.status }
      );
      res.headers.set("Access-Control-Allow-Origin", origin);
      res.headers.set("Vary", "Origin");
      res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
      res.headers.set(
        "Access-Control-Allow-Headers",
        "Content-Type,Authorization,x-org-code"
      );
      return res;
    }
    const { organization, payload } = auth;
    const body = await request.json();
    const { first_name, last_name, phone, position, department, level } = body;
    // Find employee by user ID from token
    const user = await prisma.orgUser.findFirst({
      where: {
        id: payload.userId,
        orgId: organization.id,
        isActive: true,
      },
    });
    if (!user) {
      const origin = request.headers.get("origin") || "*";
      const res = NextResponse.json(
        { error: "Employee not found" },
        { status: 404 }
      );
      res.headers.set("Access-Control-Allow-Origin", origin);
      res.headers.set("Vary", "Origin");
      res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
      res.headers.set(
        "Access-Control-Allow-Headers",
        "Content-Type,Authorization,x-org-code"
      );
      return res;
    }
    // Update user
    const updatedUser = await prisma.orgUser.update({
      where: { id: user.id },
      data: {
        name: `${first_name} ${last_name}`,
        role: position || user.role,
        updatedAt: new Date(),
      },
    });
    const employee = {
      id: updatedUser.id,
      employee_id: user.email,
      first_name,
      last_name,
      email: updatedUser.email,
      phone: phone || "",
      department: department || "General",
      level: level || updatedUser.role,
      start_date: updatedUser.createdAt,
      is_active: updatedUser.isActive,
      profile_image: null,
      created_at: updatedUser.createdAt,
      updated_at: updatedUser.updatedAt,
    };
    const origin = request.headers.get("origin") || "*";
    const res = NextResponse.json({
      status: "success",
      employee,
    });
    res.headers.set("Access-Control-Allow-Origin", origin);
    res.headers.set("Vary", "Origin");
    res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
    res.headers.set(
      "Access-Control-Allow-Headers",
      "Content-Type,Authorization,x-org-code"
    );
    return res;
  } catch (error) {
    console.error("Update employee profile error:", error);
    const origin = request.headers.get("origin") || "*";
    const res = NextResponse.json(
      { error: "Failed to update employee profile" },
      { status: 500 }
    );
    res.headers.set("Access-Control-Allow-Origin", origin);
    res.headers.set("Vary", "Origin");
    res.headers.set("Access-Control-Allow-Methods", "GET,PUT,OPTIONS");
    res.headers.set(
      "Access-Control-Allow-Headers",
      "Content-Type,Authorization,x-org-code"
    );
    return res;
  }
}
