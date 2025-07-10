import { PrismaClient } from '@prisma/client'
import { AuthService } from '../lib/auth'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Starting seed...')

  // สร้าง Admin User เริ่มต้น
  const adminEmail = process.env.ADMIN_EMAIL || 'admin@sunerp.com'
  const adminPassword = process.env.ADMIN_PASSWORD || 'admin123'
  
  const hashedPassword = await AuthService.hashPassword(adminPassword)

  const admin = await prisma.adminUser.upsert({
    where: { email: adminEmail },
    update: {},
    create: {
      email: adminEmail,
      name: 'System Administrator',
      password: hashedPassword,
      role: 'SUPER_ADMIN'
    }
  })

  console.log(`✅ Created admin user: ${admin.email}`)

  // สร้าง System Settings เริ่มต้น
  const settings = [
    {
      key: 'REGISTRATION_ENABLED',
      value: 'true',
      description: 'เปิด/ปิดการลงทะเบียนขององค์กรใหม่'
    },
    {
      key: 'AUTO_APPROVE_ORGANIZATIONS',
      value: 'false',
      description: 'อนุมัติองค์กรใหม่อัตโนมัติ'
    },
    {
      key: 'DEFAULT_SUBSCRIPTION_PLAN',
      value: 'BASIC',
      description: 'แพลนสมาชิกเริ่มต้น'
    },
    {
      key: 'DEFAULT_SUBSCRIPTION_DURATION',
      value: '365',
      description: 'ระยะเวลาสมาชิกเริ่มต้น (วัน)'
    }
  ]

  for (const setting of settings) {
    await prisma.systemSetting.upsert({
      where: { key: setting.key },
      update: { value: setting.value },
      create: setting
    })
  }

  console.log(`✅ Created ${settings.length} system settings`)

  // สร้างองค์กรตัวอย่างสำหรับทดสอบ - สถานะ PENDING
  const testOrg = await prisma.organization.upsert({
    where: { orgCode: 'ORG2501101200001' },
    update: {},
    create: {
      orgCode: 'ORG2501101200001',
      orgName: 'บริษัท ตัวอย่าง จำกัด',
      orgEmail: 'demo@example.com',
      orgPhone: '02-123-4567',
      orgAddress: '123 ถนนตัวอย่าง แขวงตัวอย่าง เขตตัวอย่าง กรุงเทพฯ 10100',
      description: 'องค์กรตัวอย่างสำหรับทดสอบระบบ',
      adminName: 'ผู้ดูแลระบบ',
      adminEmail: 'admin@example.com',
      adminPassword: await AuthService.hashPassword('demo123'),
      status: 'PENDING',
      subscriptionPlan: 'BASIC'
    }
  })

  console.log(`✅ Created test organization (PENDING): ${testOrg.orgCode}`)

  // สร้างองค์กรตัวอย่างที่อนุมัติแล้ว
  const approvedOrg1 = await prisma.organization.upsert({
    where: { orgCode: 'DEMO001' },
    update: {},
    create: {
      orgCode: 'DEMO001',
      orgName: 'บริษัท เดโม หนึ่ง จำกัด',
      orgEmail: 'demo1@testorg.com',
      orgPhone: '02-111-1111',
      orgAddress: '456 ถนนสุขุมวิท กรุงเทพฯ 10110',
      description: 'องค์กรตัวอย่างที่อนุมัติแล้ว',
      adminName: 'ผู้จัดการ เดโม',
      adminEmail: 'manager@demo1.com',
      adminPassword: await AuthService.hashPassword('demo123'),
      status: 'APPROVED',
      isActive: true,
      subscriptionPlan: 'BASIC',
      subscriptionStart: new Date(),
      subscriptionEnd: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000), // 1 ปีจากตอนนี้
      approvedAt: new Date(),
      approvedBy: admin.id
    }
  })

  console.log(`✅ Created approved organization: ${approvedOrg1.orgCode}`)

  // สร้างองค์กรตัวอย่างที่อนุมัติแล้ว อีกแห่ง
  const approvedOrg2 = await prisma.organization.upsert({
    where: { orgCode: 'DEMO002' },
    update: {},
    create: {
      orgCode: 'DEMO002',
      orgName: 'หจก. เดโม สอง',
      orgEmail: 'demo2@testorg.com',
      orgPhone: '02-222-2222',
      orgAddress: '789 ถนนพระราม 4 กรุงเทพฯ 10500',
      description: 'องค์กรตัวอย่างที่อนุมัติแล้ว สำหรับแพลน STANDARD',
      adminName: 'ผู้อำนวยการ เดโม',
      adminEmail: 'director@demo2.com',
      adminPassword: await AuthService.hashPassword('demo456'),
      status: 'APPROVED',
      isActive: true,
      subscriptionPlan: 'STANDARD',
      subscriptionStart: new Date(),
      subscriptionEnd: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000), // 1 ปีจากตอนนี้
      approvedAt: new Date(),
      approvedBy: admin.id
    }
  })

  console.log(`✅ Created approved organization: ${approvedOrg2.orgCode}`)

  // สร้างองค์กรที่หมดอายุแล้ว
  const expiredOrg = await prisma.organization.upsert({
    where: { orgCode: 'EXPIRED001' },
    update: {},
    create: {
      orgCode: 'EXPIRED001',
      orgName: 'บริษัท หมดอายุ จำกัด',
      orgEmail: 'expired@testorg.com',
      orgPhone: '02-999-9999',
      orgAddress: '999 ถนนเจริญกรุง กรุงเทพฯ 10500',
      description: 'องค์กรที่หมดอายุแล้ว',
      adminName: 'ผู้จัดการ หมดอายุ',
      adminEmail: 'manager@expired.com',
      adminPassword: await AuthService.hashPassword('expired123'),
      status: 'APPROVED',
      isActive: true,
      subscriptionPlan: 'BASIC',
      subscriptionStart: new Date(Date.now() - 400 * 24 * 60 * 60 * 1000), // 400 วันที่แล้ว
      subscriptionEnd: new Date(Date.now() - 35 * 24 * 60 * 60 * 1000), // หมดอายุ 35 วันที่แล้ว
      approvedAt: new Date(Date.now() - 400 * 24 * 60 * 60 * 1000),
      approvedBy: admin.id
    }
  })

  console.log(`✅ Created expired organization: ${expiredOrg.orgCode}`)

  console.log('🎉 Seed completed!')
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
