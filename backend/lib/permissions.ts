import { v4 as uuidv4 } from 'uuid'

// Permission definitions for HRM module
export interface Permission {
  read: boolean
  create: boolean
  update: boolean
  delete: boolean
  approve?: boolean
  export?: boolean
  import?: boolean
}

export interface ModulePermissions {
  [subModule: string]: Permission
}

export interface UserPermissions {
  [module: string]: ModulePermissions
}

// Module structure based on Flutter frontend
export const MODULE_STRUCTURE = {
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

// Permission action labels for UI
export const PERMISSION_LABELS = {
  read: 'View',
  create: 'Create',
  update: 'Edit',
  delete: 'Delete',
  approve: 'Approve',
  export: 'Export',
  import: 'Import'
}

// Default role templates
export const DEFAULT_ROLE_PERMISSIONS = {
  ADMIN: {
    hrm: {
      employee: { read: true, create: true, update: true, delete: true, export: true, import: true },
      attendance: { read: true, create: true, update: true, delete: true, approve: true, export: true },
      payroll: { read: true, create: true, update: true, delete: true, approve: true, export: true },
      leave: { read: true, create: true, update: true, delete: true, approve: true, export: true },
      announcement: { read: true, create: true, update: true, delete: true }
    },
    accounting: {
      income: { read: true, create: true, update: true, delete: true, export: true },
      finance: { read: true, create: true, update: true, delete: true, approve: true, export: true },
      report: { read: true, export: true }
    },
    sales: {
      customer: { read: true, create: true, update: true, delete: true, export: true, import: true },
      quotation: { read: true, create: true, update: true, delete: true, approve: true, export: true },
      report: { read: true, export: true }
    },
    inventory: {
      product: { read: true, create: true, update: true, delete: true, export: true, import: true },
      stock: { read: true, create: true, update: true, delete: true, export: true },
      transaction: { read: true, create: true, update: true, delete: true, export: true }
    },
    purchasing: {
      order: { read: true, create: true, update: true, delete: true, approve: true, export: true },
      supplier: { read: true, create: true, update: true, delete: true, export: true, import: true },
      report: { read: true, export: true }
    },
    crm: {
      customer: { read: true, create: true, update: true, delete: true, export: true, import: true },
      history: { read: true, export: true },
      activity: { read: true, create: true, update: true, delete: true, export: true }
    },
    project: {
      task: { read: true, create: true, update: true, delete: true, export: true },
      status: { read: true, update: true, export: true },
      notification: { read: true, create: true, update: true, delete: true }
    },
    settings: {
      user: { read: true, create: true, update: true, delete: true, export: true },
      permission: { read: true, create: true, update: true, delete: true },
      config: { read: true, update: true },
      notification: { read: true, update: true }
    }
  },
  MANAGER: {
    hrm: {
      employee: { read: true, create: true, update: true, delete: false, export: true, import: false },
      attendance: { read: true, create: false, update: true, delete: false, approve: true, export: true },
      payroll: { read: true, create: false, update: false, delete: false, approve: true, export: true },
      leave: { read: true, create: true, update: true, delete: false, approve: true, export: true },
      announcement: { read: true, create: true, update: true, delete: false }
    },
    accounting: {
      income: { read: true, create: true, update: true, delete: false, export: true },
      finance: { read: true, create: false, update: false, delete: false, approve: true, export: true },
      report: { read: true, export: true }
    },
    sales: {
      customer: { read: true, create: true, update: true, delete: false, export: true, import: false },
      quotation: { read: true, create: true, update: true, delete: false, approve: true, export: true },
      report: { read: true, export: true }
    },
    inventory: {
      product: { read: true, create: true, update: true, delete: false, export: true, import: false },
      stock: { read: true, create: true, update: true, delete: false, export: true },
      transaction: { read: true, create: true, update: true, delete: false, export: true }
    },
    purchasing: {
      order: { read: true, create: true, update: true, delete: false, approve: true, export: true },
      supplier: { read: true, create: true, update: true, delete: false, export: true, import: false },
      report: { read: true, export: true }
    },
    crm: {
      customer: { read: true, create: true, update: true, delete: false, export: true, import: false },
      history: { read: true, export: false },
      activity: { read: true, create: true, update: true, delete: false, export: true }
    },
    project: {
      task: { read: true, create: true, update: true, delete: false, export: true },
      status: { read: true, update: true, export: true },
      notification: { read: true, create: true, update: true, delete: false }
    },
    settings: {
      user: { read: true, create: false, update: false, delete: false, export: false },
      permission: { read: true, create: false, update: false, delete: false },
      config: { read: true, update: false },
      notification: { read: true, update: true }
    }
  },
  USER: {
    hrm: {
      employee: { read: true, create: false, update: false, delete: false, export: false, import: false },
      attendance: { read: true, create: true, update: true, delete: false, approve: false, export: false },
      payroll: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      leave: { read: true, create: true, update: true, delete: true, approve: false, export: false },
      announcement: { read: true, create: false, update: false, delete: false }
    },
    accounting: {
      income: { read: false, create: false, update: false, delete: false, export: false },
      finance: { read: false, create: false, update: false, delete: false, approve: false, export: false },
      report: { read: false, export: false }
    },
    sales: {
      customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
      quotation: { read: true, create: true, update: true, delete: false, approve: false, export: false },
      report: { read: true, export: false }
    },
    inventory: {
      product: { read: true, create: false, update: false, delete: false, export: false, import: false },
      stock: { read: true, create: false, update: false, delete: false, export: false },
      transaction: { read: true, create: true, update: false, delete: false, export: false }
    },
    purchasing: {
      order: { read: true, create: true, update: true, delete: false, approve: false, export: false },
      supplier: { read: true, create: false, update: false, delete: false, export: false, import: false },
      report: { read: true, export: false }
    },
    crm: {
      customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
      history: { read: true, export: false },
      activity: { read: true, create: true, update: true, delete: false, export: false }
    },
    project: {
      task: { read: true, create: true, update: true, delete: false, export: false },
      status: { read: true, update: false, export: false },
      notification: { read: true, create: false, update: false, delete: false }
    },
    settings: {
      user: { read: false, create: false, update: false, delete: false, export: false },
      permission: { read: false, create: false, update: false, delete: false },
      config: { read: false, update: false },
      notification: { read: true, update: true }
    }
  },
  VIEWER: {
    hrm: {
      employee: { read: true, create: false, update: false, delete: false, export: false, import: false },
      attendance: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      payroll: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      leave: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      announcement: { read: true, create: false, update: false, delete: false }
    },
    accounting: {
      income: { read: true, create: false, update: false, delete: false, export: false },
      finance: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      report: { read: true, export: false }
    },
    sales: {
      customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
      quotation: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      report: { read: true, export: false }
    },
    inventory: {
      product: { read: true, create: false, update: false, delete: false, export: false, import: false },
      stock: { read: true, create: false, update: false, delete: false, export: false },
      transaction: { read: true, create: false, update: false, delete: false, export: false }
    },
    purchasing: {
      order: { read: true, create: false, update: false, delete: false, approve: false, export: false },
      supplier: { read: true, create: false, update: false, delete: false, export: false, import: false },
      report: { read: true, export: false }
    },
    crm: {
      customer: { read: true, create: false, update: false, delete: false, export: false, import: false },
      history: { read: true, export: false },
      activity: { read: true, create: false, update: false, delete: false, export: false }
    },
    project: {
      task: { read: true, create: false, update: false, delete: false, export: false },
      status: { read: true, update: false, export: false },
      notification: { read: true, create: false, update: false, delete: false }
    },
    settings: {
      user: { read: false, create: false, update: false, delete: false, export: false },
      permission: { read: false, create: false, update: false, delete: false },
      config: { read: false, update: false },
      notification: { read: true, update: false }
    }
  }
}

// Helper function to get user's permissions from database
export function getUserPermissions(userPermissions: any[]): UserPermissions {
  const permissions: UserPermissions = {}
  
  for (const perm of userPermissions) {
    if (!permissions[perm.module]) {
      permissions[perm.module] = {}
    }
    if (!permissions[perm.module][perm.submodule]) {
      permissions[perm.module][perm.submodule] = {
        read: false,
        create: false,
        update: false,
        delete: false
      }
    }
    permissions[perm.module][perm.submodule][perm.permission as keyof Permission] = perm.has_permission
  }
  
  return permissions
}

// Helper function to create permission records for saving to database
export function createPermissionRecords(userId: string, permissions: UserPermissions) {
  const records = []
  
  for (const [module, modulePerms] of Object.entries(permissions)) {
    for (const [submodule, submodulePerms] of Object.entries(modulePerms)) {
      for (const [permission, has_permission] of Object.entries(submodulePerms)) {
        records.push({
          id: uuidv4(),
          user_id: userId,
          module,
          submodule,
          permission,
          has_permission
        })
      }
    }
  }
  
  return records
}
