import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'leave_create_state.dart';

class LeaveCreateCubit extends Cubit<LeaveCreateState> {
  LeaveCreateCubit() : super(LeaveCreateInitial());

  Future<void> createLeave({
    required String type,
    required DateTime date,
    required String reason,
  }) async {
    emit(LeaveCreateLoading());
    try {
      // TODO: Replace with actual API call or repository logic
      await Future.delayed(const Duration(seconds: 1));
      emit(LeaveCreateSuccess());
    } catch (e) {
      emit(LeaveCreateError('Failed to create leave'));
    }
  }
}
