//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import '/modules/hrm/employee/employee_list_screen.dart';
import 'package:frontend/core/theme/sun_theme.dart';

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
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: SunTheme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              employee.image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(employee.image!),
                      backgroundColor: SunTheme.primaryLight,
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.person),
                      backgroundColor: SunTheme.primaryLight,
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${employee.firstName} ${employee.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: SunTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${positionLabel ?? l10n?.position ?? 'ตำแหน่ง'}: ${employee.position}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: SunTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit, color: SunTheme.sunOrange),
            ],
          ),
        ),
      ),
    );
  }
}
