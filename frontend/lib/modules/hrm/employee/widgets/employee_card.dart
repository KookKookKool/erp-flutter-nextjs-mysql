//import 'dart:io';
import 'package:flutter/material.dart';
import '/modules/hrm/employee/employee_list_screen.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  const EmployeeCard({super.key, required this.employee, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: employee.image != null
            ? CircleAvatar(backgroundImage: FileImage(employee.image!))
            : const CircleAvatar(child: Icon(Icons.person)),
        title: Text('${employee.firstName} ${employee.lastName}'),
        subtitle: Text(employee.position),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
      ),
    );
  }
}
