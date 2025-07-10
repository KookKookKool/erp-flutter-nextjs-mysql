'use client'

import { useRouter } from 'next/navigation'
import { useEffect } from 'react'

export default function HomePage() {
  const router = useRouter()

  useEffect(() => {
    // Redirect to admin panel with timeout to ensure component is mounted
    const timer = setTimeout(() => {
      router.push('/admin/login')
    }, 100)
    
    // Fallback redirect after 2 seconds
    const fallbackTimer = setTimeout(() => {
      window.location.href = '/admin/login'
    }, 2000)
    
    return () => {
      clearTimeout(timer)
      clearTimeout(fallbackTimer)
    }
  }, [router])

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 to-brown-50 flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-brown-800 mb-4">
          ERP Backend System
        </h1>
        <p className="text-brown-600 mb-8">
          ระบบจัดการ Backend สำหรับ ERP
        </p>
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600 mx-auto"></div>
        <p className="text-sm text-gray-500 mt-4">กำลังเปลี่ยนเส้นทางไปยัง Admin Panel...</p>
      </div>
    </div>
  )
}
