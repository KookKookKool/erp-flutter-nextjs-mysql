import 'package:flutter/material.dart';
import '../employee_list_screen.dart';
import 'employee_card.dart';

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;
  final void Function(Employee emp) onEdit;
  const EmployeeList({
    super.key,
    required this.employees,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, i) {
          final emp = employees[i];
          return EmployeeCard(employee: emp, onEdit: () => onEdit(emp));
        },
      ),
    );
  }
}
