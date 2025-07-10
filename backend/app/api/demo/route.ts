import { NextRequest, NextResponse } from "next/server";
import prisma from "@/lib/prisma";
import { DatabaseManager } from "@/lib/database-manager";

export async function POST(request: NextRequest) {
  try {
    // Delete existing test org if exists
    const existingOrg = await prisma.organization.findUnique({
      where: { orgCode: "DEMO" },
    });

    if (existingOrg) {
      return NextResponse.json({
        message: "Demo organization already exists",
        orgCode: "DEMO",
        superAdmin: {
          email: "admin_DEMO",
          employeeId: "SADEMO",
          password: "123456",
        },
      });
    }

    console.log("🧪 Creating demo organization for Flutter testing...");

    // สร้างองค์กรทดสอบ
    const demoOrg = await prisma.organization.create({
      data: {
        orgCode: "DEMO",
        orgName: "Demo Organization",
        orgEmail: "demo@demo.com",
        orgPhone: "0123456789",
        orgAddress: "123 Demo Street",
        description: "Demo organization for Flutter testing",
        companyRegistrationNumber: "1234567890123",
        taxId: "9876543210987",
        adminName: "Demo Admin",
        adminEmail: "admin@demo.com",
        adminPassword: "temp123456",
        status: "PENDING",
        isActive: false,
      },
    });

    // อนุมัติและสร้าง Super Admin
    const dbManager = DatabaseManager.getInstance();
    const schemaName = await dbManager.createOrganizationSchema(
      demoOrg.orgCode
    );

    const adminCredentials = await dbManager.createInitialAdminUser(
      schemaName,
      {
        email: demoOrg.adminEmail,
        name: demoOrg.adminName,
        orgCode: demoOrg.orgCode,
      }
    );

    await prisma.organization.update({
      where: { id: demoOrg.id },
      data: {
        status: "APPROVED",
        isActive: true,
        approvedAt: new Date(),
        schemaName,
        subscriptionPlan: "BASIC",
        subscriptionStart: new Date(),
        subscriptionEnd: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000),
      },
    });

    return NextResponse.json({
      message: "Demo organization created successfully",
      orgCode: demoOrg.orgCode,
      superAdmin: {
        email: adminCredentials.email,
        employeeId: `SA${demoOrg.orgCode}`,
        password: adminCredentials.password,
      },
    });
  } catch (error) {
    console.error("❌ Error creating demo organization:", error);
    return NextResponse.json(
      { error: "Failed to create demo organization" },
      { status: 500 }
    );
  }
}
