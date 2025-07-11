// OT Integration Demo
// This file demonstrates how the OT and Attendance systems are now integrated

import 'package:frontend/modules/hrm/attendance/models/ot_request.dart';
import 'package:frontend/modules/hrm/attendance/services/ot_data_service.dart';
import 'package:frontend/modules/hrm/attendance/services/attendance_ot_integration_service.dart';
import 'package:frontend/modules/hrm/attendance/attendance_screen.dart';

/// Example usage of the integrated OT-Attendance system
class OtAttendanceIntegrationDemo {
  static Future<void> demonstrateIntegration() async {
    final otService = OtDataService();
    final integrationService = AttendanceOtIntegrationService();

    // 1. Create a mock OT request
    final otRequest = OtRequest(
      id: 'OT_DEMO_001',
      employeeId: 'EMP001',
      employeeName: 'สมชาย ใจดี',
      date: DateTime.now(),
      startTime: DateTime.now().copyWith(hour: 18, minute: 0),
      endTime: DateTime.now().copyWith(hour: 20, minute: 0),
      reason: 'งานเร่งด่วนสำหรับลูกค้า',
      status: OtStatus.pending,
    );

    print('1. สร้าง OT request: ${otRequest.reason}');
    await otService.createOtRequest(otRequest);

    // 2. Approve the OT request
    print('2. อนุมัติ OT request...');
    await otService.approveOtRequest(otRequest.id, otRate: 1.5);

    // 3. Load approved OT data into attendance
    print('3. โหลดข้อมูล OT ที่อนุมัติแล้วเข้าสู่ระบบบันทึกเวลา...');
    final approvedOtData = await integrationService
        .getApprovedOtForEmployeeAndDate('EMP001', DateTime.now());

    if (approvedOtData != null) {
      print('✅ พบข้อมูล OT ที่อนุมัติแล้ว:');
      print('   - เวลาเริ่ม OT: ${approvedOtData['otStart']}');
      print('   - เวลาสิ้นสุด OT: ${approvedOtData['otEnd']}');
      print('   - อัตราการจ่าย: x${approvedOtData['otRate']}');
      print('   - เหตุผล: ${approvedOtData['otReason']}');
    }

    // 4. Create attendance record with OT data
    final employee = EmployeeAttendance(
      id: 'EMP001',
      name: 'สมชาย ใจดี',
      records: {},
    );

    await integrationService.updateAttendanceWithApprovedOt(
      employee,
      DateTime.now(),
    );

    print('4. อัปเดตข้อมูลบันทึกเวลาด้วยข้อมูล OT ที่อนุมัติแล้ว');
    final todayRecord = employee.records[DateTime.now()];
    if (todayRecord != null && todayRecord['otStart'] != null) {
      print('✅ ข้อมูล OT ถูกเพิ่มเข้าสู่บันทึกเวลาแล้ว');
    }

    print('\n🎉 การเชื่อมต่อระบบ OT และ Attendance สำเร็จ!');
  }

  /// Features that are now available:
  ///
  /// 1. **Auto-sync OT to Attendance**: เมื่ออนุมัติ OT แล้ว ข้อมูลจะแสดงใน attendance dialog อัตโนมัติ
  ///
  /// 2. **Read-only approved OT**: ข้อมูล OT ที่อนุมัติแล้วจะไม่สามารถแก้ไขได้ใน attendance dialog
  ///
  /// 3. **Visual indicators**: แสดงสถานะ "อนุมัติแล้ว" และเหตุผลของ OT ใน attendance dialog
  ///
  /// 4. **Card display**: attendance card แสดงข้อมูล OT พร้อมสถานะการอนุมัติ
  ///
  /// 5. **Data integrity**: ข้อมูล OT ที่อนุมัติแล้วจะไม่สูญหายและแสดงตรงกัน
}

/// How it works:
///
/// 1. User submits OT request in OT tab
/// 2. Admin approves OT request in OT tab
/// 3. When user opens attendance edit dialog, the system automatically:
///    - Loads approved OT data for that employee and date
///    - Shows OT times, rate, and reason
///    - Makes OT fields read-only (cannot be modified)
///    - Shows "อนุมัติแล้ว" indicator
/// 4. Attendance card shows OT info with approval status
/// 5. Data remains consistent between OT and Attendance systems
