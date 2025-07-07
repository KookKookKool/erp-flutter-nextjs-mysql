import 'package:flutter_bloc/flutter_bloc.dart';
import '../leave_repository.dart';

class LeaveState {
  final List<Leave> leaves;
  LeaveState(this.leaves);
}

class LeaveCubit extends Cubit<LeaveState> {
  final LeaveRepository repository;
  LeaveCubit(this.repository) : super(LeaveState(repository.leaves));

  void loadLeaves() {
    emit(LeaveState(repository.leaves));
  }

  void addLeave(Leave leave) {
    repository.addLeave(leave);
    loadLeaves();
  }

  void updateLeave(Leave leave) {
    repository.updateLeave(leave);
    loadLeaves();
  }

  void deleteLeave(String id) {
    repository.deleteLeave(id);
    loadLeaves();
  }

  void approveLeave(String id, bool approve, {bool deductSalary = false}) {
    repository.approveLeave(id, approve, deductSalary: deductSalary);
    loadLeaves();
  }

  void editLeave(Leave leave) {
    repository.editLeave(leave);
    emit(LeaveState(List.from(repository.leaves)));
  }
}
