import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  void loadAttendances(List attendances) {
    emit(AttendanceLoaded(attendances));
  }

  void error(String message) {
    emit(AttendanceError(message));
  }
}
