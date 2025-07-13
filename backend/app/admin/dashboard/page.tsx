"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";

interface Organization {
  id: string;
  orgCode: string;
  orgName: string;
  orgEmail: string;
  adminName: string;
  adminEmail: string;
  status: "PENDING" | "APPROVED" | "REJECTED" | "SUSPENDED" | "EXPIRED";
  subscriptionPlan: string;
  subscriptionStart: string | null;
  subscriptionEnd: string | null;
  createdAt: string;
  approvedAt: string | null;
  schemaName: string | null;
  isActive: boolean;
}

interface DashboardStats {
  totalOrganizations: number;
  pendingOrganizations: number;
  activeOrganizations: number;
  expiredOrganizations: number;
  expiringIn30Days: number;
  expiringIn7Days: number;
}

export default function AdminDashboard() {
  // ฟิลเตอร์และค้นหา
  const [orgFilter, setOrgFilter] = useState<string>("all");
  const [searchTerm, setSearchTerm] = useState("");
  const [stats, setStats] = useState<DashboardStats>({
    totalOrganizations: 0,
    pendingOrganizations: 0,
    activeOrganizations: 0,
    expiredOrganizations: 0,
    expiringIn30Days: 0,
    expiringIn7Days: 0,
  });
  const [recentOrganizations, setRecentOrganizations] = useState<
    Organization[]
  >([]);
  const [isLoading, setIsLoading] = useState(true);
  const [adminUser, setAdminUser] = useState<any>(null);
  const router = useRouter();

  useEffect(() => {
    // ตรวจสอบ authentication
    const token = localStorage.getItem("adminToken");
    const user = localStorage.getItem("adminUser");

    if (!token || !user) {
      router.push("/admin/login");
      return;
    }

    setAdminUser(JSON.parse(user));
    fetchDashboardData();
  }, [router]);

  const fetchDashboardData = async () => {
    try {
      const token = localStorage.getItem("adminToken");

      // ดึงข้อมูลองค์กรทั้งหมด
      const orgResponse = await fetch("/api/admin/organizations?limit=5", {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });

      if (orgResponse.ok) {
        const orgData = await orgResponse.json();
        setRecentOrganizations(orgData.organizations);

        // คำนวณสถิติ
        const pending = orgData.organizations.filter(
          (org: Organization) => org.status === "PENDING"
        ).length;
        const active = orgData.organizations.filter(
          (org: Organization) => org.status === "APPROVED" && org.isActive
        ).length;
        const expired = orgData.organizations.filter(
          (org: Organization) => org.status === "EXPIRED"
        ).length;

        // คำนวณการหมดอายุ
        const today = new Date();
        const in7Days = new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000);
        const in30Days = new Date(today.getTime() + 30 * 24 * 60 * 60 * 1000);

        const expiringIn7 = orgData.organizations.filter(
          (org: Organization) => {
            if (!org.subscriptionEnd || org.status !== "APPROVED") return false;
            const expiryDate = new Date(org.subscriptionEnd);
            return expiryDate >= today && expiryDate <= in7Days;
          }
        ).length;

        const expiringIn30 = orgData.organizations.filter(
          (org: Organization) => {
            if (!org.subscriptionEnd || org.status !== "APPROVED") return false;
            const expiryDate = new Date(org.subscriptionEnd);
            return expiryDate >= today && expiryDate <= in30Days;
          }
        ).length;

        setStats({
          totalOrganizations: orgData.pagination.total,
          pendingOrganizations: pending,
          activeOrganizations: active,
          expiredOrganizations: expired,
          expiringIn30Days: expiringIn30,
          expiringIn7Days: expiringIn7,
        });
      }
    } catch (error) {
      console.error("Error fetching dashboard data:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem("adminToken");
    localStorage.removeItem("adminUser");
    router.push("/admin/login");
  };

  const getStatusBadge = (status: string, isActive: boolean) => {
    if (status === "PENDING") {
      return (
        <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">
          รอการอนุมัติ
        </span>
      );
    }
    if (status === "APPROVED" && isActive) {
      return (
        <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
          ใช้งานอยู่
        </span>
      );
    }
    if (status === "REJECTED") {
      return (
        <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
          ปฏิเสธ
        </span>
      );
    }
    if (status === "SUSPENDED") {
      return (
        <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
          ระงับการใช้งาน
        </span>
      );
    }
    if (status === "EXPIRED") {
      return (
        <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
          หมดอายุ
        </span>
      );
    }
    return (
      <span className="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
        {status}
      </span>
    );
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-full mx-auto px-2 sm:px-4 lg:px-6">
          <div className="flex justify-between h-16">
            <div className="flex items-center space-x-8">
              <h1 className="text-xl font-semibold text-gray-900">
                ERP Admin Panel
              </h1>
              <nav className="hidden md:flex space-x-4">
                <button
                  onClick={() => router.push("/admin/dashboard")}
                  className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium"
                >
                  แดชบอร์ด
                </button>
                <button
                  onClick={() => router.push("/admin/organizations")}
                  className="text-gray-600 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium"
                >
                  จัดการองค์กร
                </button>
                {/* Environment Settings removed */}
              </nav>
            </div>
          </div>
        </div>
      </header>

      <div className="max-w-full mx-auto py-6 px-2 sm:px-4 lg:px-6">
        {/* Filter Buttons */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4 mb-4">
          <button
            className={`card p-4 text-left ${
              orgFilter === "all" ? "border-blue-600 border-2" : ""
            }`}
            onClick={() => setOrgFilter("all")}
          >
            <div className="flex items-center">
              <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center">
                <span className="text-white text-sm font-bold">
                  {stats.totalOrganizations}
                </span>
              </div>
              <div className="ml-5">
                <div className="text-sm font-medium text-gray-500">
                  องค์กรทั้งหมด
                </div>
                <div className="text-lg font-medium text-gray-900">
                  {stats.totalOrganizations}
                </div>
              </div>
            </div>
          </button>
          <button
            className={`card p-4 text-left ${
              orgFilter === "pending" ? "border-yellow-600 border-2" : ""
            }`}
            onClick={() => setOrgFilter("pending")}
          >
            <div className="flex items-center">
              <div className="w-8 h-8 bg-yellow-500 rounded-full flex items-center justify-center">
                <span className="text-white text-sm font-bold">
                  {stats.pendingOrganizations}
                </span>
              </div>
              <div className="ml-5">
                <div className="text-sm font-medium text-gray-500">
                  รอการอนุมัติ
                </div>
                <div className="text-lg font-medium text-gray-900">
                  {stats.pendingOrganizations}
                </div>
              </div>
            </div>
          </button>
          <button
            className={`card p-4 text-left ${
              orgFilter === "active" ? "border-green-600 border-2" : ""
            }`}
            onClick={() => setOrgFilter("active")}
          >
            <div className="flex items-center">
              <div className="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center">
                <span className="text-white text-sm font-bold">
                  {stats.activeOrganizations}
                </span>
              </div>
              <div className="ml-5">
                <div className="text-sm font-medium text-gray-500">
                  ใช้งานอยู่
                </div>
                <div className="text-lg font-medium text-gray-900">
                  {stats.activeOrganizations}
                </div>
              </div>
            </div>
          </button>
          <button
            className={`card p-4 text-left ${
              orgFilter === "exp7" ? "border-orange-600 border-2" : ""
            }`}
            onClick={() => setOrgFilter("exp7")}
          >
            <div className="flex items-center">
              <div className="w-8 h-8 bg-orange-500 rounded-full flex items-center justify-center">
                <span className="text-white text-sm font-bold">
                  {stats.expiringIn7Days}
                </span>
              </div>
              <div className="ml-5">
                <div className="text-sm font-medium text-gray-500">
                  หมดอายุใน 7 วัน
                </div>
                <div className="text-lg font-medium text-gray-900">
                  {stats.expiringIn7Days}
                </div>
              </div>
            </div>
          </button>
          <button
            className={`card p-4 text-left ${
              orgFilter === "exp30" ? "border-yellow-700 border-2" : ""
            }`}
            onClick={() => setOrgFilter("exp30")}
          >
            <div className="flex items-center">
              <div className="w-8 h-8 bg-yellow-600 rounded-full flex items-center justify-center">
                <span className="text-white text-sm font-bold">
                  {stats.expiringIn30Days}
                </span>
              </div>
              <div className="ml-5">
                <div className="text-sm font-medium text-gray-500">
                  หมดอายุใน 30 วัน
                </div>
                <div className="text-lg font-medium text-gray-900">
                  {stats.expiringIn30Days}
                </div>
              </div>
            </div>
          </button>
          <button
            className={`card p-4 text-left ${
              orgFilter === "expired" ? "border-red-600 border-2" : ""
            }`}
            onClick={() => setOrgFilter("expired")}
          >
            <div className="flex items-center">
              <div className="w-8 h-8 bg-red-500 rounded-full flex items-center justify-center">
                <span className="text-white text-sm font-bold">
                  {stats.expiredOrganizations}
                </span>
              </div>
              <div className="ml-5">
                <div className="text-sm font-medium text-gray-500">
                  หมดอายุแล้ว
                </div>
                <div className="text-lg font-medium text-gray-900">
                  {stats.expiredOrganizations}
                </div>
              </div>
            </div>
          </button>
        </div>

        {/* ช่องค้นหา */}
        <div className="mb-4 flex items-center gap-2">
          <input
            type="text"
            className="border px-3 py-2 rounded w-full max-w-md"
            placeholder="ค้นหาชื่อองค์กร..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        {/* กรองข้อมูลองค์กรล่าสุด */}
        <div className="card">
          <div className="px-6 py-4 border-b border-gray-200">
            <h3 className="text-lg font-medium text-gray-900">องค์กรล่าสุด</h3>
          </div>
          <div className="overflow-x-auto">
            <table className="table-auto">
              <thead>
                <tr>
                  <th>รหัสองค์กร</th>
                  <th>ชื่อองค์กร</th>
                  <th>ผู้ดูแล</th>
                  <th>สถานะ</th>
                  <th>วันที่สมัคร</th>
                  <th>การจัดการ</th>
                </tr>
              </thead>
              <tbody>
                {recentOrganizations
                  .filter((org) => {
                    // filter by orgFilter
                    if (orgFilter === "pending")
                      return org.status === "PENDING";
                    if (orgFilter === "active")
                      return org.status === "APPROVED" && org.isActive;
                    if (orgFilter === "expired")
                      return org.status === "EXPIRED";
                    if (orgFilter === "exp7") {
                      if (!org.subscriptionEnd || org.status !== "APPROVED")
                        return false;
                      const today = new Date();
                      const in7Days = new Date(
                        today.getTime() + 7 * 24 * 60 * 60 * 1000
                      );
                      const expiryDate = new Date(org.subscriptionEnd);
                      return expiryDate >= today && expiryDate <= in7Days;
                    }
                    if (orgFilter === "exp30") {
                      if (!org.subscriptionEnd || org.status !== "APPROVED")
                        return false;
                      const today = new Date();
                      const in30Days = new Date(
                        today.getTime() + 30 * 24 * 60 * 60 * 1000
                      );
                      const expiryDate = new Date(org.subscriptionEnd);
                      return expiryDate >= today && expiryDate <= in30Days;
                    }
                    return true; // all
                  })
                  .filter((org) =>
                    org.orgName.toLowerCase().includes(searchTerm.toLowerCase())
                  )
                  .map((org) => (
                    <tr key={org.id}>
                      <td className="font-mono text-sm">{org.orgCode}</td>
                      <td>
                        <div>
                          <div className="font-medium">{org.orgName}</div>
                          <div className="text-sm text-gray-500">
                            {org.orgEmail}
                          </div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div className="font-medium">{org.adminName}</div>
                          <div className="text-sm text-gray-500">
                            {org.adminEmail}
                          </div>
                        </div>
                      </td>
                      <td>{getStatusBadge(org.status, org.isActive)}</td>
                      <td className="text-sm">
                        {new Date(org.createdAt).toLocaleDateString("th-TH")}
                      </td>
                      <td>
                        <button
                          onClick={() =>
                            router.push(`/admin/organizations/${org.id}`)
                          }
                          className="btn btn-primary text-sm"
                        >
                          จัดการ
                        </button>
                      </td>
                    </tr>
                  ))}
              </tbody>
            </table>
          </div>
          <div className="px-6 py-4 border-t border-gray-200">
            <button
              onClick={() => router.push("/admin/organizations")}
              className="btn btn-secondary"
            >
              ดูองค์กรทั้งหมด
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
