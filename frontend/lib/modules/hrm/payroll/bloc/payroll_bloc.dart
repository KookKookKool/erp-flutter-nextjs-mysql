import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/payroll_employee.dart';
import '../services/payroll_service.dart';

// Events
abstract class PayrollEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPayrollEmployees extends PayrollEvent {}

class LoadAvailableEmployees extends PayrollEvent {}

class AddPayrollEmployee extends PayrollEvent {
  final String employeeId;
  final String firstName;
  final String lastName;
  final PayrollType payrollType;
  final double salary;
  final double socialSecurity;

  AddPayrollEmployee({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.payrollType,
    required this.salary,
    required this.socialSecurity,
  });

  @override
  List<Object?> get props => [
    employeeId,
    firstName,
    lastName,
    payrollType,
    salary,
    socialSecurity,
  ];
}

class UpdatePayrollEmployee extends PayrollEvent {
  final PayrollEmployee employee;

  UpdatePayrollEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeletePayrollEmployee extends PayrollEvent {
  final String employeeId;

  DeletePayrollEmployee(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class ToggleEmployeeSelection extends PayrollEvent {
  final String employeeId;

  ToggleEmployeeSelection(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class SelectAllEmployees extends PayrollEvent {}

class ClearAllSelection extends PayrollEvent {}

class ExportPayslips extends PayrollEvent {
  final List<String> employeeIds;

  ExportPayslips(this.employeeIds);

  @override
  List<Object?> get props => [employeeIds];
}

// States
abstract class PayrollState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PayrollInitial extends PayrollState {}

class PayrollLoading extends PayrollState {}

class PayrollLoaded extends PayrollState {
  final List<PayrollEmployee> payrollEmployees;
  final List<Employee> availableEmployees;
  final Set<String> selectedEmployeeIds;
  final bool isExporting;

  PayrollLoaded({
    required this.payrollEmployees,
    required this.availableEmployees,
    this.selectedEmployeeIds = const {},
    this.isExporting = false,
  });

  PayrollLoaded copyWith({
    List<PayrollEmployee>? payrollEmployees,
    List<Employee>? availableEmployees,
    Set<String>? selectedEmployeeIds,
    bool? isExporting,
  }) {
    return PayrollLoaded(
      payrollEmployees: payrollEmployees ?? this.payrollEmployees,
      availableEmployees: availableEmployees ?? this.availableEmployees,
      selectedEmployeeIds: selectedEmployeeIds ?? this.selectedEmployeeIds,
      isExporting: isExporting ?? this.isExporting,
    );
  }

  @override
  List<Object?> get props => [
    payrollEmployees,
    availableEmployees,
    selectedEmployeeIds,
    isExporting,
  ];
}

class PayrollError extends PayrollState {
  final String message;

  PayrollError(this.message);

  @override
  List<Object?> get props => [message];
}

class PayrollSuccess extends PayrollState {
  final String message;

  PayrollSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class PayrollBloc extends Bloc<PayrollEvent, PayrollState> {
  final PayrollService _payrollService;

  PayrollBloc(this._payrollService) : super(PayrollInitial()) {
    on<LoadPayrollEmployees>(_onLoadPayrollEmployees);
    on<LoadAvailableEmployees>(_onLoadAvailableEmployees);
    on<AddPayrollEmployee>(_onAddPayrollEmployee);
    on<UpdatePayrollEmployee>(_onUpdatePayrollEmployee);
    on<DeletePayrollEmployee>(_onDeletePayrollEmployee);
    on<ToggleEmployeeSelection>(_onToggleEmployeeSelection);
    on<SelectAllEmployees>(_onSelectAllEmployees);
    on<ClearAllSelection>(_onClearAllSelection);
    on<ExportPayslips>(_onExportPayslips);
  }

  Future<void> _onLoadPayrollEmployees(
    LoadPayrollEmployees event,
    Emitter<PayrollState> emit,
  ) async {
    emit(PayrollLoading());
    try {
      final payrollEmployees = _payrollService.getAllPayrollEmployees();
      final availableEmployees = _payrollService.getAvailableEmployees();
      emit(
        PayrollLoaded(
          payrollEmployees: payrollEmployees,
          availableEmployees: availableEmployees,
        ),
      );
    } catch (e) {
      emit(PayrollError('Failed to load payroll employees: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAvailableEmployees(
    LoadAvailableEmployees event,
    Emitter<PayrollState> emit,
  ) async {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      try {
        final availableEmployees = _payrollService.getAvailableEmployees();
        emit(currentState.copyWith(availableEmployees: availableEmployees));
      } catch (e) {
        emit(
          PayrollError('Failed to load available employees: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> _onAddPayrollEmployee(
    AddPayrollEmployee event,
    Emitter<PayrollState> emit,
  ) async {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      emit(PayrollLoading());
      try {
        await _payrollService.addPayrollEmployee(
          employeeId: event.employeeId,
          firstName: event.firstName,
          lastName: event.lastName,
          payrollType: event.payrollType,
          salary: event.salary,
          socialSecurity: event.socialSecurity,
        );

        final payrollEmployees = _payrollService.getAllPayrollEmployees();
        final availableEmployees = _payrollService.getAvailableEmployees();

        emit(
          PayrollLoaded(
            payrollEmployees: payrollEmployees,
            availableEmployees: availableEmployees,
            selectedEmployeeIds: currentState.selectedEmployeeIds,
          ),
        );

        emit(PayrollSuccess('เพิ่มข้อมูลเงินเดือนเรียบร้อยแล้ว'));
      } catch (e) {
        emit(PayrollError('Failed to add payroll employee: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdatePayrollEmployee(
    UpdatePayrollEmployee event,
    Emitter<PayrollState> emit,
  ) async {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      emit(PayrollLoading());
      try {
        await _payrollService.updatePayrollEmployee(event.employee);
        final payrollEmployees = _payrollService.getAllPayrollEmployees();

        emit(currentState.copyWith(payrollEmployees: payrollEmployees));
        emit(PayrollSuccess('อัปเดตข้อมูลเงินเดือนเรียบร้อยแล้ว'));
      } catch (e) {
        emit(
          PayrollError('Failed to update payroll employee: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> _onDeletePayrollEmployee(
    DeletePayrollEmployee event,
    Emitter<PayrollState> emit,
  ) async {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      emit(PayrollLoading());
      try {
        await _payrollService.deletePayrollEmployee(event.employeeId);
        final payrollEmployees = _payrollService.getAllPayrollEmployees();
        final availableEmployees = _payrollService.getAvailableEmployees();

        emit(
          PayrollLoaded(
            payrollEmployees: payrollEmployees,
            availableEmployees: availableEmployees,
            selectedEmployeeIds: currentState.selectedEmployeeIds
              ..remove(event.employeeId),
          ),
        );

        emit(PayrollSuccess('ลบข้อมูลเงินเดือนเรียบร้อยแล้ว'));
      } catch (e) {
        emit(
          PayrollError('Failed to delete payroll employee: ${e.toString()}'),
        );
      }
    }
  }

  void _onToggleEmployeeSelection(
    ToggleEmployeeSelection event,
    Emitter<PayrollState> emit,
  ) {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      final selectedIds = Set<String>.from(currentState.selectedEmployeeIds);

      if (selectedIds.contains(event.employeeId)) {
        selectedIds.remove(event.employeeId);
      } else {
        selectedIds.add(event.employeeId);
      }

      emit(currentState.copyWith(selectedEmployeeIds: selectedIds));
    }
  }

  void _onSelectAllEmployees(
    SelectAllEmployees event,
    Emitter<PayrollState> emit,
  ) {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      final allIds = currentState.payrollEmployees.map((e) => e.id).toSet();
      emit(currentState.copyWith(selectedEmployeeIds: allIds));
    }
  }

  void _onClearAllSelection(
    ClearAllSelection event,
    Emitter<PayrollState> emit,
  ) {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      emit(currentState.copyWith(selectedEmployeeIds: <String>{}));
    }
  }

  Future<void> _onExportPayslips(
    ExportPayslips event,
    Emitter<PayrollState> emit,
  ) async {
    if (state is PayrollLoaded) {
      final currentState = state as PayrollLoaded;
      emit(currentState.copyWith(isExporting: true));

      try {
        await _payrollService.exportPayslips(event.employeeIds);
        emit(currentState.copyWith(isExporting: false));
        emit(PayrollSuccess('ส่งออกสลิปเงินเดือนเรียบร้อยแล้ว'));
      } catch (e) {
        emit(currentState.copyWith(isExporting: false));
        emit(PayrollError('Failed to export payslips: ${e.toString()}'));
      }
    }
  }
}
