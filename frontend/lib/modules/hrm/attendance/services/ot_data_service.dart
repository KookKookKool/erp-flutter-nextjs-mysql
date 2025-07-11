import 'package:frontend/modules/hrm/attendance/models/ot_request.dart';

class OtDataService {
  static final List<OtRequest> _otRequests = [];

  // สำหรับ mock data
  static List<OtRequest> getMockOtRequests() {
    final today = DateTime.now();
    return [
      OtRequest(
        id: 'OT001',
        employeeId: 'EMP001',
        employeeName: 'สมชาย ใจดี',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 18, 0),
        endTime: DateTime(today.year, today.month, today.day, 20, 0),
        reason: 'งานเร่งด่วน',
        status: OtStatus.pending,
      ),
      OtRequest(
        id: 'OT002',
        employeeId: 'EMP002',
        employeeName: 'สมหญิง ขยัน',
        date: today.subtract(const Duration(days: 1)),
        startTime: DateTime(today.year, today.month, today.day - 1, 17, 30),
        endTime: DateTime(today.year, today.month, today.day - 1, 19, 30),
        reason: 'ปิดงบเดือน',
        status: OtStatus.approved,
        rate: 1.5,
      ),
      OtRequest(
        id: 'OT003',
        employeeId: 'EMP003',
        employeeName: 'John Doe',
        date: today.subtract(const Duration(days: 2)),
        startTime: DateTime(today.year, today.month, today.day - 2, 19, 0),
        endTime: DateTime(today.year, today.month, today.day - 2, 22, 0),
        reason: 'Emergency maintenance',
        status: OtStatus.rejected,
      ),
    ];
  }

  // ดึงข้อมูล OT requests ทั้งหมด
  Future<List<OtRequest>> getOtRequests() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [..._otRequests, ...getMockOtRequests()];
  }

  // สร้าง OT request ใหม่
  Future<void> createOtRequest(OtRequest otRequest) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    _otRequests.add(otRequest);
  }

  // อัปเดต OT request
  Future<void> updateOtRequest(OtRequest updatedRequest) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _otRequests.indexWhere((ot) => ot.id == updatedRequest.id);
    if (index != -1) {
      _otRequests[index] = updatedRequest;
    }
  }

  // ลบ OT request
  Future<void> deleteOtRequest(String id) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    _otRequests.removeWhere((ot) => ot.id == id);
  }

  // อนุมัติ OT
  Future<void> approveOtRequest(String id, {double? otRate}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    final allRequests = [..._otRequests, ...getMockOtRequests()];
    final request = allRequests.firstWhere((ot) => ot.id == id);
    final updatedRequest = request.copyWith(
      status: OtStatus.approved,
      rate: otRate ?? 1.5,
    );

    final index = _otRequests.indexWhere((ot) => ot.id == id);
    if (index != -1) {
      _otRequests[index] = updatedRequest;
    } else {
      _otRequests.add(updatedRequest);
    }
  }

  // ปฏิเสธ OT
  Future<void> rejectOtRequest(String id, {String? reason}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    final allRequests = [..._otRequests, ...getMockOtRequests()];
    final request = allRequests.firstWhere((ot) => ot.id == id);
    final updatedRequest = request.copyWith(status: OtStatus.rejected);

    final index = _otRequests.indexWhere((ot) => ot.id == id);
    if (index != -1) {
      _otRequests[index] = updatedRequest;
    } else {
      _otRequests.add(updatedRequest);
    }
  }

  // ดึงข้อมูล OT requests ตาม status
  Future<List<OtRequest>> getOtRequestsByStatus(OtStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allRequests = [..._otRequests, ...getMockOtRequests()];
    return allRequests.where((ot) => ot.status == status).toList();
  }

  // ดึงข้อมูล OT requests ตาม user
  Future<List<OtRequest>> getOtRequestsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allRequests = [..._otRequests, ...getMockOtRequests()];
    return allRequests.where((ot) => ot.employeeId == userId).toList();
  }

  // ดึงข้อมูล OT requests ตาม date range
  Future<List<OtRequest>> getOtRequestsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allRequests = [..._otRequests, ...getMockOtRequests()];
    return allRequests
        .where(
          (ot) =>
              ot.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              ot.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  // เพิ่ม OT request ใหม่ (สำหรับ backward compatibility)
  static void addOtRequest(OtRequest otRequest) {
    _otRequests.add(otRequest);
  }

  // อัปเดต OT request (สำหรับ backward compatibility)
  static void updateOtRequestStatic(String id, OtRequest updatedRequest) {
    final index = _otRequests.indexWhere((ot) => ot.id == id);
    if (index != -1) {
      _otRequests[index] = updatedRequest;
    }
  }

  // ลบ OT request (สำหรับ backward compatibility)
  static void deleteOtRequestStatic(String id) {
    _otRequests.removeWhere((ot) => ot.id == id);
  }

  // ดึงข้อมูล OT requests ทั้งหมด (สำหรับ backward compatibility)
  static List<OtRequest> getAllOtRequests() {
    return [..._otRequests, ...getMockOtRequests()];
  }

  // อนุมัติ OT (สำหรับ backward compatibility)
  static void approveOt(String id, double rate) {
    final request = getAllOtRequests().firstWhere((ot) => ot.id == id);
    final updatedRequest = request.copyWith(
      status: OtStatus.approved,
      rate: rate,
    );
    updateOtRequestStatic(id, updatedRequest);
  }

  // ปฏิเสธ OT (สำหรับ backward compatibility)
  static void rejectOt(String id) {
    final request = getAllOtRequests().firstWhere((ot) => ot.id == id);
    final updatedRequest = request.copyWith(status: OtStatus.rejected);
    updateOtRequestStatic(id, updatedRequest);
  }
}
