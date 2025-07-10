'use client'

import { useState, useEffect } from 'react'

// Define types locally to avoid import issues
interface ModuleStructure {
  [moduleKey: string]: {
    label: string
    icon: string
    submodules: {
      [submoduleKey: string]: {
        label: string
        description: string
        permissions: string[]
      }
    }
  }
}

const MODULE_STRUCTURE: ModuleStructure = {
  hrm: {
    label: 'Human Resource Management',
    icon: 'people',
    submodules: {
      employee: {
        label: 'Employee Management',
        description: 'Manage employee information and records',
        permissions: ['read', 'create', 'update', 'delete', 'export', 'import']
      },
      attendance: {
        label: 'Attendance Tracking',
        description: 'Track and manage employee attendance',
        permissions: ['read', 'create', 'update', 'delete', 'approve', 'export']
      },
      payroll: {
        label: 'Payroll Management',
        description: 'Manage salaries, bonuses, and benefits',
        permissions: ['read', 'create', 'update', 'delete', 'approve', 'export']
      },
      leave: {
        label: 'Leave Management',
        description: 'Manage leave requests and approvals',
        permissions: ['read', 'create', 'update', 'delete', 'approve', 'export']
      },
      announcement: {
        label: 'Announcements',
        description: 'Manage company announcements and news',
        permissions: ['read', 'create', 'update', 'delete']
      }
    }
  },
  accounting: {
    label: 'Accounting',
    icon: 'account_balance',
    submodules: {
      income: {
        label: 'Income Management',
        description: 'Manage income and revenue tracking',
        permissions: ['read', 'create', 'update', 'delete', 'export']
      },
      finance: {
        label: 'Financial Management',
        description: 'Manage financial records and transactions',
        permissions: ['read', 'create', 'update', 'delete', 'approve', 'export']
      },
      report: {
        label: 'Financial Reports',
        description: 'Generate and view financial reports',
        permissions: ['read', 'export']
      }
    }
  },
  sales: {
    label: 'Sales Management',
    icon: 'shopping_cart',
    submodules: {
      customer: {
        label: 'Customer Management',
        description: 'Manage customer information and relationships',
        permissions: ['read', 'create', 'update', 'delete', 'export', 'import']
      },
      quotation: {
        label: 'Quotation Management',
        description: 'Create and manage sales quotations',
        permissions: ['read', 'create', 'update', 'delete', 'approve', 'export']
      },
      report: {
        label: 'Sales Reports',
        description: 'Generate and view sales reports',
        permissions: ['read', 'export']
      }
    }
  },
  inventory: {
    label: 'Inventory Management',
    icon: 'inventory',
    submodules: {
      product: {
        label: 'Product Management',
        description: 'Manage product catalog and information',
        permissions: ['read', 'create', 'update', 'delete', 'export', 'import']
      },
      stock: {
        label: 'Stock Management',
        description: 'Manage inventory levels and stock movements',
        permissions: ['read', 'create', 'update', 'delete', 'export']
      },
      transaction: {
        label: 'Inventory Transactions',
        description: 'Track inventory movements and transactions',
        permissions: ['read', 'create', 'update', 'delete', 'export']
      }
    }
  },
  purchasing: {
    label: 'Purchasing',
    icon: 'shopping_bag',
    submodules: {
      order: {
        label: 'Purchase Orders',
        description: 'Create and manage purchase orders',
        permissions: ['read', 'create', 'update', 'delete', 'approve', 'export']
      },
      supplier: {
        label: 'Supplier Management',
        description: 'Manage supplier information and relationships',
        permissions: ['read', 'create', 'update', 'delete', 'export', 'import']
      },
      report: {
        label: 'Purchase Reports',
        description: 'Generate and view purchase reports',
        permissions: ['read', 'export']
      }
    }
  },
  crm: {
    label: 'Customer Relationship Management',
    icon: 'contacts',
    submodules: {
      customer: {
        label: 'Customer Management',
        description: 'Manage customer relationships and data',
        permissions: ['read', 'create', 'update', 'delete', 'export', 'import']
      },
      history: {
        label: 'Customer History',
        description: 'View customer interaction history',
        permissions: ['read', 'export']
      },
      activity: {
        label: 'Customer Activities',
        description: 'Track and manage customer activities',
        permissions: ['read', 'create', 'update', 'delete', 'export']
      }
    }
  },
  project: {
    label: 'Project Management',
    icon: 'assignment',
    submodules: {
      task: {
        label: 'Task Management',
        description: 'Create and manage project tasks',
        permissions: ['read', 'create', 'update', 'delete', 'export']
      },
      status: {
        label: 'Project Status',
        description: 'Track project progress and status',
        permissions: ['read', 'update', 'export']
      },
      notification: {
        label: 'Project Notifications',
        description: 'Manage project notifications and alerts',
        permissions: ['read', 'create', 'update', 'delete']
      }
    }
  },
  settings: {
    label: 'System Settings',
    icon: 'settings',
    submodules: {
      user: {
        label: 'User Management',
        description: 'Manage system users and accounts',
        permissions: ['read', 'create', 'update', 'delete', 'export']
      },
      permission: {
        label: 'Permission Management',
        description: 'Manage user roles and permissions',
        permissions: ['read', 'create', 'update', 'delete']
      },
      config: {
        label: 'System Configuration',
        description: 'Configure system settings and preferences',
        permissions: ['read', 'update']
      },
      notification: {
        label: 'Notification Settings',
        description: 'Configure notification preferences',
        permissions: ['read', 'update']
      }
    }
  }
}

