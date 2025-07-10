'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'

interface Organization {
  id: string
  orgCode: string
  orgName: string
  orgEmail: string
  adminName: string
  adminEmail: string
  status: 'PENDING' | 'APPROVED' | 'REJECTED' | 'SUSPENDED' | 'EXPIRED'
  subscriptionPlan: string
  subscriptionStart: string | null
  subscriptionEnd: string | null
  createdAt: string
  approvedAt: string | null
  schemaName: string | null
  isActive: boolean
}

export default function OrganizationsPage() {
  const [organizations, setOrganizations] = useState<Organization[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [isUpdating, setIsUpdating] = useState<string | null>(null) // Track which org is being updated
  const [filter, setFilter] = useState('ALL')
  const [searchTerm, setSearchTerm] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const [totalPages, setTotalPages] = useState(1)
  const [showApprovalModal, setShowApprovalModal] = useState(false)
  const [selectedOrgId, setSelectedOrgId] = useState<string | null>(null)
  const [selectedOrgName, setSelectedOrgName] = useState('')
  const [approvalDays, setApprovalDays] = useState(7)
  const [customExpiryDate, setCustomExpiryDate] = useState('')
  const router = useRouter()

  useEffect(() => {
    // ตรวจสอบ authentication
    const token = localStorage.getItem('adminToken')
    if (!token) {
      router.push('/admin/login')
      return
    }

    fetchOrganizations()
  }, [router, filter, currentPage, searchTerm])

  const fetchOrganizations = async () => {
    try {
      const token = localStorage.getItem('adminToken')
      const params = new URLSearchParams({
        page: currentPage.toString(),
        limit: '10'
      })

      if (filter !== 'ALL') {
        params.append('status', filter)
      }

      const response = await fetch(`/api/admin/organizations?${params}`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })

      if (response.ok) {
        const data = await response.json()
        setOrganizations(data.organizations)
        setTotalPages(data.pagination.pages)
      }
    } catch (error) {
      console.error('Error fetching organizations:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleQuickApprove = async (orgId: string) => {
    // Open approval modal instead of direct approval
    const org = organizations.find(o => o.id === orgId)
    if (!org) return
    
    setSelectedOrgId(orgId)
    setSelectedOrgName(org.orgName)
    setShowApprovalModal(true)
    
    // Set default to 7 days from now
    const sevenDaysFromNow = new Date()
    sevenDaysFromNow.setDate(sevenDaysFromNow.getDate() + 7)
    setCustomExpiryDate(sevenDaysFromNow.toISOString().split('T')[0])
  }

  const handleApprovalConfirm = async () => {
    if (!selectedOrgId) return

    const expiryDate = new Date()
    if (approvalDays === 0 && customExpiryDate) {
      // Use custom date
      expiryDate.setTime(new Date(customExpiryDate).getTime())
    } else {
      // Use days from now
      expiryDate.setDate(expiryDate.getDate() + approvalDays)
    }

    setIsUpdating(selectedOrgId)
    try {
      const token = localStorage.getItem('adminToken')
      
      const response = await fetch(`/api/admin/organizations/${selectedOrgId}`, {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          action: 'approve',
          subscriptionPlan: 'BASIC',
          subscriptionEnd: expiryDate.toISOString()
        })
      })

      if (response.ok) {
        const result = await response.json()
        alert(result.message)
        fetchOrganizations()
        setShowApprovalModal(false)
        setSelectedOrgId(null)
      } else {
        const error = await response.json()
        alert(`เกิดข้อผิดพลาด: ${error.error}`)
      }
    } catch (error) {
      alert('เกิดข้อผิดพลาดในการเชื่อมต่อ')
    } finally {
      setIsUpdating(null)
    }
  }

  const handleReject = async (orgId: string) => {
    if (!confirm('คุณต้องการปฏิเสธองค์กรนี้หรือไม่?')) return

    setIsUpdating(orgId)
    try {
      const token = localStorage.getItem('adminToken')
      const response = await fetch(`/api/admin/organizations/${orgId}`, {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ action: 'reject' })
      })

      if (response.ok) {
        const result = await response.json()
        alert(result.message)
        fetchOrganizations()
      } else {
        const error = await response.json()
        alert(`เกิดข้อผิดพลาด: ${error.error}`)
      }
    } catch (error) {
      alert('เกิดข้อผิดพลาดในการเชื่อมต่อ')
    } finally {
      setIsUpdating(null)
    }
  }

  const getExpiryStatus = (subscriptionEnd: string | null, status: string) => {
    if (!subscriptionEnd || status !== 'APPROVED') return null
    
    const today = new Date()
    const expiryDate = new Date(subscriptionEnd)
    const diffTime = expiryDate.getTime() - today.getTime()
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
    
    if (diffDays < 0) {
      return { status: 'expired', days: Math.abs(diffDays), color: 'text-red-600' }
    } else if (diffDays <= 30) {
      return { status: 'warning', days: diffDays, color: 'text-yellow-600' }
    } else {
      return { status: 'normal', days: diffDays, color: 'text-green-600' }
    }
  }

  const getStatusBadge = (status: string, isActive: boolean) => {
    if (status === 'PENDING') {
      return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">รอการอนุมัติ</span>
    }
    if (status === 'APPROVED' && isActive) {
      return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">ใช้งานอยู่</span>
    }
    if (status === 'REJECTED') {
      return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">ปฏิเสธ</span>
    }
    if (status === 'SUSPENDED') {
      return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">ระงับการใช้งาน</span>
    }
    if (status === 'EXPIRED') {
      return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">หมดอายุ</span>
    }
    return <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">{status}</span>
  }

  const filteredOrganizations = organizations.filter(org => 
    org.orgName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    org.orgCode.toLowerCase().includes(searchTerm.toLowerCase()) ||
    org.adminName.toLowerCase().includes(searchTerm.toLowerCase())
  )

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-full mx-auto px-2 sm:px-4 lg:px-6">
          <div className="flex justify-between h-16">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => router.push('/admin/dashboard')}
                className="text-gray-500 hover:text-gray-700"
              >
                ← กลับ
              </button>
              <h1 className="text-xl font-semibold text-gray-900">จัดการองค์กร</h1>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-full mx-auto py-6 px-2 sm:px-4 lg:px-6">
        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
          <div className="card p-6">
            <div className="flex items-center">
              <div className="p-2 bg-blue-100 rounded-lg">
                <div className="w-6 h-6 bg-blue-600 rounded"></div>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">ทั้งหมด</p>
                <p className="text-2xl font-semibold text-gray-900">{organizations.length}</p>
              </div>
            </div>
          </div>
          
          <div className="card p-6">
            <div className="flex items-center">
              <div className="p-2 bg-yellow-100 rounded-lg">
                <div className="w-6 h-6 bg-yellow-600 rounded"></div>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">รอการอนุมัติ</p>
                <p className="text-2xl font-semibold text-gray-900">
                  {organizations.filter(org => org.status === 'PENDING').length}
                </p>
              </div>
            </div>
          </div>
          
          <div className="card p-6">
            <div className="flex items-center">
              <div className="p-2 bg-green-100 rounded-lg">
                <div className="w-6 h-6 bg-green-600 rounded"></div>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">ใช้งานอยู่</p>
                <p className="text-2xl font-semibold text-gray-900">
                  {organizations.filter(org => org.status === 'APPROVED' && org.isActive).length}
                </p>
              </div>
            </div>
          </div>
          
          <div className="card p-6">
            <div className="flex items-center">
              <div className="p-2 bg-red-100 rounded-lg">
                <div className="w-6 h-6 bg-red-600 rounded"></div>
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">ใกล้หมดอายุ</p>
                <p className="text-2xl font-semibold text-gray-900">
                  {organizations.filter(org => {
                    const expiry = getExpiryStatus(org.subscriptionEnd, org.status)
                    return expiry && (expiry.status === 'warning' || expiry.status === 'expired')
                  }).length}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Filters */}
        <div className="card p-6 mb-6">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1">
              <input
                type="text"
                placeholder="ค้นหาองค์กร..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md"
              />
            </div>
            <div>
              <select
                value={filter}
                onChange={(e) => setFilter(e.target.value)}
                className="px-3 py-2 border border-gray-300 rounded-md"
              >
                <option value="ALL">ทั้งหมด</option>
                <option value="PENDING">รอการอนุมัติ</option>
                <option value="APPROVED">อนุมัติแล้ว</option>
                <option value="REJECTED">ปฏิเสธ</option>
                <option value="SUSPENDED">ระงับการใช้งาน</option>
                <option value="EXPIRED">หมดอายุ</option>
              </select>
            </div>
          </div>
        </div>

        {/* Organizations Table */}
        <div className="card">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">
              รายชื่อองค์กร ({filteredOrganizations.length})
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full table-auto">
              <thead>
                <tr>
                  <th className="w-32">รหัสองค์กร</th>
                  <th className="w-64">ชื่อองค์กร</th>
                  <th className="w-48">ผู้ดูแล</th>
                  <th className="w-32">สถานะ</th>
                  <th className="w-32">วันที่สมัคร</th>
                  <th className="w-40">วันหมดอายุ</th>
                  <th className="w-64">การจัดการ</th>
                </tr>
              </thead>
              <tbody>
                {filteredOrganizations.map((org) => (
                  <tr key={org.id}>
                    <td className="font-mono text-sm">{org.orgCode}</td>
                    <td>
                      <div>
                        <div className="font-medium">{org.orgName}</div>
                        <div className="text-sm text-gray-500">{org.orgEmail}</div>
                      </div>
                    </td>
                    <td>
                      <div>
                        <div className="font-medium">{org.adminName}</div>
                        <div className="text-sm text-gray-500">{org.adminEmail}</div>
                      </div>
                    </td>
                    <td>{getStatusBadge(org.status, org.isActive)}</td>
                    <td className="text-sm">
                      {new Date(org.createdAt).toLocaleDateString('th-TH')}
                    </td>
                    <td className="text-sm">
                      {org.subscriptionEnd ? (
                        <div>
                          <div>{new Date(org.subscriptionEnd).toLocaleDateString('th-TH')}</div>
                          {getExpiryStatus(org.subscriptionEnd, org.status) && (
                            <div className={`text-xs ${getExpiryStatus(org.subscriptionEnd, org.status)?.color}`}>
                              {getExpiryStatus(org.subscriptionEnd, org.status)?.status === 'expired' 
                                ? `หมดอายุแล้ว ${getExpiryStatus(org.subscriptionEnd, org.status)?.days} วัน`
                                : getExpiryStatus(org.subscriptionEnd, org.status)?.status === 'warning'
                                ? `เหลือ ${getExpiryStatus(org.subscriptionEnd, org.status)?.days} วัน`
                                : `เหลือ ${getExpiryStatus(org.subscriptionEnd, org.status)?.days} วัน`
                              }
                            </div>
                          )}
                        </div>
                      ) : '-'}
                    </td>
                    <td>
                      <div className="flex flex-wrap gap-1">
                        {org.status === 'PENDING' && (
                          <>
                            <button
                              onClick={() => handleQuickApprove(org.id)}
                              disabled={isUpdating === org.id}
                              className="px-2 py-1 text-xs bg-green-600 text-white rounded hover:bg-green-700 disabled:opacity-50"
                            >
                              {isUpdating === org.id ? 'รอ...' : 'อนุมัติ'}
                            </button>
                            <button
                              onClick={() => handleReject(org.id)}
                              disabled={isUpdating === org.id}
                              className="px-2 py-1 text-xs bg-red-600 text-white rounded hover:bg-red-700 disabled:opacity-50"
                            >
                              {isUpdating === org.id ? 'รอ...' : 'ปฏิเสธ'}
                            </button>
                          </>
                        )}
                        
                        {org.status === 'APPROVED' && org.isActive && (
                          <>
                            {getExpiryStatus(org.subscriptionEnd, org.status)?.status === 'warning' && (
                              <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                ใกล้หมดอายุ
                              </span>
                            )}
                            {getExpiryStatus(org.subscriptionEnd, org.status)?.status === 'expired' && (
                              <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
                                หมดอายุ
                              </span>
                            )}
                          </>
                        )}

                        {org.status === 'REJECTED' && (
                          <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
                            ถูกปฏิเสธ
                          </span>
                        )}

                        {org.status === 'SUSPENDED' && (
                          <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
                            ระงับการใช้งาน
                          </span>
                        )}

                        {org.status === 'EXPIRED' && (
                          <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
                            หมดอายุ
                          </span>
                        )}
                        
                        <button
                          onClick={() => router.push(`/admin/organizations/${org.id}`)}
                          className="px-2 py-1 text-xs bg-blue-600 text-white rounded hover:bg-blue-700"
                        >
                          จัดการ
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="px-6 py-4 border-t border-gray-200">
              <div className="flex justify-center space-x-2">
                {Array.from({ length: totalPages }, (_, i) => i + 1).map(page => (
                  <button
                    key={page}
                    onClick={() => setCurrentPage(page)}
                    className={`px-3 py-1 text-sm rounded ${
                      currentPage === page
                        ? 'bg-primary-600 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    }`}
                  >
                    {page}
                  </button>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Approval Modal */}
      {showApprovalModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md">
            <h3 className="text-lg font-medium text-gray-900 mb-4">
              อนุมัติองค์กร: {selectedOrgName}
            </h3>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  ระยะเวลาการใช้งาน
                </label>
                <div className="space-y-2">
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="approvalType"
                      value="7"
                      checked={approvalDays === 7}
                      onChange={() => setApprovalDays(7)}
                      className="mr-2"
                    />
                    <span>7 วัน (ทดลองใช้)</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="approvalType"
                      value="30"
                      checked={approvalDays === 30}
                      onChange={() => setApprovalDays(30)}
                      className="mr-2"
                    />
                    <span>30 วัน (1 เดือน)</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="approvalType"
                      value="90"
                      checked={approvalDays === 90}
                      onChange={() => setApprovalDays(90)}
                      className="mr-2"
                    />
                    <span>90 วัน (3 เดือน)</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="approvalType"
                      value="365"
                      checked={approvalDays === 365}
                      onChange={() => setApprovalDays(365)}
                      className="mr-2"
                    />
                    <span>365 วัน (1 ปี)</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="approvalType"
                      value="0"
                      checked={approvalDays === 0}
                      onChange={() => setApprovalDays(0)}
                      className="mr-2"
                    />
                    <span>กำหนดเอง</span>
                  </label>
                </div>
              </div>

              {approvalDays === 0 && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    วันหมดอายุ
                  </label>
                  <input
                    type="date"
                    value={customExpiryDate}
                    onChange={(e) => setCustomExpiryDate(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md"
                    min={new Date().toISOString().split('T')[0]}
                  />
                </div>
              )}

              <div className="bg-blue-50 p-3 rounded-md">
                <p className="text-sm text-blue-800">
                  <strong>วันหมดอายุ:</strong> {
                    approvalDays === 0 && customExpiryDate
                      ? new Date(customExpiryDate).toLocaleDateString('th-TH')
                      : (() => {
                          const date = new Date()
                          date.setDate(date.getDate() + approvalDays)
                          return date.toLocaleDateString('th-TH')
                        })()
                  }
                </p>
              </div>
            </div>

            <div className="flex space-x-3 mt-6">
              <button
                onClick={handleApprovalConfirm}
                disabled={isUpdating === selectedOrgId || (approvalDays === 0 && !customExpiryDate)}
                className="flex-1 btn btn-success disabled:opacity-50"
              >
                {isUpdating === selectedOrgId ? 'กำลังอนุมัติ...' : 'อนุมัติ'}
              </button>
              <button
                onClick={() => {
                  setShowApprovalModal(false)
                  setSelectedOrgId(null)
                  setApprovalDays(7)
                }}
                disabled={isUpdating === selectedOrgId}
                className="flex-1 btn btn-secondary"
              >
                ยกเลิก
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
