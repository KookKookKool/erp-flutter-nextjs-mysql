part of 'attendance_cubit.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List attendances;
  AttendanceLoaded(this.attendances);
}

class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);
}
