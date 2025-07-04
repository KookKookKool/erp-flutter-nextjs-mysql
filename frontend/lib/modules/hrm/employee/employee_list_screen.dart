import 'dart:io';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/employee_dialog.dart';
import 'widgets/employee_search_bar.dart';
import 'widgets/employee_list.dart';

class Employee {
  File? image;
  String firstName;
  String lastName;
  String employeeId;
  String level;
  String position;
  String email;
  String phone;
  String startDate;
  String password;
  Employee({
    this.image,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.level,
    required this.position,
    required this.email,
    required this.phone,
    required this.startDate,
    required this.password,
  });
}

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final List<Employee> employees = [
    Employee(
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      employeeId: 'EMP001',
      level: 'Manager',
      position: 'HR',
      email: 'somchai@example.com',
      phone: '0812345678',
      startDate: '2023-01-01',
      password: 'password123',
    ),
  ];
  String _search = '';

  List<Employee> get _filteredEmployees {
    if (_search.isEmpty) return employees;
    return employees
        .where(
          (e) =>
              e.firstName.contains(_search) ||
              e.lastName.contains(_search) ||
              e.employeeId.contains(_search),
        )
        .toList();
  }

  void _addOrEditEmployee({Employee? employee, int? index}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EmployeeDialog(
        employee: employee,
        onDelete: (employee != null && index != null)
            ? () {
                setState(() {
                  employees.removeAt(index);
                });
              }
            : null,
      ),
    );
    if (result != null && result is Employee) {
      setState(() {
        if (index != null) {
          employees[index] = result;
        } else {
          employees.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.employeeListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addEmployee,
            onPressed: () => _addOrEditEmployee(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EmployeeSearchBar(
              value: _search,
              onChanged: (v) => setState(() => _search = v),
              hintText: l10n.searchHint,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: EmployeeList(
                employees: _filteredEmployees,
                onEdit: (emp) => _addOrEditEmployee(
                  employee: emp,
                  index: employees.indexOf(emp),
                ),
                positionLabel: l10n.position,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
