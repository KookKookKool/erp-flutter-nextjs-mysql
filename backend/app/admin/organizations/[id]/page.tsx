"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useParams } from "next/navigation";
import PermissionModal from "./components/PermissionModal";

interface Organization {
  id: string;
  orgCode: string;
  orgName: string;
  orgEmail: string;
  orgPhone: string;
  orgAddress: string;
  description: string;
  companyRegistrationNumber: string;
  taxId: string;
  businessType?: string; // เพิ่ม
  employeeCount?: string; // เพิ่ม
  website?: string; // เพิ่ม
  adminName: string;
  adminEmail: string;
  status: "PENDING" | "APPROVED" | "REJECTED" | "SUSPENDED" | "EXPIRED";
  subscriptionPlan: string;
  subscriptionStart: string | null;
  subscriptionEnd: string | null;
  createdAt: string;
  approvedAt: string | null;
  approvedBy: string | null;
  schemaName: string | null;
  isActive: boolean;
  users: Array<{
    id: string;
    employee_id?: string;
    email: string;
    name: string;
    role: string;
    isActive: boolean;
    createdAt: string;
  }>;
}

export default function OrganizationDetailPage() {
  // ช่องค้นหาพนักงาน
  const [employeeSearch, setEmployeeSearch] = useState("");
  const [organization, setOrganization] = useState<Organization | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isUpdating, setIsUpdating] = useState(false);
  const [newExpiryDate, setNewExpiryDate] = useState("");
  const [showExtendModal, setShowExtendModal] = useState(false);
  const [extendDays, setExtendDays] = useState(7);
  const [extendType, setExtendType] = useState<"days" | "custom">("days");
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState({
    orgName: "",
    orgEmail: "",
    orgPhone: "",
    orgAddress: "",
    orgDescription: "",
    companyRegistrationNumber: "",
    taxId: "",
    businessType: "", // เพิ่ม
    employeeCount: "", // เพิ่ม
    website: "", // เพิ่ม
    adminName: "",
    adminEmail: "",
  });

  // User management states (แก้ไขให้ตรงกับ Flutter)
  const [showUserModal, setShowUserModal] = useState(false);
  const [editingUser, setEditingUser] = useState<any>(null);
  const [userForm, setUserForm] = useState({
    employee_id: "",
    first_name: "",
    last_name: "",
    email: "",
    phone: "",
    position: "",
    level: "Junior",
    start_date: "",
    password: "",
    is_active: true,
  });
  const [isUserUpdating, setIsUserUpdating] = useState(false);

  // Permission management states
  const [showPermissionModal, setShowPermissionModal] = useState(false);
  const [selectedUser, setSelectedUser] = useState<any>(null);

  // Employee management states (แทน users)
  const [employees, setEmployees] = useState<any[]>([]);
  const [isEmployeeLoading, setIsEmployeeLoading] = useState(true);

  const router = useRouter();
  const params = useParams();

  useEffect(() => {
    // ตรวจสอบ authentication
    const token = localStorage.getItem("adminToken");
    if (!token) {
      router.push("/admin/login");
      return;
    }

    fetchOrganization();
  }, [params.id, router]);

  // เรียก fetchEmployees เมื่อ organization โหลดเสร็จ
  useEffect(() => {
    if (organization && organization.schemaName) {
      fetchEmployees();
    }
  }, [organization]);

  // เรียก fetchEmployees หลังจาก organization ถูกโหลดแล้ว
  useEffect(() => {
    if (
      organization &&
      organization.status === "APPROVED" &&
      organization.schemaName
    ) {
      fetchEmployees();
    }
  }, [organization]);

  // Update editForm when editing mode is enabled
  useEffect(() => {
    if (isEditing && organization) {
      setEditForm({
        orgName: organization.orgName || "",
        orgEmail: organization.orgEmail || "",
        orgPhone: organization.orgPhone || "",
        orgAddress: organization.orgAddress || "",
        orgDescription: organization.description || "",
        companyRegistrationNumber: organization.companyRegistrationNumber || "",
        taxId: organization.taxId || "",
        businessType: organization.businessType || "", // เพิ่ม
        employeeCount: organization.employeeCount || "", // เพิ่ม
        website: organization.website || "", // เพิ่ม
        adminName: organization.adminName || "",
        adminEmail: organization.adminEmail || "",
      });
    }
  }, [isEditing, organization]);

  const fetchOrganization = async () => {
    try {
      const token = localStorage.getItem("adminToken");
      const response = await fetch(`/api/admin/organizations/${params.id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (response.ok) {
        const data = await response.json();
        setOrganization(data.organization);

        // Set edit form data
        setEditForm({
          orgName: data.organization.orgName || "",
          orgEmail: data.organization.orgEmail || "",
          orgPhone: data.organization.orgPhone || "",
          orgAddress: data.organization.orgAddress || "",
          orgDescription: data.organization.orgDescription || "",
          companyRegistrationNumber:
            data.organization.companyRegistrationNumber || "",
          taxId: data.organization.taxId || "",
          businessType: data.organization.businessType || "", // เพิ่ม
          employeeCount: data.organization.employeeCount || "", // เพิ่ม
          website: data.organization.website || "", // เพิ่ม
          adminName: data.organization.adminName || "",
          adminEmail: data.organization.adminEmail || "",
        });

        // Set default expiry date based on current subscription or 7 days for new approval
        if (data.organization.status === "PENDING") {
          const sevenDaysFromNow = new Date();
          sevenDaysFromNow.setDate(sevenDaysFromNow.getDate() + 7);
          setNewExpiryDate(sevenDaysFromNow.toISOString().split("T")[0]);
        } else {
          const oneYearFromNow = new Date();
          oneYearFromNow.setFullYear(oneYearFromNow.getFullYear() + 1);
          setNewExpiryDate(oneYearFromNow.toISOString().split("T")[0]);
        }
      } else {
        alert("ไม่สามารถดึงข้อมูลองค์กรได้");
        router.push("/admin/organizations");
      }
    } catch (error) {
      console.error("Error fetching organization:", error);
      alert("เกิดข้อผิดพลาดในการดึงข้อมูล");
    } finally {
      setIsLoading(false);
    }
  };

  // ดึง employee list จาก unified API
  const fetchEmployees = async () => {
    setIsEmployeeLoading(true);
    try {
      const token = localStorage.getItem("adminToken");
      const orgCode = organization?.orgCode;
      console.log("fetchEmployees called with orgCode:", orgCode);

      if (!token) {
        console.log("No admin token available");
        setEmployees([]);
        return;
      }

      if (!orgCode) {
        console.log(
          "No orgCode available, organization status:",
          organization?.status
        );
        setEmployees([]);
        return;
      }

      console.log("Making API call to /api/hrm/employees");
      const response = await fetch(`/api/hrm/employees`, {
        headers: {
          Authorization: `Bearer ${token}`,
          "X-Org-Code": orgCode,
          "x-admin-panel": "1", // เพิ่ม header นี้เพื่อให้ backend ส่ง SuperAdmin กลับมา
        },
      });

      console.log("API /api/hrm/employees status:", response.status);

      if (!response.ok) {
        const errorData = await response.json();
        console.error("API error response:", errorData);
        setEmployees([]);
        return;
      }

      const data = await response.json();
      console.log("API /api/hrm/employees data:", data);

      if (data.status === "success" && data.employees) {
        setEmployees(data.employees);
        console.log("Set employees:", data.employees.length, "items");
      } else {
        console.log("No employees in response or invalid response format");
        setEmployees([]);
      }
    } catch (e) {
      console.error("fetchEmployees error:", e);
      setEmployees([]);
    } finally {
      setIsEmployeeLoading(false);
    }
  };

  const handleAction = async (action: string, additionalData?: any) => {
    if (!organization) return;

    const confirmMessages = {
      approve: "คุณต้องการอนุมัติองค์กรนี้หรือไม่?",
      reject: "คุณต้องการปฏิเสธองค์กรนี้หรือไม่?",
      suspend: "คุณต้องการระงับการใช้งานองค์กรนี้หรือไม่?",
      reactivate: "คุณต้องการเปิดใช้งานองค์กรนี้อีกครั้งหรือไม่?",
      delete:
        "คุณต้องการลบองค์กรนี้ถาวรหรือไม่? การดำเนินการนี้ไม่สามารถยกเลิกได้",
    };

    // ไม่แสดง confirm dialog สำหรับ extend และ approve ที่มาจาก modal
    const skipConfirm =
      action === "extend" ||
      (action === "approve" && additionalData?.fromModal);

    if (
      !skipConfirm &&
      !confirm(confirmMessages[action as keyof typeof confirmMessages])
    )
      return;

    setIsUpdating(true);
    try {
      const token = localStorage.getItem("adminToken");
      const response = await fetch(
        `/api/admin/organizations/${organization.id}`,
        {
          method: "PATCH",
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            action,
            ...additionalData,
          }),
        }
      );

      if (response.ok) {
        const result = await response.json();
        alert(result.message);

        // Redirect to organizations list if deleted
        if (action === "delete") {
          router.push("/admin/organizations");
          return;
        }

        fetchOrganization(); // Refresh data

        // ปิด modal เมื่อทำการอนุมัติหรือต่ออายุสำเร็จ
        if (action === "approve" || action === "extend") {
          setShowExtendModal(false);
        }
      } else {
        const error = await response.json();
        alert(`เกิดข้อผิดพลาด: ${error.error}`);
      }
    } catch (error) {
      alert("เกิดข้อผิดพลาดในการเชื่อมต่อ");
    } finally {
      setIsUpdating(false);
    }
  };

  const handleExtendSubscription = () => {
    let finalExpiryDate: string;

    if (extendType === "custom") {
      if (!newExpiryDate) {
        alert("กรุณาเลือกวันหมดอายุ");
        return;
      }
      finalExpiryDate = newExpiryDate;
    } else {
      // Calculate date from days
      const expiryDate = new Date();
      if (organization?.subscriptionEnd) {
        // Extend from current expiry date
        expiryDate.setTime(new Date(organization.subscriptionEnd).getTime());
      }
      expiryDate.setDate(expiryDate.getDate() + extendDays);
      finalExpiryDate = expiryDate.toISOString().split("T")[0];
    }

    const actionType =
      organization?.status === "PENDING" ? "approve" : "extend";

    handleAction(actionType, {
      subscriptionPlan: organization?.subscriptionPlan || "BASIC",
      subscriptionEnd: finalExpiryDate,
      fromModal: true,
    });
  };

  const handleSaveEdit = async () => {
    if (!organization) return;

    if (!confirm("คุณต้องการบันทึกการแก้ไขหรือไม่?")) return;

    setIsUpdating(true);
    try {
      const token = localStorage.getItem("adminToken");
      const response = await fetch(
        `/api/admin/organizations/${organization.id}`,
        {
          method: "PATCH",
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            action: "update",
            ...editForm,
          }),
        }
      );

      if (response.ok) {
        const result = await response.json();
        alert("บันทึกการแก้ไขเรียบร้อยแล้ว");
        setIsEditing(false);
        fetchOrganization(); // Refresh data
      } else {
        const error = await response.json();
        alert(`เกิดข้อผิดพลาด: ${error.error}`);
      }
    } catch (error) {
      alert("เกิดข้อผิดพลาดในการเชื่อมต่อ");
    } finally {
      setIsUpdating(false);
    }
  };

  const handleCancelEdit = () => {
    setIsEditing(false);
    // Reset form to original data
    if (organization) {
      setEditForm({
        orgName: organization.orgName || "",
        orgEmail: organization.orgEmail || "",
        orgPhone: organization.orgPhone || "",
        orgAddress: organization.orgAddress || "",
        orgDescription: organization.description || "",
        companyRegistrationNumber: organization.companyRegistrationNumber || "",
        taxId: organization.taxId || "",
        businessType: organization.businessType || "", // เพิ่ม
        employeeCount: organization.employeeCount || "", // เพิ่ม
        website: organization.website || "", // เพิ่ม
        adminName: organization.adminName || "",
        adminEmail: organization.adminEmail || "",
      });
    }
  };

  const getStatusBadge = (status: string, isActive: boolean) => {
    if (status === "PENDING") {
      return (
        <span className="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-yellow-100 text-yellow-800">
          รอการอนุมัติ
        </span>
      );
    }
    if (status === "APPROVED" && isActive) {
      return (
        <span className="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-green-100 text-green-800">
          ใช้งานอยู่
        </span>
      );
    }
    if (status === "REJECTED") {
      return (
        <span className="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-red-100 text-red-800">
          ปฏิเสธ
        </span>
      );
    }
    if (status === "SUSPENDED") {
      return (
        <span className="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-gray-100 text-gray-800">
          ระงับการใช้งาน
        </span>
      );
    }
    if (status === "EXPIRED") {
      return (
        <span className="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-red-100 text-red-800">
          หมดอายุ
        </span>
      );
    }
    return (
      <span className="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-gray-100 text-gray-800">
        {status}
      </span>
    );
  };

  const formatDate = (dateString: string | null) => {
    if (!dateString) return "-";
    return new Date(dateString).toLocaleDateString("th-TH", {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const getDaysUntilExpiry = () => {
    if (!organization?.subscriptionEnd) return null;
    const today = new Date();
    const expiryDate = new Date(organization.subscriptionEnd);
    const diffTime = expiryDate.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  };

  // User Management Functions
  const handleAddUser = () => {
    setEditingUser(null);
    setUserForm({
      employee_id: "",
      first_name: "",
      last_name: "",
      email: "",
      phone: "",
      position: "",
      level: "Junior",
      start_date: "",
      password: "",
      is_active: true,
    });
    setShowUserModal(true);
  };

  const handleEditUser = (emp: any) => {
    setEditingUser(emp);
    setUserForm({
      employee_id: emp.employee_id || "",
      first_name: emp.first_name || "",
      last_name: emp.last_name || "",
      email: emp.email || "",
      phone: emp.phone || "",
      position: emp.position || "",
      level: emp.level || "Junior",
      start_date: emp.start_date ? emp.start_date.split("T")[0] : "",
      password: "",
      is_active: emp.is_active !== false,
    });
    setShowUserModal(true);
  };

  const handleSaveUser = async () => {
    if (!organization?.orgCode) return;
    // Validate
    if (
      !userForm.first_name ||
      !userForm.last_name ||
      !userForm.employee_id ||
      !userForm.email
    ) {
      alert("กรุณากรอกข้อมูลให้ครบถ้วน");
      return;
    }
    if (!editingUser && !userForm.password) {
      alert("กรุณากรอกรหัสผ่านสำหรับผู้ใช้ใหม่");
      return;
    }
    setIsUserUpdating(true);
    try {
      const token = localStorage.getItem("adminToken");
      const orgCode = organization.orgCode;
      const method = editingUser ? "PUT" : "POST";
      const url =
        "/api/hrm/employees" + (editingUser ? `?id=${editingUser.id}` : "");
      const body = { ...userForm };
      if (!editingUser)
        body.start_date = new Date().toISOString().split("T")[0];
      const response = await fetch(url, {
        method,
        headers: {
          Authorization: `Bearer ${token}`,
          "X-Org-Code": orgCode,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
      });
      const data = await response.json();
      if (response.ok && data.status === "success") {
        alert("บันทึกข้อมูลพนักงานเรียบร้อยแล้ว");
        setShowUserModal(false);
        fetchEmployees();
      } else {
        alert(data.error || "เกิดข้อผิดพลาด");
      }
    } catch (e) {
      alert("เกิดข้อผิดพลาดในการเชื่อมต่อ");
    } finally {
      setIsUserUpdating(false);
    }
  };

  const handleDeleteUser = async (emp: any) => {
    if (emp.level === "SuperAdmin") {
      alert("ไม่สามารถลบ Super Admin ได้");
      return;
    }

    if (!organization?.orgCode) return;
    if (
      !confirm(
        `คุณต้องการลบพนักงาน "${emp.first_name} ${emp.last_name}" หรือไม่?`
      )
    )
      return;
    setIsUserUpdating(true);
    try {
      const token = localStorage.getItem("adminToken");
      const orgCode = organization.orgCode;
      const url = `/api/hrm/employees?id=${emp.id}`;
      const response = await fetch(url, {
        method: "DELETE",
        headers: {
          Authorization: `Bearer ${token}`,
          "X-Org-Code": orgCode,
        },
      });
      const data = await response.json();
      if (response.ok && data.status === "success") {
        alert("ลบพนักงานเรียบร้อยแล้ว");
        fetchEmployees();
      } else {
        alert(data.error || "เกิดข้อผิดพลาด");
      }
    } catch (e) {
      alert("เกิดข้อผิดพลาดในการเชื่อมต่อ");
    } finally {
      setIsUserUpdating(false);
    }
  };

  const toggleUserStatus = async (user: any) => {
    if (!organization?.schemaName) return;

    const newStatus = !user.isActive;
    const action = newStatus ? "เปิดใช้งาน" : "ปิดใช้งาน";

    if (!confirm(`คุณต้องการ${action}ผู้ใช้ "${user.name}" หรือไม่?`)) return;

    setIsUserUpdating(true);
    try {
      const token = localStorage.getItem("adminToken");
      const response = await fetch(
        `/api/admin/organizations/${organization.id}/users/${user.id}`,
        {
          method: "PUT",
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            employeeId: user.employee_id,
            name: user.name,
            email: user.email,
            role: user.role,
            isActive: newStatus,
            schemaName: organization.schemaName,
          }),
        }
      );

      if (response.ok) {
        const result = await response.json();
        alert(result.message || `${action}ผู้ใช้เรียบร้อยแล้ว`);
        fetchOrganization(); // Refresh data
      } else {
        const error = await response.json();
        alert(`เกิดข้อผิดพลาด: ${error.error}`);
      }
    } catch (error) {
      alert("เกิดข้อผิดพลาดในการเชื่อมต่อ");
    } finally {
      setIsUserUpdating(false);
    }
  };

  const handleManagePermissions = (emp: any) => {
    // Convert employee data to user format for PermissionModal
    const user = {
      id: emp.id,
      name: `${emp.first_name} ${emp.last_name}`,
      email: emp.email,
      role: emp.level || "Employee",
    };
    setSelectedUser(user);
    setShowPermissionModal(true);
  };

  const handlePermissionsUpdated = () => {
    // Refresh organization data if needed
    fetchOrganization();
  };

  // สำหรับอนาคต - Role permissions
  const getRolePermissions = (role: string) => {
    const permissions = {
      ADMIN: {
        label: "ผู้ดูแลระบบ",
        description: "สิทธิ์เต็มในการจัดการองค์กร",
        modules: ["ALL"],
      },
      MANAGER: {
        label: "ผู้จัดการ",
        description: "จัดการในส่วนที่รับผิดชอบ",
        modules: ["HR", "ACCOUNTING", "INVENTORY"],
      },
      USER: {
        label: "ผู้ใช้งาน",
        description: "ใช้งานฟีเจอร์พื้นฐาน",
        modules: ["BASIC"],
      },
      VIEWER: {
        label: "ผู้ดู",
        description: "ดูข้อมูลอย่างเดียว",
        modules: ["VIEW_ONLY"],
      },
    };
    return permissions[role as keyof typeof permissions] || permissions["USER"];
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (!organization) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-xl font-semibold text-gray-900 mb-4">
            ไม่พบข้อมูลองค์กร
          </h2>
          <button
            onClick={() => router.push("/admin/organizations")}
            className="btn btn-primary"
          >
            กลับไปหน้ารายการองค์กร
          </button>
        </div>
      </div>
    );
  }

  const daysUntilExpiry = getDaysUntilExpiry();

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-full mx-auto px-2 sm:px-4 lg:px-6">
          <div className="flex justify-between h-16">
            <div className="flex items-center space-x-4">
              <button
                onClick={() => router.push("/admin/organizations")}
                className="text-gray-500 hover:text-gray-700"
              >
                ← กลับ
              </button>
              <h1 className="text-xl font-semibold text-gray-900">
                รายละเอียดองค์กร
              </h1>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-full mx-auto py-6 px-2 sm:px-4 lg:px-6">
        {/* Organization Info */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Main Info */}
          <div className="lg:col-span-2">
            <div className="card p-6">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-lg font-medium text-gray-900">
                  ข้อมูลองค์กร
                </h2>
                <div className="flex items-center space-x-3">
                  {getStatusBadge(organization.status, organization.isActive)}
                  {!isEditing && (
                    <button
                      onClick={() => setIsEditing(true)}
                      className="px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700"
                      disabled={isUpdating}
                    >
                      แก้ไข
                    </button>
                  )}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    รหัสองค์กร
                  </label>
                  <div className="text-lg font-mono bg-gray-50 p-3 rounded">
                    {organization.orgCode}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    ชื่อองค์กร
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.orgName}
                      onChange={(e) =>
                        setEditForm({ ...editForm, orgName: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.orgName}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    อีเมลองค์กร
                  </label>
                  {isEditing ? (
                    <input
                      type="email"
                      value={editForm.orgEmail}
                      onChange={(e) =>
                        setEditForm({ ...editForm, orgEmail: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.orgEmail}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    เบอร์โทรศัพท์
                  </label>
                  {isEditing ? (
                    <input
                      type="tel"
                      value={editForm.orgPhone}
                      onChange={(e) =>
                        setEditForm({ ...editForm, orgPhone: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="เบอร์โทรศัพท์"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.orgPhone || "-"}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    เลขทะเบียน บริษัท / หจก.
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.companyRegistrationNumber}
                      onChange={(e) =>
                        setEditForm({
                          ...editForm,
                          companyRegistrationNumber: e.target.value,
                        })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="เลขทะเบียน บริษัท / หจก. 13 หลัก"
                      maxLength={13}
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.companyRegistrationNumber || "-"}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    เลขประจำตัวผู้เสียภาษี
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.taxId}
                      onChange={(e) =>
                        setEditForm({ ...editForm, taxId: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="เลขประจำตัวผู้เสียภาษี 13 หลัก"
                      maxLength={13}
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.taxId || "-"}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    ประเภทธุรกิจ
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.businessType}
                      onChange={(e) =>
                        setEditForm({
                          ...editForm,
                          businessType: e.target.value,
                        })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ประเภทธุรกิจ"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.businessType || "-"}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    ขนาดองค์กร
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.employeeCount}
                      onChange={(e) =>
                        setEditForm({
                          ...editForm,
                          employeeCount: e.target.value,
                        })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ขนาดองค์กร (จำนวนพนักงาน)"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.employeeCount || "-"}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    เว็บไซต์
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.website}
                      onChange={(e) =>
                        setEditForm({ ...editForm, website: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="เว็บไซต์องค์กร"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.website || "-"}
                    </div>
                  )}
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    ที่อยู่
                  </label>
                  {isEditing ? (
                    <textarea
                      value={editForm.orgAddress}
                      onChange={(e) =>
                        setEditForm({ ...editForm, orgAddress: e.target.value })
                      }
                      rows={3}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ที่อยู่องค์กร"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.orgAddress || "-"}
                    </div>
                  )}
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    คำอธิบายธุรกิจ
                  </label>
                  {isEditing ? (
                    <textarea
                      value={editForm.orgDescription}
                      onChange={(e) =>
                        setEditForm({
                          ...editForm,
                          orgDescription: e.target.value,
                        })
                      }
                      rows={3}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="คำอธิบายเกี่ยวกับธุรกิจ"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.description || "-"}
                    </div>
                  )}
                </div>

                {isEditing && (
                  <div className="md:col-span-2 flex space-x-3 mt-4">
                    <button
                      onClick={handleSaveEdit}
                      disabled={isUpdating}
                      className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 disabled:opacity-50"
                    >
                      {isUpdating ? "กำลังบันทึก..." : "บันทึก"}
                    </button>
                    <button
                      onClick={handleCancelEdit}
                      disabled={isUpdating}
                      className="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 disabled:opacity-50"
                    >
                      ยกเลิก
                    </button>
                  </div>
                )}
              </div>
            </div>

            {/* Admin Info */}
            <div className="card p-6 mt-6">
              <h2 className="text-lg font-medium text-gray-900 mb-6">
                ข้อมูลผู้ดูแล
              </h2>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    ชื่อผู้ดูแล
                  </label>
                  {isEditing ? (
                    <input
                      type="text"
                      value={editForm.adminName}
                      onChange={(e) =>
                        setEditForm({ ...editForm, adminName: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.adminName}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    อีเมลผู้ดูแล
                  </label>
                  {isEditing ? (
                    <input
                      type="email"
                      value={editForm.adminEmail}
                      onChange={(e) =>
                        setEditForm({ ...editForm, adminEmail: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  ) : (
                    <div className="text-lg bg-gray-50 p-3 rounded">
                      {organization.adminEmail}
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* User Management */}
            <div className="card p-6 mt-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-4">
                  <h2 className="text-lg font-medium text-gray-900">
                    จัดการพนักงาน ({employees.length})
                  </h2>
                  <input
                    type="text"
                    className="border px-3 py-2 rounded text-sm"
                    style={{ minWidth: 180 }}
                    placeholder="ค้นหาพนักงาน..."
                    value={employeeSearch}
                    onChange={(e) => setEmployeeSearch(e.target.value)}
                  />
                </div>
                <button
                  onClick={handleAddUser}
                  className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 disabled:opacity-50"
                  disabled={
                    !organization?.schemaName ||
                    isUserUpdating ||
                    organization?.status !== "APPROVED"
                  }
                >
                  เพิ่มพนักงาน
                </button>
              </div>
              {isEmployeeLoading ? (
                <div className="text-center py-8 text-gray-500">
                  กำลังโหลดข้อมูล...
                </div>
              ) : employees.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="min-w-full table-auto">
                    <thead>
                      <tr>
                        <th className="w-32">รหัสพนักงาน</th>
                        <th className="w-40">ชื่อ</th>
                        <th className="w-40">นามสกุล</th>
                        <th className="w-56">อีเมล</th>
                        <th className="w-32">ตำแหน่ง</th>
                        <th className="w-32">ระดับ</th>
                        <th className="w-24">สถานะ</th>
                        <th className="w-40">วันที่เริ่มงาน</th>
                        <th className="w-80">การจัดการ</th>
                      </tr>
                    </thead>
                    <tbody>
                      {employees
                        .filter((emp) => {
                          const term = employeeSearch.trim().toLowerCase();
                          if (!term) return true;
                          return (
                            (emp.first_name &&
                              emp.first_name.toLowerCase().includes(term)) ||
                            (emp.last_name &&
                              emp.last_name.toLowerCase().includes(term)) ||
                            (emp.employee_id &&
                              emp.employee_id.toLowerCase().includes(term)) ||
                            (emp.email &&
                              emp.email.toLowerCase().includes(term))
                          );
                        })
                        .sort((a, b) => {
                          // เรียง created_at จากน้อยไปมาก (สร้างก่อนอยู่บน)
                          const dateA = new Date(a.created_at).getTime();
                          const dateB = new Date(b.created_at).getTime();
                          return dateA - dateB;
                        })
                        .map((emp) => (
                          <tr key={emp.id}>
                            <td className="font-mono text-sm">
                              {emp.employee_id}
                            </td>
                            <td>{emp.first_name}</td>
                            <td>{emp.last_name}</td>
                            <td>{emp.email}</td>
                            <td>{emp.position}</td>
                            <td>{emp.level}</td>
                            <td>
                              <span
                                className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                                  emp.is_active
                                    ? "bg-green-100 text-green-800"
                                    : "bg-red-100 text-red-800"
                                }`}
                              >
                                {emp.is_active ? "ใช้งาน" : "ปิดใช้งาน"}
                              </span>
                            </td>
                            <td>
                              {emp.start_date
                                ? new Date(emp.start_date).toLocaleDateString(
                                    "th-TH"
                                  )
                                : "-"}
                            </td>
                            <td>
                              <div className="flex space-x-2">
                                <button
                                  onClick={() => handleEditUser(emp)}
                                  disabled={isUserUpdating}
                                  className="px-2 py-1 text-xs bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
                                >
                                  แก้ไข
                                </button>
                                {emp.level !== "SuperAdmin" && (
                                  <button
                                    onClick={() => handleManagePermissions(emp)}
                                    disabled={isUserUpdating}
                                    className="px-2 py-1 text-xs bg-purple-600 text-white rounded hover:bg-purple-700 disabled:opacity-50"
                                  >
                                    สิทธิ์
                                  </button>
                                )}
                                {emp.level !== "SuperAdmin" && (
                                  <button
                                    onClick={() => handleDeleteUser(emp)}
                                    disabled={isUserUpdating}
                                    className="px-2 py-1 text-xs bg-red-600 text-white rounded hover:bg-red-700 disabled:opacity-50"
                                  >
                                    ลบ
                                  </button>
                                )}
                              </div>
                            </td>
                          </tr>
                        ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <div className="text-center py-8 text-gray-500">
                  {organization?.status !== "APPROVED" ? (
                    <>
                      <p>องค์กรนี้ยังไม่ได้รับการอนุมัติ</p>
                      <p className="text-sm mt-2">
                        ต้องอนุมัติองค์กรก่อนจึงจะสามารถจัดการพนักงานได้
                      </p>
                    </>
                  ) : !organization?.schemaName ? (
                    <>
                      <p>ระบบฐานข้อมูลยังไม่พร้อม</p>
                      <p className="text-sm mt-2">โปรดติดต่อผู้ดูแลระบบ</p>
                    </>
                  ) : (
                    <>
                      <p>ยังไม่มีพนักงานในระบบ</p>
                      <p className="text-sm mt-2">
                        คลิก "เพิ่มพนักงาน" เพื่อเริ่มต้น
                      </p>
                    </>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Side Panel */}
          <div className="space-y-6">
            {/* Subscription Info */}
            <div className="card p-6">
              <h2 className="text-lg font-medium text-gray-900 mb-4">
                ข้อมูลการสมัครสมาชิก
              </h2>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    แผนการใช้งาน
                  </label>
                  <div className="text-sm bg-gray-50 p-2 rounded">
                    {organization.subscriptionPlan || "-"}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    วันที่เริ่มใช้งาน
                  </label>
                  <div className="text-sm bg-gray-50 p-2 rounded">
                    {formatDate(organization.subscriptionStart)}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    วันหมดอายุ
                  </label>
                  <div
                    className={`text-sm p-2 rounded ${
                      daysUntilExpiry !== null && daysUntilExpiry < 30
                        ? "bg-red-50 text-red-800"
                        : "bg-gray-50"
                    }`}
                  >
                    {formatDate(organization.subscriptionEnd)}
                    {daysUntilExpiry !== null && (
                      <div className="text-xs mt-1">
                        {daysUntilExpiry > 0
                          ? `เหลือ ${daysUntilExpiry} วัน`
                          : `หมดอายุแล้ว ${Math.abs(daysUntilExpiry)} วัน`}
                      </div>
                    )}
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Database Schema
                  </label>
                  <div className="text-sm font-mono bg-gray-50 p-2 rounded">
                    {organization.schemaName || "-"}
                  </div>
                </div>
              </div>
            </div>

            {/* System Info */}
            <div className="card p-6">
              <h2 className="text-lg font-medium text-gray-900 mb-4">
                ข้อมูลระบบ
              </h2>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    วันที่สมัคร
                  </label>
                  <div className="text-sm bg-gray-50 p-2 rounded">
                    {formatDate(organization.createdAt)}
                  </div>
                </div>

                {organization.approvedAt && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      วันที่อนุมัติ
                    </label>
                    <div className="text-sm bg-gray-50 p-2 rounded">
                      {formatDate(organization.approvedAt)}
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Actions */}
            <div className="card p-6">
              <h2 className="text-lg font-medium text-gray-900 mb-4">
                การจัดการ
              </h2>

              <div className="space-y-3">
                {organization.status === "PENDING" && (
                  <>
                    <button
                      onClick={() => setShowExtendModal(true)}
                      disabled={isUpdating}
                      className="w-full btn btn-success"
                    >
                      {isUpdating
                        ? "กำลังประมวลผล..."
                        : "อนุมัติ (ตั้งค่าวันหมดอายุ)"}
                    </button>
                    <button
                      onClick={() => handleAction("reject")}
                      disabled={isUpdating}
                      className="w-full btn btn-danger"
                    >
                      {isUpdating ? "กำลังประมวลผล..." : "ปฏิเสธ"}
                    </button>
                  </>
                )}

                {organization.status === "APPROVED" &&
                  organization.isActive && (
                    <>
                      <button
                        onClick={() => setShowExtendModal(true)}
                        disabled={isUpdating}
                        className="w-full btn btn-primary"
                      >
                        ต่ออายุการใช้งาน
                      </button>
                      <button
                        onClick={() => handleAction("suspend")}
                        disabled={isUpdating}
                        className="w-full btn btn-warning"
                      >
                        {isUpdating ? "กำลังประมวลผล..." : "ระงับการใช้งาน"}
                      </button>
                    </>
                  )}

                {organization.status === "SUSPENDED" && (
                  <>
                    <button
                      onClick={() => handleAction("reactivate")}
                      disabled={isUpdating}
                      className="w-full btn btn-success"
                    >
                      {isUpdating ? "กำลังประมวลผล..." : "เปิดใช้งานอีกครั้ง"}
                    </button>
                    <button
                      onClick={() => handleAction("reject")}
                      disabled={isUpdating}
                      className="w-full btn btn-danger"
                    >
                      {isUpdating ? "กำลังประมวลผล..." : "ปฏิเสธถาวร"}
                    </button>
                  </>
                )}

                {organization.status === "REJECTED" && (
                  <>
                    <button
                      onClick={() => setShowExtendModal(true)}
                      disabled={isUpdating}
                      className="w-full btn btn-success"
                    >
                      {isUpdating ? "กำลังประมวลผล..." : "อนุมัติและเปิดใช้งาน"}
                    </button>
                    <div className="text-xs text-gray-600 p-2 bg-yellow-50 rounded">
                      หมายเหตุ: การอนุมัติองค์กรที่เคยถูกปฏิเสธจะสร้าง database
                      schema ใหม่
                    </div>
                  </>
                )}

                {organization.status === "EXPIRED" && (
                  <>
                    <button
                      onClick={() => setShowExtendModal(true)}
                      disabled={isUpdating}
                      className="w-full btn btn-success"
                    >
                      {isUpdating ? "กำลังประมวลผล..." : "ต่ออายุและเปิดใช้งาน"}
                    </button>
                    <button
                      onClick={() => handleAction("reject")}
                      disabled={isUpdating}
                      className="w-full btn btn-danger"
                    >
                      {isUpdating ? "กำลังประมวลผล..." : "ปฏิเสธถาวร"}
                    </button>
                  </>
                )}

                {/* Always show delete option for admin */}
                <div className="border-t pt-3 mt-4">
                  <button
                    onClick={() => handleAction("delete")}
                    disabled={isUpdating}
                    className="w-full btn bg-red-700 hover:bg-red-800 text-white"
                  >
                    {isUpdating ? "กำลังประมวลผล..." : "ลบองค์กรถาวร"}
                  </button>
                  <div className="text-xs text-red-600 p-2 bg-red-50 rounded mt-2">
                    ⚠️ การลบจะทำลาย database schema และข้อมูลทั้งหมด
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Extend Subscription Modal */}
      {showExtendModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md">
            <h3 className="text-lg font-medium text-gray-900 mb-4">
              {organization.status === "PENDING"
                ? "อนุมัติและตั้งค่าวันหมดอายุ"
                : "ต่ออายุการใช้งาน"}
            </h3>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  วิธีการกำหนดวันหมดอายุ
                </label>
                <div className="space-y-2">
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="extendType"
                      checked={extendType === "days"}
                      onChange={() => setExtendType("days")}
                      className="mr-2"
                    />
                    <span>เพิ่มจำนวนวัน</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      name="extendType"
                      checked={extendType === "custom"}
                      onChange={() => setExtendType("custom")}
                      className="mr-2"
                    />
                    <span>กำหนดวันที่เอง</span>
                  </label>
                </div>
              </div>

              {extendType === "days" ? (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    จำนวนวันที่ต้องการ
                    {organization.status === "PENDING" ? "" : "ต่อ"}
                  </label>
                  <div className="space-y-2">
                    <label className="flex items-center">
                      <input
                        type="radio"
                        name="extendDays"
                        checked={extendDays === 7}
                        onChange={() => setExtendDays(7)}
                        className="mr-2"
                      />
                      <span>7 วัน (ทดลองใช้)</span>
                    </label>
                    <label className="flex items-center">
                      <input
                        type="radio"
                        name="extendDays"
                        checked={extendDays === 30}
                        onChange={() => setExtendDays(30)}
                        className="mr-2"
                      />
                      <span>30 วัน (1 เดือน)</span>
                    </label>
                    <label className="flex items-center">
                      <input
                        type="radio"
                        name="extendDays"
                        checked={extendDays === 90}
                        onChange={() => setExtendDays(90)}
                        className="mr-2"
                      />
                      <span>90 วัน (3 เดือน)</span>
                    </label>
                    <label className="flex items-center">
                      <input
                        type="radio"
                        name="extendDays"
                        checked={extendDays === 365}
                        onChange={() => setExtendDays(365)}
                        className="mr-2"
                      />
                      <span>365 วัน (1 ปี)</span>
                    </label>
                    <div className="flex items-center">
                      <input
                        type="radio"
                        name="extendDays"
                        checked={![7, 30, 90, 365].includes(extendDays)}
                        onChange={() => setExtendDays(0)}
                        className="mr-2"
                      />
                      <input
                        type="number"
                        value={
                          ![7, 30, 90, 365].includes(extendDays)
                            ? extendDays
                            : ""
                        }
                        onChange={(e) =>
                          setExtendDays(parseInt(e.target.value) || 0)
                        }
                        placeholder="จำนวนวัน"
                        className="px-2 py-1 border border-gray-300 rounded text-sm w-24"
                        min="1"
                      />
                      <span className="ml-2 text-sm">วัน (กำหนดเอง)</span>
                    </div>
                  </div>
                </div>
              ) : (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    วันหมดอายุใหม่
                  </label>
                  <input
                    type="date"
                    value={newExpiryDate}
                    onChange={(e) => setNewExpiryDate(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md"
                    min={new Date().toISOString().split("T")[0]}
                  />
                </div>
              )}

              <div className="bg-blue-50 p-3 rounded-md">
                <p className="text-sm text-blue-800">
                  <strong>วันหมดอายุใหม่:</strong>{" "}
                  {extendType === "custom" && newExpiryDate
                    ? new Date(newExpiryDate).toLocaleDateString("th-TH")
                    : (() => {
                        const baseDate =
                          organization.subscriptionEnd &&
                          organization.status !== "PENDING"
                            ? new Date(organization.subscriptionEnd)
                            : new Date();
                        baseDate.setDate(baseDate.getDate() + extendDays);
                        return baseDate.toLocaleDateString("th-TH");
                      })()}
                </p>
                {organization.subscriptionEnd &&
                  organization.status !== "PENDING" &&
                  extendType === "days" && (
                    <p className="text-xs text-blue-600 mt-1">
                      (ต่อจากวันหมดอายุปัจจุบัน:{" "}
                      {formatDate(organization.subscriptionEnd)})
                    </p>
                  )}
              </div>
            </div>

            <div className="flex space-x-3 mt-6">
              <button
                onClick={handleExtendSubscription}
                disabled={
                  isUpdating ||
                  (extendType === "custom" && !newExpiryDate) ||
                  (extendType === "days" && extendDays <= 0)
                }
                className="flex-1 btn btn-primary disabled:opacity-50"
              >
                {isUpdating ? "กำลังประมวลผล..." : "ยืนยัน"}
              </button>
              <button
                onClick={() => {
                  setShowExtendModal(false);
                  setExtendType("days");
                  setExtendDays(7);
                }}
                disabled={isUpdating}
                className="flex-1 btn btn-secondary"
              >
                ยกเลิก
              </button>
            </div>
          </div>
        </div>
      )}

      {/* User Modal */}
      {showUserModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md">
            <h3 className="text-lg font-medium text-gray-900 mb-4">
              {editingUser && editingUser.level === "SuperAdmin"
                ? "เปลี่ยนรหัสผ่าน Super Admin"
                : editingUser
                ? "แก้ไขข้อมูลพนักงาน"
                : "เพิ่มพนักงานใหม่"}
            </h3>
            <div className="space-y-4">
              {editingUser && editingUser.level === "SuperAdmin" ? (
                <>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      อีเมล (อ่านอย่างเดียว)
                    </label>
                    <input
                      type="text"
                      value={editingUser.email}
                      disabled
                      className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-100 text-gray-600"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      รหัสผ่านใหม่ <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="password"
                      value={userForm.password}
                      onChange={(e) =>
                        setUserForm({ ...userForm, password: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="กรอกรหัสผ่านใหม่สำหรับ Super Admin"
                    />
                  </div>
                </>
              ) : (
                <>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      รหัสพนักงาน
                    </label>
                    <input
                      type="text"
                      value={userForm.employee_id}
                      onChange={(e) =>
                        setUserForm({
                          ...userForm,
                          employee_id: e.target.value,
                        })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="รหัสพนักงาน (เช่น EMP001)"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ชื่อ
                    </label>
                    <input
                      type="text"
                      value={userForm.first_name}
                      onChange={(e) =>
                        setUserForm({ ...userForm, first_name: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ชื่อ"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      นามสกุล
                    </label>
                    <input
                      type="text"
                      value={userForm.last_name}
                      onChange={(e) =>
                        setUserForm({ ...userForm, last_name: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="นามสกุล"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      อีเมล
                    </label>
                    <input
                      type="email"
                      value={userForm.email}
                      onChange={(e) =>
                        setUserForm({ ...userForm, email: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="อีเมล"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      เบอร์โทรศัพท์
                    </label>
                    <input
                      type="tel"
                      value={userForm.phone}
                      onChange={(e) =>
                        setUserForm({ ...userForm, phone: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="เบอร์โทรศัพท์"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ตำแหน่ง
                    </label>
                    <input
                      type="text"
                      value={userForm.position}
                      onChange={(e) =>
                        setUserForm({ ...userForm, position: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ตำแหน่ง"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ระดับ
                    </label>
                    <select
                      value={userForm.level}
                      onChange={(e) =>
                        setUserForm({ ...userForm, level: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="Junior">Junior</option>
                      <option value="Senior">Senior</option>
                      <option value="Manager">Manager</option>
                      <option value="Director">Director</option>
                      {editingUser && editingUser.level === "SuperAdmin" && (
                        <option value="SuperAdmin">SuperAdmin</option>
                      )}
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      วันที่เริ่มงาน
                    </label>
                    <input
                      type="date"
                      value={userForm.start_date}
                      onChange={(e) =>
                        setUserForm({ ...userForm, start_date: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      รหัสผ่าน{" "}
                      {editingUser ? (
                        ""
                      ) : (
                        <span className="text-red-500">*</span>
                      )}
                    </label>
                    <input
                      type="password"
                      value={userForm.password}
                      onChange={(e) =>
                        setUserForm({ ...userForm, password: e.target.value })
                      }
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder={
                        editingUser
                          ? "ใส่รหัสผ่านใหม่หากต้องการเปลี่ยน"
                          : "รหัสผ่าน"
                      }
                    />
                  </div>
                  <div className="flex items-center">
                    <input
                      type="checkbox"
                      checked={userForm.is_active}
                      onChange={(e) =>
                        setUserForm({
                          ...userForm,
                          is_active: e.target.checked,
                        })
                      }
                      className="mr-2"
                    />
                    <span className="text-sm text-gray-700">
                      เปิดใช้งานพนักงาน
                    </span>
                  </div>
                </>
              )}
            </div>
            <div className="flex space-x-3 mt-6">
              <button
                onClick={handleSaveUser}
                disabled={isUserUpdating}
                className="flex-1 btn btn-primary disabled:opacity-50"
              >
                {isUserUpdating
                  ? "กำลังบันทึก..."
                  : editingUser && editingUser.level === "SuperAdmin"
                  ? "เปลี่ยนรหัสผ่าน"
                  : "บันทึกข้อมูลพนักงาน"}
              </button>
              <button
                onClick={() => setShowUserModal(false)}
                disabled={isUserUpdating}
                className="flex-1 btn btn-secondary"
              >
                ยกเลิก
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Permission Management Modal */}
      {selectedUser && (
        <PermissionModal
          isOpen={showPermissionModal}
          onClose={() => {
            setShowPermissionModal(false);
            setSelectedUser(null);
          }}
          user={selectedUser}
          orgId={organization?.id || ""}
          onSave={handlePermissionsUpdated}
        />
      )}
    </div>
  );
}