const PERMISSION_LABELS: { [key: string]: string } = {
  read: 'View',
  create: 'Create',
  update: 'Edit',
  delete: 'Delete',
  approve: 'Approve',
  export: 'Export',
  import: 'Import'
}

interface PermissionModalProps {
  isOpen: boolean
  onClose: () => void
  user: {
    id: string
    name: string
    email: string
    role: string
  }
  orgId: string
  onSave: () => void
}

interface UserPermissions {
  [module: string]: {
    [submodule: string]: {
      [permission: string]: boolean
    }
  }
}

export default function PermissionModal({ isOpen, onClose, user, orgId, onSave }: PermissionModalProps) {
  const [permissions, setPermissions] = useState<UserPermissions>({})
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [selectedModules, setSelectedModules] = useState<string[]>([])

  useEffect(() => {
    if (isOpen && user.id) {
      fetchUserPermissions()
    }
  }, [isOpen, user.id])

  const fetchUserPermissions = async () => {
    setLoading(true)
    try {
      const response = await fetch(`/api/admin/organizations/${orgId}/users/${user.id}/permissions`)
      if (response.ok) {
        const data = await response.json()
        setPermissions(data.permissions || {})
        
        // Set selected modules based on existing permissions
        const modules = Object.keys(data.permissions || {})
        setSelectedModules(modules)
        
        // If no existing permissions, default to empty state
        if (modules.length === 0) {
          setSelectedModules([])
        }
      } else {
        console.error('Failed to fetch permissions')
        // Initialize with empty permissions
        setPermissions({})
        setSelectedModules([])
      }
    } catch (error) {
      console.error('Error fetching permissions:', error)
      // Initialize with empty permissions
      setPermissions({})
      setSelectedModules([])
    } finally {
      setLoading(false)
    }
  }

  const handleModuleToggle = (moduleKey: string) => {
    setSelectedModules(prev => {
      const newSelected = prev.includes(moduleKey)
        ? prev.filter(m => m !== moduleKey)
        : [...prev, moduleKey]
      
      // Update permissions state
      setPermissions(prev => {
        const newPermissions = { ...prev }
        
        if (!newSelected.includes(moduleKey)) {
          // Remove module from permissions
          delete newPermissions[moduleKey]
        } else if (!newPermissions[moduleKey]) {
          // Add module with default permissions
          newPermissions[moduleKey] = {}
          const moduleStructure = MODULE_STRUCTURE[moduleKey as keyof typeof MODULE_STRUCTURE]
          
          if (moduleStructure && moduleStructure.submodules) {
            Object.keys(moduleStructure.submodules).forEach(submoduleKey => {
              newPermissions[moduleKey][submoduleKey] = {
                read: false,
                create: false,
                update: false,
                delete: false,
                approve: false,
                export: false,
                import: false
              }
            })
          }
        }
        
        return newPermissions
      })
      
      return newSelected
    })
  }

  const handlePermissionChange = (module: string, submodule: string, permission: string, granted: boolean) => {
    setPermissions(prev => ({
      ...prev,
      [module]: {
        ...prev[module],
        [submodule]: {
          ...prev[module]?.[submodule],
          [permission]: granted
        }
      }
    }))
  }

  const handleSelectAllModule = (moduleKey: string, granted: boolean) => {
    const moduleStructure = MODULE_STRUCTURE[moduleKey as keyof typeof MODULE_STRUCTURE]
    
    if (!moduleStructure) {
      console.warn(`Module structure not found for key: ${moduleKey}`)
      return
    }
    
    setPermissions(prev => {
      const newPermissions = { ...prev }
      
      if (!newPermissions[moduleKey]) {
        newPermissions[moduleKey] = {}
      }
      
      Object.entries(moduleStructure.submodules || {}).forEach(([submoduleKey, submodule]) => {
        newPermissions[moduleKey][submoduleKey] = {}
        ;(submodule.permissions || []).forEach((permission: string) => {
          newPermissions[moduleKey][submoduleKey][permission] = granted
        })
      })
      
      return newPermissions
    })
  }

  const handleSelectAllSubmodule = (moduleKey: string, submoduleKey: string, granted: boolean) => {
    const moduleStructure = MODULE_STRUCTURE[moduleKey as keyof typeof MODULE_STRUCTURE]
    
    if (!moduleStructure || !moduleStructure.submodules || !moduleStructure.submodules[submoduleKey]) {
      console.warn(`Submodule not found for key: ${moduleKey}.${submoduleKey}`)
      return
    }
    
    const submodule = moduleStructure.submodules[submoduleKey]
    
    setPermissions(prev => ({
      ...prev,
      [moduleKey]: {
        ...prev[moduleKey],
        [submoduleKey]: {
          ...prev[moduleKey]?.[submoduleKey],
          ...Object.fromEntries((submodule.permissions || []).map((permission: string) => [permission, granted]))
        }
      }
    }))
  }

  const handleSave = async () => {
    setSaving(true)
    try {
      const response = await fetch(`/api/admin/organizations/${orgId}/users/${user.id}/permissions`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ permissions }),
      })

      if (response.ok) {
        onSave()
        onClose()
      } else {
        console.error('Failed to save permissions')
      }
    } catch (error) {
      console.error('Error saving permissions:', error)
    } finally {
      setSaving(false)
    }
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-6xl w-full max-h-[90vh] overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-medium text-gray-900">
            Manage Permissions - {user.name}
          </h3>
          <p className="text-sm text-gray-500">{user.email} ({user.role})</p>
        </div>

        <div className="p-6 overflow-y-auto max-h-[calc(90vh-140px)]">
          {loading ? (
            <div className="flex items-center justify-center py-8">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            </div>
          ) : (
            <div className="space-y-6">
              {/* Module Selection */}
              <div className="mb-6">
                <h4 className="text-md font-medium text-gray-900 mb-3">Select Modules</h4>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                  {Object.entries(MODULE_STRUCTURE).map(([moduleKey, module]) => (
                    <label key={moduleKey} className="flex items-center space-x-2 p-3 border rounded-lg hover:bg-gray-50">
                      <input
                        type="checkbox"
                        checked={selectedModules.includes(moduleKey)}
                        onChange={() => handleModuleToggle(moduleKey)}
                        className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                      />
                      <div>
                        <div className="text-sm font-medium text-gray-900">{module.label}</div>
                      </div>
                    </label>
                  ))}
                </div>
              </div>

              {/* Permission Details for Selected Modules */}
              {selectedModules.map(moduleKey => {
                const module = MODULE_STRUCTURE[moduleKey as keyof typeof MODULE_STRUCTURE]
                
                // ถ้าไม่พบ module ให้ข้าม
                if (!module) {
                  console.warn(`Module not found for key: ${moduleKey}`)
                  return null
                }
                
                return (
                  <div key={moduleKey} className="border border-gray-200 rounded-lg">
                    <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
                      <div className="flex items-center justify-between">
                        <h4 className="text-md font-medium text-gray-900">{module.label}</h4>
                        <div className="flex space-x-2">
                          <button
                            type="button"
                            onClick={() => handleSelectAllModule(moduleKey, true)}
                            className="text-xs px-2 py-1 bg-green-100 text-green-800 rounded hover:bg-green-200"
                          >
                            Select All
                          </button>
                          <button
                            type="button"
                            onClick={() => handleSelectAllModule(moduleKey, false)}
                            className="text-xs px-2 py-1 bg-red-100 text-red-800 rounded hover:bg-red-200"
                          >
                            Deselect All
                          </button>
                        </div>
                      </div>
                    </div>

                    <div className="p-4 space-y-4">
                      {Object.entries(module.submodules || {}).map(([submoduleKey, submodule]) => (
                        <div key={submoduleKey} className="border border-gray-100 rounded-lg p-3">
                          <div className="flex items-center justify-between mb-3">
                            <div>
                              <h5 className="text-sm font-medium text-gray-900">{submodule.label}</h5>
                              <p className="text-xs text-gray-500">{submodule.description}</p>
                            </div>
                            <div className="flex space-x-2">
                              <button
                                type="button"
                                onClick={() => handleSelectAllSubmodule(moduleKey, submoduleKey, true)}
                                className="text-xs px-2 py-1 bg-blue-100 text-blue-800 rounded hover:bg-blue-200"
                              >
                                All
                              </button>
                              <button
                                type="button"
                                onClick={() => handleSelectAllSubmodule(moduleKey, submoduleKey, false)}
                                className="text-xs px-2 py-1 bg-gray-100 text-gray-800 rounded hover:bg-gray-200"
                              >
                                None
                              </button>
                            </div>
                          </div>

                          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-2">
                            {submodule.permissions.map((permission: string) => (
                              <label key={permission} className="flex items-center space-x-1">
                                <input
                                  type="checkbox"
                                  checked={permissions[moduleKey]?.[submoduleKey]?.[permission] || false}
                                  onChange={(e) => handlePermissionChange(moduleKey, submoduleKey, permission, e.target.checked)}
                                  className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                                />
                                <span className="text-xs text-gray-700">
                                  {PERMISSION_LABELS[permission] || permission}
                                </span>
                              </label>
                            ))}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )
              })}
            </div>
          )}
        </div>

        <div className="px-6 py-4 border-t border-gray-200 flex justify-end space-x-3">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
            disabled={saving}
          >
            Cancel
          </button>
          <button
            type="button"
            onClick={handleSave}
            disabled={saving}
            className="px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md hover:bg-blue-700 disabled:opacity-50"
          >
            {saving ? 'Saving...' : 'Save Permissions'}
          </button>
        </div>
      </div>
    </div>
  )
}
