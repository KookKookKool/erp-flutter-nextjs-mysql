enum OtStatus { pending, approved, rejected }

class OtRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String reason;
  final OtStatus status;
  final double? rate; // เรทที่อนุมัติ (x1.5, x3.0)

  OtRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reason,
    this.status = OtStatus.pending,
    this.rate,
  });

  OtRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? reason,
    OtStatus? status,
    double? rate,
  }) {
    return OtRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      rate: rate ?? this.rate,
    );
  }
}
