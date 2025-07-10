import '../models/payroll_employee.dart';

class PayrollService {
  static final PayrollService _instance = PayrollService._internal();
  factory PayrollService() => _instance;
  PayrollService._internal();

  // Mock data for demonstration
  final List<PayrollEmployee> _payrollEmployees = [
    PayrollEmployee(
      id: '1',
      employeeId: 'EMP001',
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      payrollType: PayrollType.monthly,
      salary: 25000.0,
      socialSecurity: 750.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PayrollEmployee(
      id: '2',
      employeeId: 'EMP002',
      firstName: 'สมหญิง',
      lastName: 'มีสุข',
      payrollType: PayrollType.daily,
      salary: 500.0,
      socialSecurity: 0.0,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PayrollEmployee(
      id: '3',
      employeeId: 'EMP003',
      firstName: 'วิชัย',
      lastName: 'เก่งกาจ',
      payrollType: PayrollType.monthly,
      salary: 35000.0,
      socialSecurity: 750.0,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Mock employee data for selection
  final List<Employee> _allEmployees = [
    Employee(
      id: '1',
      employeeId: 'EMP001',
      firstName: 'สมชาย',
      lastName: 'ใจดี',
    ),
    Employee(
      id: '2',
      employeeId: 'EMP002',
      firstName: 'สมหญิง',
      lastName: 'มีสุข',
    ),
    Employee(
      id: '3',
      employeeId: 'EMP003',
      firstName: 'วิชัย',
      lastName: 'เก่งกาจ',
    ),
    Employee(
      id: '4',
      employeeId: 'EMP004',
      firstName: 'จิรา',
      lastName: 'สวยงาม',
    ),
    Employee(
      id: '5',
      employeeId: 'EMP005',
      firstName: 'นิรันดร์',
      lastName: 'ซื่อสัตย์',
    ),
  ];

  List<PayrollEmployee> getAllPayrollEmployees() {
    return List.unmodifiable(_payrollEmployees);
  }

  List<Employee> getAllEmployees() {
    return List.unmodifiable(_allEmployees);
  }

  List<Employee> getAvailableEmployees() {
    final existingEmployeeIds = _payrollEmployees
        .map((e) => e.employeeId)
        .toSet();
    return _allEmployees
        .where((emp) => !existingEmployeeIds.contains(emp.employeeId))
        .toList();
  }

  Future<PayrollEmployee> addPayrollEmployee({
    required String employeeId,
    required String firstName,
    required String lastName,
    required PayrollType payrollType,
    required double salary,
    required double socialSecurity,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call

    final newEmployee = PayrollEmployee(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      employeeId: employeeId,
      firstName: firstName,
      lastName: lastName,
      payrollType: payrollType,
      salary: salary,
      socialSecurity: socialSecurity,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _payrollEmployees.add(newEmployee);
    return newEmployee;
  }

  Future<PayrollEmployee> updatePayrollEmployee(
    PayrollEmployee employee,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call

    final index = _payrollEmployees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      final updatedEmployee = employee.copyWith(updatedAt: DateTime.now());
      _payrollEmployees[index] = updatedEmployee;
      return updatedEmployee;
    }
    throw Exception('Employee not found');
  }

  Future<void> deletePayrollEmployee(String id) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call
    _payrollEmployees.removeWhere((e) => e.id == id);
  }

  Future<void> exportPayslips(List<String> employeeIds) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate PDF generation
    // In real implementation, this would generate and export PDF files
    // TODO: Implement actual PDF export functionality
  }
}
