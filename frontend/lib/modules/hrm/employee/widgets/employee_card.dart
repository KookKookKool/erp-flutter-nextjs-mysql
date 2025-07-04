//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '/modules/hrm/employee/employee_list_screen.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final String? positionLabel;
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    this.positionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: employee.image != null
            ? CircleAvatar(backgroundImage: FileImage(employee.image!))
            : const CircleAvatar(child: Icon(Icons.person)),
        title: Text('${employee.firstName} ${employee.lastName}'),
        subtitle: Text(
          '${positionLabel ?? l10n?.position ?? 'ตำแหน่ง'}: ${employee.position}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          tooltip: l10n?.editEmployee ?? 'Edit',
          onPressed: onEdit,
        ),
      ),
    );
  }
}
