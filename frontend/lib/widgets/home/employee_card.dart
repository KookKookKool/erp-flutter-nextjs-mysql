import 'package:flutter/material.dart';
import 'package:frontend/core/auth/models/employee_model.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:intl/intl.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final Map<String, dynamic>? permissions;
  const EmployeeCard({super.key, required this.employee, this.permissions});

  // mock employee สำหรับ fallback UI
  static Employee mock() {
    return Employee(
      id: 'mock',
      employeeId: 'EMP001',
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      email: 'mock@email.com',
      phone: '',
      position: 'พนักงาน',
      department: 'ทั่วไป',
      level: 'staff',
      startDate: DateTime.now(),
      isActive: true,
      profileImage: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isMock = employee.id == 'mock';
    // Debug: print employee object to console
    debugPrint('EmployeeCard: employee = ' + employee.toString());
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: isMock ? Colors.grey : SunTheme.sunGold,
              child: Icon(
                Icons.person,
                size: 40,
                color: isMock ? Colors.black26 : SunTheme.sunDeepOrange,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รหัสพนักงาน
                  Text(
                    employee.employeeId,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isMock ? Colors.grey : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // ชื่อ + นามสกุล
                  Text(
                    employee.fullName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isMock ? Colors.grey : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // level + position
                  Text(
                    employee.level + ' ' + employee.position,
                    style: textTheme.bodySmall,
                  ),
                  if (permissions != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'สิทธิ์: ' + permissions.toString(),
                      style: textTheme.bodySmall,
                    ),
                  ],
                  if (isMock) ...[
                    const SizedBox(height: 12),
                    Text(
                      '⚠️ กำลังแสดงข้อมูล MOCK (ไม่ได้ดึงจากฐานข้อมูลจริง)',
                      style: textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
