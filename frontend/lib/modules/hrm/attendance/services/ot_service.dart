import 'package:frontend/modules/hrm/attendance/models/ot_request.dart';
import 'package:frontend/modules/hrm/attendance/services/ot_data_service.dart';

class OtService {
  static final OtService _instance = OtService._internal();
  factory OtService() => _instance;
  OtService._internal();

  final OtDataService _otDataService = OtDataService();

  /// Submit OT request from Home screen
  Future<void> submitOtRequest({
    required String employeeId,
    required String employeeName,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required String reason,
  }) async {
    final otRequest = OtRequest(
      id: 'OT${DateTime.now().millisecondsSinceEpoch}',
      employeeId: employeeId,
      employeeName: employeeName,
      date: date,
      startTime: startTime,
      endTime: endTime,
      reason: reason,
    );

    await _otDataService.createOtRequest(otRequest);
  }
}
