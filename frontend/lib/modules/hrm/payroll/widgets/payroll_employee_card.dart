import 'package:flutter/material.dart';
import '../models/payroll_employee.dart';
import '../../../../core/theme/sun_theme.dart';
import '../../../../core/theme/widget_styles.dart';
import '../../../../core/l10n/app_localizations.dart';

class PayrollEmployeeCard extends StatelessWidget {
  final PayrollEmployee employee;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSelectionToggle;

  const PayrollEmployeeCard({
    super.key,
    required this.employee,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSelectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currencyFormat = 'THB ${employee.salary.toStringAsFixed(0)}';

    return Card(
      elevation: isSelected ? 8 : 2,
      color: SunTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
        side: isSelected
            ? BorderSide(color: SunTheme.sunOrange, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    SunTheme.sunOrange.withOpacity(0.05),
                    SunTheme.sunLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with selection and employee info
                Row(
                  children: [
                    // Custom checkbox with animation
                    GestureDetector(
                      onTap: onSelectionToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? SunTheme.sunOrange
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? SunTheme.sunOrange
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Employee avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: isSelected
                          ? SunTheme.sunOrange
                          : SunTheme.sunOrange.withOpacity(0.1),
                      child: Text(
                        employee.fullName.isNotEmpty
                            ? employee.fullName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: isSelected ? Colors.white : SunTheme.sunOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Employee basic info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? SunTheme.sunOrange
                                  : SunTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            employee.employeeId,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: SunTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions menu
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: isSelected
                            ? SunTheme.sunOrange
                            : Colors.grey.shade600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit();
                            break;
                          case 'delete':
                            onDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18,
                                color: SunTheme.sunOrange,
                              ),
                              const SizedBox(width: 8),
                              Text(l10n.payrollEdit),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.red.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(l10n.payrollDelete),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Employee details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Payroll type
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: employee.payrollType == PayrollType.monthly
                                  ? Colors.blue.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    employee.payrollType == PayrollType.monthly
                                    ? Colors.blue.shade200
                                    : Colors.green.shade200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  employee.payrollType == PayrollType.monthly
                                      ? Icons.calendar_month
                                      : Icons.today,
                                  size: 14,
                                  color:
                                      employee.payrollType ==
                                          PayrollType.monthly
                                      ? Colors.blue.shade700
                                      : Colors.green.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getPayrollTypeLabel(l10n, employee.payrollType),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        employee.payrollType ==
                                            PayrollType.monthly
                                        ? Colors.blue.shade700
                                        : Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Salary amount
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  SunTheme.sunOrange.withOpacity(0.1),
                                  SunTheme.sunYellow.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: SunTheme.sunOrange.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              currencyFormat,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: SunTheme.sunDeepOrange,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Last updated info
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.payrollLastUpdated(
                              _formatDate(employee.updatedAt),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPayrollTypeLabel(AppLocalizations l10n, PayrollType type) {
    switch (type) {
      case PayrollType.monthly:
        return l10n.payrollTypeMonthly;
      case PayrollType.daily:
        return l10n.payrollTypeDaily;
    }
  }
}
