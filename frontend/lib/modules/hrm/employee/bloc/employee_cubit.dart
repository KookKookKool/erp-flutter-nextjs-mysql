import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/hrm/employee/services/employee_service.dart';
// import Employee model ถ้าไม่ได้ export จาก employee_service.dart
// import 'package:frontend/modules/hrm/employee/services/employee_service.dart' show Employee;

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeService service;
  EmployeeCubit() : service = EmployeeService(), super(EmployeeInitial());

  Future<void> fetchEmployees() async {
    emit(EmployeeLoading());
    try {
      final employees = await service.fetchEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}
