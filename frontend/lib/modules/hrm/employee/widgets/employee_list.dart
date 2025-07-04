import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import '../employee_list_screen.dart';
import 'employee_card.dart';

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;
  final void Function(Employee emp) onEdit;
  final String? positionLabel;
  const EmployeeList({
    super.key,
    required this.employees,
    required this.onEdit,
    this.positionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: employees.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final emp = employees[i];
          return EmployeeCard(
            employee: emp,
            onEdit: () => onEdit(emp),
            positionLabel: positionLabel ?? l10n?.position ?? 'ตำแหน่ง',
          );
        },
      ),
    );
  }
}
