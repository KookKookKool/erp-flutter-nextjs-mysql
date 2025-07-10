import { NextRequest, NextResponse } from "next/server";
import prisma from "@/lib/prisma";
import { AuthService } from "@/lib/auth";
import { DatabaseManager } from "@/lib/database-manager";

// Add CORS headers
function addCorsHeaders(response: NextResponse) {
  response.headers.set("Access-Control-Allow-Origin", "*");
  response.headers.set(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, OPTIONS"
  );
  response.headers.set(
    "Access-Control-Allow-Headers",
    "Content-Type, Authorization, Accept"
  );
  response.headers.set("Access-Control-Max-Age", "86400");
  return response;
}

export async function OPTIONS(request: NextRequest) {
  const response = new NextResponse(null, { status: 200 });
  return addCorsHeaders(response);
}

export async function POST(request: NextRequest) {
  try {
    console.log("Registration request received");

    const body = await request.json();
    console.log("Request body:", body);

    const {
      orgName,
      orgCode,
      orgEmail,
      orgPhone,
      orgAddress,
      orgDescription,
      adminName,
      adminEmail,
      adminPassword,
      companyRegistrationNumber, // เพิ่มรับค่าจาก body
      taxId, // เพิ่มรับค่าจาก body
      businessType, // เพิ่มรับค่าจาก body
      employeeCount, // เพิ่มรับค่าจาก body
      website, // เพิ่มรับค่าจาก body
    } = body;

    // Validate required fields
    if (
      !orgName ||
      !orgCode ||
      !orgEmail ||
      !adminName ||
      !adminEmail ||
      !adminPassword
    ) {
      const response = NextResponse.json(
        { error: "กรุณากรอกข้อมูลที่จำเป็นให้ครบถ้วน" },
        { status: 400 }
      );
      return addCorsHeaders(response);
    }

    // ตรวจสอบว่า orgCode ซ้ำหรือไม่
    const existingOrg = await prisma.organization.findUnique({
      where: { orgCode: orgCode.toUpperCase() },
    });

    if (existingOrg) {
      const response = NextResponse.json(
        { error: "รหัสองค์กรนี้ถูกใช้ไปแล้ว กรุณาสร้างรหัสใหม่" },
        { status: 409 }
      );
      return addCorsHeaders(response);
    }

    // ตรวจสอบว่า email ซ้ำหรือไม่
    const existingEmail = await prisma.organization.findFirst({
      where: {
        OR: [{ orgEmail }, { adminEmail }],
      },
    });

    if (existingEmail) {
      const response = NextResponse.json(
        { error: "อีเมลนี้ถูกใช้ไปแล้ว" },
        { status: 409 }
      );
      return addCorsHeaders(response);
    }

    // Hash password
    const hashedPassword = await AuthService.hashPassword(adminPassword);

    // สร้างข้อมูลองค์กร
    const organization = await prisma.organization.create({
      data: {
        orgCode: orgCode.toUpperCase(),
        orgName,
        orgEmail,
        orgPhone,
        orgAddress,
        description: orgDescription,
        adminName,
        adminEmail,
        adminPassword: hashedPassword,
        status: "PENDING", // รอการอนุมัติ
        subscriptionPlan: "BASIC",
        companyRegistrationNumber, // เพิ่มบันทึกลง db
        taxId, // เพิ่มบันทึกลง db
        businessType, // เพิ่มบันทึกลง db
        employeeCount, // เพิ่มบันทึกลง db
        website, // เพิ่มบันทึกลง db
      },
    });

    console.log(`📝 Organization registered: ${orgCode} - ${orgName}`);

    const response = NextResponse.json({
      success: true,
      message: "ลงทะเบียนสำเร็จ! รอการอนุมัติจากผู้ดูแลระบบ",
      orgCode: organization.orgCode,
      orgId: organization.id,
    });
    return addCorsHeaders(response);
  } catch (error) {
    console.error("❌ Registration error:", error);
    const response = NextResponse.json(
      { error: "เกิดข้อผิดพลาดในการลงทะเบียน กรุณาลองใหม่อีกครั้ง" },
      { status: 500 }
    );
    return addCorsHeaders(response);
  }
}
