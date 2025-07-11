import 'package:frontend/modules/hrm/attendance/models/ot_request.dart';
import 'package:frontend/modules/hrm/attendance/attendance_screen.dart';
import 'package:frontend/modules/hrm/attendance/services/ot_data_service.dart';

/// Service to integrate OT data with Attendance records
class AttendanceOtIntegrationService {
  static final AttendanceOtIntegrationService _instance =
      AttendanceOtIntegrationService._internal();
  factory AttendanceOtIntegrationService() => _instance;
  AttendanceOtIntegrationService._internal();

  final OtDataService _otDataService = OtDataService();

  /// Get approved OT records for a specific employee and date
  Future<Map<String, dynamic>?> getApprovedOtForEmployeeAndDate(
    String employeeId,
    DateTime date,
  ) async {
    try {
      final approvedOtRequests = await _otDataService.getOtRequestsByStatus(
        OtStatus.approved,
      );

      // Find OT request for this employee and date
      final otRequest = approvedOtRequests
          .where(
            (ot) =>
                ot.employeeId == employeeId &&
                ot.date.year == date.year &&
                ot.date.month == date.month &&
                ot.date.day == date.day,
          )
          .firstOrNull;

      if (otRequest != null) {
        return {
          'otStart': otRequest.startTime,
          'otEnd': otRequest.endTime,
          'otRate': otRequest.rate ?? 1.5,
          'otRequestId': otRequest.id,
          'otReason': otRequest.reason,
        };
      }

      return null;
    } catch (e) {
      print('Error getting approved OT: $e');
      return null;
    }
  }

  /// Update attendance record with approved OT data
  Future<void> updateAttendanceWithApprovedOt(
    EmployeeAttendance employee,
    DateTime date,
  ) async {
    final otData = await getApprovedOtForEmployeeAndDate(employee.id, date);

    if (otData != null) {
      // Get existing attendance record or create new one
      final existingRecord =
          employee.records[date] ?? {'in': null, 'out': null};

      // Update with OT data
      employee.records[date] = {
        ...existingRecord,
        'otStart': otData['otStart'],
        'otEnd': otData['otEnd'],
        'otRate': otData['otRate'],
        'otRequestId': otData['otRequestId'],
        'otReason': otData['otReason'],
      };
    }
  }

  /// Bulk update all attendance records with approved OT data
  Future<void> updateAllAttendanceWithApprovedOt(
    List<EmployeeAttendance> employees,
  ) async {
    for (final employee in employees) {
      // Check for approved OT in the last 30 days
      final now = DateTime.now();
      for (int i = 0; i < 30; i++) {
        final date = DateTime(now.year, now.month, now.day - i);
        await updateAttendanceWithApprovedOt(employee, date);
      }
    }
  }

  /// Get OT summary for an employee in a date range
  Future<List<Map<String, dynamic>>> getOtSummaryForEmployee(
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final otRequests = await _otDataService.getOtRequestsByDateRange(
        startDate,
        endDate,
      );

      return otRequests
          .where(
            (ot) =>
                ot.employeeId == employeeId && ot.status == OtStatus.approved,
          )
          .map(
            (ot) => {
              'date': ot.date,
              'startTime': ot.startTime,
              'endTime': ot.endTime,
              'duration': ot.endTime.difference(ot.startTime).inHours,
              'rate': ot.rate ?? 1.5,
              'reason': ot.reason,
            },
          )
          .toList();
    } catch (e) {
      print('Error getting OT summary: $e');
      return [];
    }
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
