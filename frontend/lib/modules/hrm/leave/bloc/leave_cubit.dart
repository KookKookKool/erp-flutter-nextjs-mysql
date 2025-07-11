import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/hrm/leave/leave_repository.dart';

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

  void approveLeave(String id, {bool deductSalary = false}) {
    repository.approveLeave(id, true, deductSalary: deductSalary);
    loadLeaves();
  }

  void rejectLeave(String id) {
    repository.approveLeave(id, false);
    loadLeaves();
  }

  void approveLeaveOld(String id, bool approve, {bool deductSalary = false}) {
    repository.approveLeave(id, approve, deductSalary: deductSalary);
    loadLeaves();
  }

  void editLeave(Leave leave) {
    if (leave.id.startsWith('TEMP_ID') || leave.id.startsWith('EMP')) {
      // สำหรับการเพิ่มใหม่ ให้สร้าง unique ID
      addLeave(leave);
    } else {
      // สำหรับการแก้ไขข้อมูลเดิม
      repository.updateLeave(leave);
      loadLeaves();
    }
  }
}
