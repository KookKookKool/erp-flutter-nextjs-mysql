import 'package:flutter/foundation.dart';

class Leave {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String employee;
  final String type;
  final String note;
  String status; // 'pending', 'approved', 'rejected'
  bool deductSalary;

  Leave({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.employee,
    required this.type,
    required this.note,
    this.status = 'pending',
    this.deductSalary = false,
  });

  Leave copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? employee,
    String? type,
    String? note,
    String? status,
    bool? deductSalary,
  }) {
    return Leave(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      employee: employee ?? this.employee,
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
      id: 'EMP001',
      startDate: DateTime(2025, 7, 10),
      endDate: DateTime(2025, 7, 12),
      employee: 'สมชาย ใจดี',
      type: 'personal',
      note: 'ไปธุระส่วนตัว',
      status: 'approved',
      deductSalary: false,
    ),
    Leave(
      id: 'EMP002',
      startDate: DateTime(2025, 7, 15),
      endDate: DateTime(2025, 7, 16),
      employee: 'สมหญิง ขยัน',
      type: 'sick',
      note: 'ไม่สบาย',
      status: 'pending',
      deductSalary: false,
    ),
    Leave(
      id: 'EMP003',
      startDate: DateTime(2025, 7, 20),
      endDate: DateTime(2025, 7, 22),
      employee: 'John Doe',
      type: 'vacation',
      note: 'ไปเที่ยว',
      status: 'rejected',
      deductSalary: true,
    ),
  ];

  List<Leave> get leaves => List.unmodifiable(_leaves);

  void addLeave(Leave leave) {
    _leaves.add(leave);
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

  void editLeave(Leave leave) {
    final idx = _leaves.indexWhere((l) => l.id == leave.id);
    if (idx != -1) {
      _leaves[idx] = leave;
      notifyListeners();
    }
  }
}
