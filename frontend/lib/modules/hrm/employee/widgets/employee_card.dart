//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/modules/hrm/employee/employee_list_screen.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/theme/widget_styles.dart';

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
    final theme = Theme.of(context);
    return SizedBox(
      height: WidgetStyles.cardHeightSmall,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
        ),
        color: SunTheme.cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // จัดกึ่งกลางแนวนอน
              children: [
                employee.image != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(employee.image!),
                        backgroundColor: SunTheme.sunOrange.withValues(
                          alpha: 0.1,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: SunTheme.sunOrange.withValues(
                          alpha: 0.1,
                        ),
                        child: Icon(Icons.person, color: SunTheme.sunOrange),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center, // จัดกึ่งกลางแนวตั้ง
                    children: [
                      Text(
                        '${employee.firstName} ${employee.lastName}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: SunTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${employee.employeeId} • ${employee.position}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: SunTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: SunTheme.textSecondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: SunTheme.sunOrange, size: 20),
                          const SizedBox(width: 12),
                          const Text('แก้ไข'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
