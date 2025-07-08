import 'package:flutter/foundation.dart';

class Leave {
  final String id; // unique leave request ID
  final String employeeId; // employee ID
  final String employeeName; // employee name
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String note;
  String status; // 'pending', 'approved', 'rejected'
  bool deductSalary;

  Leave({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.note,
    this.status = 'pending',
    this.deductSalary = false,
  });

  // Backward compatibility getter
  String get employee => employeeName;

  Leave copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? note,
    String? status,
    bool? deductSalary,
  }) {
    return Leave(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      note: note ?? this.note,
      status: status ?? this.status,
      deductSalary: deductSalary ?? this.deductSalary,
    );
  }
}

class LeaveRepository extends ChangeNotifier {
  final List<Leave> _leaves = [
    Leave(
      id: 'LEAVE_001',
      employeeId: 'EMP001',
      employeeName: 'สมชาย ใจดี',
      startDate: DateTime(2025, 7, 10),
      endDate: DateTime(2025, 7, 12),
      type: 'personal',
      note: 'ไปธุระส่วนตัว',
      status: 'approved',
      deductSalary: false,
    ),
    Leave(
      id: 'LEAVE_002',
      employeeId: 'EMP002',
      employeeName: 'สมหญิง ขยัน',
      startDate: DateTime(2025, 7, 15),
      endDate: DateTime(2025, 7, 16),
      type: 'sick',
      note: 'ไม่สบาย',
      status: 'pending',
      deductSalary: false,
    ),
    Leave(
      id: 'LEAVE_003',
      employeeId: 'EMP003',
      employeeName: 'John Doe',
      startDate: DateTime(2025, 7, 20),
      endDate: DateTime(2025, 7, 22),
      type: 'vacation',
      note: 'ไปเที่ยว',
      status: 'rejected',
      deductSalary: true,
    ),
  ];

  List<Leave> get leaves => List.unmodifiable(_leaves);

  String _generateLeaveId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'LEAVE_$timestamp';
  }

  void addLeave(Leave leave) {
    // Generate unique ID if not provided or if it's an employee ID
    String uniqueId = leave.id;
    if (leave.id.startsWith('EMP') || _leaves.any((l) => l.id == leave.id)) {
      uniqueId = _generateLeaveId();
    }

    final newLeave = leave.copyWith(id: uniqueId);
    _leaves.add(newLeave);
    notifyListeners();
  }

  void updateLeave(Leave leave) {
    final idx = _leaves.indexWhere((l) => l.id == leave.id);
    if (idx != -1) {
      _leaves[idx] = leave;
      notifyListeners();
    }
  }

  void deleteLeave(String id) {
    _leaves.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void approveLeave(String id, bool approve, {bool deductSalary = false}) {
    final idx = _leaves.indexWhere((l) => l.id == id);
    if (idx != -1) {
      _leaves[idx] = _leaves[idx].copyWith(
        status: approve ? 'approved' : 'rejected',
        deductSalary: approve ? deductSalary : false,
      );
      notifyListeners();
    }
  }
}
