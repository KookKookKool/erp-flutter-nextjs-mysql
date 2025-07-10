import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { NextRequest } from 'next/server'
import prisma from './prisma'

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key'

export interface AdminTokenPayload {
  adminId?: string
  userId?: string
  orgId?: string
  orgCode?: string
  email: string
  name?: string
  role: string
  type?: 'admin' | 'org_admin' | 'org_user'
}

// Verify admin token from request
export async function verifyAdmin(request: NextRequest) {
  try {
    const authHeader = request.headers.get('authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return null
    }

    const token = authHeader.substring(7)
    const payload = AuthService.verifyToken(token)
    if (!payload) {
      return null
    }

    // ตรวจสอบว่า admin ยังมีอยู่ในระบบ
    const admin = await prisma.adminUser.findUnique({
      where: { id: payload.adminId }
    })

    if (!admin || !admin.isActive) {
      return null
    }

    return admin
  } catch (error) {
    console.error('Error verifying admin:', error)
    return null
  }
}

export class AuthService {
  static async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 12)
  }

  static async comparePassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword)
  }

  static async verifyPassword(password: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(password, hashedPassword)
  }

  static generateToken(payload: AdminTokenPayload): string {
    return jwt.sign(payload, JWT_SECRET, { expiresIn: '24h' })
  }

  static verifyToken(token: string): AdminTokenPayload | null {
    try {
      return jwt.verify(token, JWT_SECRET) as AdminTokenPayload
    } catch (error) {
      return null
    }
  }

  static generateOrgCode(): string {
    const now = new Date()
    const year = now.getFullYear().toString().substring(2) // 25
    const month = (now.getMonth() + 1).toString().padStart(2, '0')
    const day = now.getDate().toString().padStart(2, '0')
    const hour = now.getHours().toString().padStart(2, '0')
    const minute = now.getMinutes().toString().padStart(2, '0')
    
    // สุ่มเลข 3 หลัก
    const random = Math.floor(100 + Math.random() * 900).toString()
    
    return `ORG${year}${month}${day}${hour}${minute}${random}`
  }
}
