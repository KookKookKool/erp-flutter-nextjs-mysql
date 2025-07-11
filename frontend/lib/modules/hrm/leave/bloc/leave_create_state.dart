part of 'package:frontend/modules/hrm/leave/bloc/leave_create_cubit.dart';

abstract class LeaveCreateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LeaveCreateInitial extends LeaveCreateState {}

class LeaveCreateLoading extends LeaveCreateState {}

class LeaveCreateSuccess extends LeaveCreateState {}

class LeaveCreateError extends LeaveCreateState {
  final String message;
  LeaveCreateError(this.message);
  @override
  List<Object?> get props => [message];
}
