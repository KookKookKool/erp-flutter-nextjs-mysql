import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ot_request.dart';
import '../services/ot_data_service.dart';
import 'ot_state.dart';

class OtCubit extends Cubit<OtState> {
  final OtDataService _otDataService;

  OtCubit(this._otDataService) : super(OtInitial());

  /// Load all OT requests
  Future<void> loadOtRequests() async {
    emit(OtLoading());
    try {
      final requests = await _otDataService.getOtRequests();
      emit(OtLoaded(requests));
    } catch (e) {
      emit(OtError('Failed to load OT requests: $e'));
    }
  }

  /// Submit new OT request
  Future<void> submitOtRequest(OtRequest request) async {
    emit(OtSubmitting());
    try {
      await _otDataService.createOtRequest(request);
      emit(OtSubmitted('OT request submitted successfully'));
      // Reload the list after submission
      await loadOtRequests();
    } catch (e) {
      emit(OtError('Failed to submit OT request: $e'));
    }
  }

  /// Approve OT request and update attendance records
  Future<void> approveOtRequest(String requestId, {double? otRate}) async {
    emit(OtProcessing());
    try {
      await _otDataService.approveOtRequest(requestId, otRate: otRate);
      emit(OtProcessed('OT request approved successfully'));

      // Note: Integration with attendance will happen when attendance screen loads
      // The attendance screen will automatically pick up approved OT data

      // Reload the list after approval
      await loadOtRequests();
    } catch (e) {
      emit(OtError('Failed to approve OT request: $e'));
    }
  }

  /// Reject OT request
  Future<void> rejectOtRequest(String requestId, {String? reason}) async {
    emit(OtProcessing());
    try {
      await _otDataService.rejectOtRequest(requestId, reason: reason);
      emit(OtProcessed('OT request rejected successfully'));
      // Reload the list after rejection
      await loadOtRequests();
    } catch (e) {
      emit(OtError('Failed to reject OT request: $e'));
    }
  }

  /// Update OT request
  Future<void> updateOtRequest(OtRequest request) async {
    emit(OtSubmitting());
    try {
      await _otDataService.updateOtRequest(request);
      emit(OtSubmitted('OT request updated successfully'));
      // Reload the list after update
      await loadOtRequests();
    } catch (e) {
      emit(OtError('Failed to update OT request: $e'));
    }
  }

  /// Delete OT request
  Future<void> deleteOtRequest(String requestId) async {
    emit(OtProcessing());
    try {
      await _otDataService.deleteOtRequest(requestId);
      emit(OtProcessed('OT request deleted successfully'));
      // Reload the list after deletion
      await loadOtRequests();
    } catch (e) {
      emit(OtError('Failed to delete OT request: $e'));
    }
  }

  /// Get OT requests by status
  Future<void> loadOtRequestsByStatus(OtStatus status) async {
    emit(OtLoading());
    try {
      final requests = await _otDataService.getOtRequestsByStatus(status);
      emit(OtLoaded(requests));
    } catch (e) {
      emit(OtError('Failed to load OT requests by status: $e'));
    }
  }

  /// Get OT requests by user
  Future<void> loadOtRequestsByUser(String userId) async {
    emit(OtLoading());
    try {
      final requests = await _otDataService.getOtRequestsByUser(userId);
      emit(OtLoaded(requests));
    } catch (e) {
      emit(OtError('Failed to load OT requests by user: $e'));
    }
  }

  /// Get OT requests by date range
  Future<void> loadOtRequestsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    emit(OtLoading());
    try {
      final requests = await _otDataService.getOtRequestsByDateRange(
        startDate,
        endDate,
      );
      emit(OtLoaded(requests));
    } catch (e) {
      emit(OtError('Failed to load OT requests by date range: $e'));
    }
  }

  /// Reset state to initial
  void resetState() {
    emit(OtInitial());
  }
}
