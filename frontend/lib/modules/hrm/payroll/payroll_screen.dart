import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'package:frontend/core/utils/responsive_utils.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';

import 'package:frontend/modules/hrm/payroll/bloc/payroll_bloc.dart';
import 'package:frontend/modules/hrm/payroll/models/payroll_employee.dart';
import 'package:frontend/modules/hrm/payroll/services/payroll_service.dart';
import 'package:frontend/modules/hrm/payroll/widgets/payroll_employee_card.dart';
import 'package:frontend/modules/hrm/payroll/widgets/add_payroll_dialog.dart';
import 'package:frontend/modules/hrm/payroll/widgets/edit_payroll_dialog.dart';
import 'package:frontend/modules/hrm/payroll/widgets/payroll_search_bar.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PayrollBloc(PayrollService())..add(LoadPayrollEmployees()),
      child: const PayrollView(),
    );
  }
}

class PayrollView extends StatefulWidget {
  const PayrollView({super.key});

  @override
  State<PayrollView> createState() => _PayrollViewState();
}

class _PayrollViewState extends State<PayrollView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.payrollTitle),
        actions: [
          BlocBuilder<PayrollBloc, PayrollState>(
            builder: (context, state) {
              if (state is PayrollLoaded) {
                return IconButton(
                  onPressed: () =>
                      _showAddDialog(context, state.availableEmployees),
                  icon: const Icon(Icons.add),
                  tooltip: l10n.payrollAdd,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<PayrollBloc, PayrollState>(
        listener: (context, state) {
          if (state is PayrollError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is PayrollSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            // Reload data after success
            context.read<PayrollBloc>().add(LoadPayrollEmployees());
          }
        },
        child: CustomScrollView(
          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PayrollSearchBar(
                  value: _searchQuery,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                ),
              ),
            ),

            // Selection controls
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<PayrollBloc, PayrollState>(
                  builder: (context, state) {
                    if (state is PayrollLoaded &&
                        state.payrollEmployees.isNotEmpty) {
                      // Filter employees based on search query for selection controls
                      final filteredEmployees = _searchQuery.isEmpty
                          ? state.payrollEmployees
                          : state.payrollEmployees.where((employee) {
                              final searchLower = _searchQuery.toLowerCase();
                              return employee.fullName.toLowerCase().contains(
                                    searchLower,
                                  ) ||
                                  employee.employeeId.toLowerCase().contains(
                                    searchLower,
                                  );
                            }).toList();

                      if (filteredEmployees.isNotEmpty) {
                        return _buildSelectionControls(
                          context,
                          state,
                          isMobile,
                          filteredEmployees,
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            // Employee list
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<PayrollBloc, PayrollState>(
                  builder: (context, state) {
                    if (state is PayrollLoading) {
                      final l10n = AppLocalizations.of(context)!;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                SunTheme.sunOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.payrollLoading,
                              style: const TextStyle(
                                color: SunTheme.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is PayrollLoaded) {
                      if (state.payrollEmployees.isEmpty) {
                        return _buildEmptyState(
                          context,
                          state.availableEmployees,
                        );
                      }

                      // Filter employees based on search query
                      final filteredEmployees = _searchQuery.isEmpty
                          ? state.payrollEmployees
                          : state.payrollEmployees.where((employee) {
                              final searchLower = _searchQuery.toLowerCase();
                              return employee.fullName.toLowerCase().contains(
                                    searchLower,
                                  ) ||
                                  employee.employeeId.toLowerCase().contains(
                                    searchLower,
                                  );
                            }).toList();

                      // Show message if no results found
                      if (filteredEmployees.isEmpty) {
                        return _buildNoSearchResults();
                      }

                      return ResponsiveCardGrid(
                        cardHeight: WidgetStyles.cardHeightExtraLarge,
                        children: filteredEmployees.map((employee) {
                          final isSelected = state.selectedEmployeeIds.contains(
                            employee.id,
                          );

                          return PayrollEmployeeCard(
                            employee: employee,
                            isSelected: isSelected,
                            onTap: () =>
                                _showEmployeeDetails(context, employee),
                            onEdit: () => _showEditDialog(context, employee),
                            onDelete: () =>
                                _showDeleteConfirmation(context, employee),
                            onSelectionToggle: () {
                              context.read<PayrollBloc>().add(
                                ToggleEmployeeSelection(employee.id),
                              );
                            },
                          );
                        }).toList(),
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.payrollError,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: SunTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<PayrollBloc>().add(
                                LoadPayrollEmployees(),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.payrollTryAgain),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SunTheme.sunOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionControls(
    BuildContext context,
    PayrollLoaded state,
    bool isMobile, [
    List<PayrollEmployee>? filteredEmployees,
  ]) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final employees = filteredEmployees ?? state.payrollEmployees;
    final selectedCount = state.selectedEmployeeIds.length;
    final totalCount = employees.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selection info with icons
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selectedCount > 0
                      ? SunTheme.sunOrange.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  selectedCount > 0
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: selectedCount > 0
                      ? SunTheme.sunOrange
                      : Colors.grey.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCount > 0
                          ? l10n.payrollSelectedCount(selectedCount, totalCount)
                          : l10n.payrollAllSelected(totalCount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: selectedCount > 0
                            ? SunTheme.sunOrange
                            : SunTheme.textPrimary,
                      ),
                    ),
                    if (selectedCount == 0)
                      Text(
                        l10n.payrollMultiSelectHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: SunTheme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              // Action buttons
              if (selectedCount > 0) ...[
                TextButton.icon(
                  onPressed: () {
                    context.read<PayrollBloc>().add(ClearAllSelection());
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  label: Text(l10n.payrollClearSelection),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade600,
                  ),
                ),
              ] else ...[
                TextButton.icon(
                  onPressed: () {
                    context.read<PayrollBloc>().add(SelectAllEmployees());
                  },
                  icon: const Icon(Icons.select_all, size: 18),
                  label: Text(l10n.payrollSelectAll),
                  style: TextButton.styleFrom(
                    foregroundColor: SunTheme.sunOrange,
                  ),
                ),
              ],
            ],
          ),

          // Export button
          if (selectedCount > 0) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: state.isExporting
                    ? LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                      )
                    : const LinearGradient(
                        colors: [SunTheme.sunOrange, SunTheme.sunDeepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: state.isExporting
                    ? null
                    : [
                        BoxShadow(
                          color: SunTheme.sunOrange.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: ElevatedButton.icon(
                onPressed: state.isExporting
                    ? null
                    : () {
                        _showExportConfirmation(
                          context,
                          state.selectedEmployeeIds.toList(),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: state.isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf, size: 20),
                label: Text(
                  state.isExporting
                      ? l10n.payrollExporting
                      : l10n.payrollExport(selectedCount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    List<Employee> availableEmployees,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SunTheme.sunOrange.withValues(alpha: 0.1),
                  SunTheme.sunYellow.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.payments_outlined,
              size: 80,
              color: SunTheme.sunOrange.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          // Title and description
          Text(
            l10n.payrollNoData,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: SunTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.payrollNoDataDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: SunTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),

          // Action button
          Container(
            decoration: BoxDecoration(
              gradient: availableEmployees.isNotEmpty
                  ? const LinearGradient(
                      colors: [SunTheme.sunOrange, SunTheme.sunDeepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: availableEmployees.isNotEmpty
                  ? [
                      BoxShadow(
                        color: SunTheme.sunOrange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton.icon(
              onPressed: availableEmployees.isNotEmpty
                  ? () => _showAddDialog(context, availableEmployees)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: availableEmployees.isNotEmpty
                    ? Colors.transparent
                    : Colors.grey.shade300,
                foregroundColor: availableEmployees.isNotEmpty
                    ? Colors.white
                    : Colors.grey.shade600,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(
                availableEmployees.isNotEmpty
                    ? Icons.add_circle
                    : Icons.info_outline,
                size: 24,
              ),
              label: Text(
                availableEmployees.isNotEmpty
                    ? l10n.payrollAdd
                    : l10n.payrollNoAvailableEmployee,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Additional info for unavailable employees
          if (availableEmployees.isEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.payrollNoEmployeeData,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, List<Employee> availableEmployees) {
    final l10n = AppLocalizations.of(context)!;
    if (availableEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.payrollNoAvailableEmployeeToAdd),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AddPayrollDialog(
        availableEmployees: availableEmployees,
        onAdd:
            (
              employeeId,
              firstName,
              lastName,
              payrollType,
              salary,
              socialSecurity,
            ) async {
              context.read<PayrollBloc>().add(
                AddPayrollEmployee(
                  employeeId: employeeId,
                  firstName: firstName,
                  lastName: lastName,
                  payrollType: payrollType,
                  salary: salary,
                  socialSecurity: socialSecurity,
                ),
              );
            },
      ),
    );
  }

  void _showEditDialog(BuildContext context, PayrollEmployee employee) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditPayrollDialog(
        employee: employee,
        onUpdate: (updatedEmployee) async {
          context.read<PayrollBloc>().add(
            UpdatePayrollEmployee(updatedEmployee),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, PayrollEmployee employee) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.payrollDeleteConfirm),
          ],
        ),
        content: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(l10n.payrollDeleteConfirmMsg(employee.fullName)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel, // ใช้ key มาตรฐาน cancel
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<PayrollBloc>().add(
                DeletePayrollEmployee(employee.id),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.payrollDelete),
          ),
        ],
      ),
    );
  }

  void _showExportConfirmation(BuildContext context, List<String> employeeIds) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SunTheme.sunOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: SunTheme.sunOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('ส่งออกสลิปเงินเดือน'),
          ],
        ),
        content: Container(
          decoration: BoxDecoration(
            color: SunTheme.sunLight,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(l10n.payrollExportConfirm(employeeIds.length)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel, // ใช้ key มาตรฐาน cancel
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<PayrollBloc>().add(ExportPayslips(employeeIds));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SunTheme.sunOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.payrollExported,
            ), // เปลี่ยนเป็นข้อความยืนยันการส่งออก (หรือใช้ l10n.payrollExport ถ้าต้องการปุ่ม)
          ),
        ],
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, PayrollEmployee employee) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: SunTheme.sunOrange.withValues(alpha: 0.1),
              child: Text(
                employee.fullName.isNotEmpty
                    ? employee.fullName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: SunTheme.sunOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                employee.fullName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SunTheme.sunLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(l10n.employeeIdLabel, employee.employeeId),
                    const Divider(height: 20),
                    _buildDetailRow(
                      l10n.payrollTypeLabel,
                      _getPayrollTypeLabel(l10n, employee.payrollType),
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      l10n.payrollSalary,
                      'THB ${employee.salary.toStringAsFixed(0)}',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      l10n.payrollSocialSecurity,
                      'THB ${employee.socialSecurity.toStringAsFixed(0)}',
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      l10n.payrollCreatedAt,
                      _formatDate(employee.createdAt),
                    ),
                    const Divider(height: 20),
                    _buildDetailRow(
                      l10n.payrollLastUpdatedLabel,
                      _formatDate(employee.updatedAt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.payrollClose,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _showEditDialog(context, employee);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SunTheme.sunOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.edit, size: 18),
            label: Text(l10n.payrollEdit),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: SunTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: SunTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // เพิ่มฟังก์ชัน helper สำหรับแปลประเภทเงินเดือน
  String _getPayrollTypeLabel(AppLocalizations l10n, PayrollType type) {
    switch (type) {
      case PayrollType.monthly:
        return l10n.payrollTypeMonthly;
      case PayrollType.daily:
        return l10n.payrollTypeDaily;
    }
  }

  Widget _buildNoSearchResults() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.payrollNoSearchResultTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: SunTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.payrollNoSearchResultDescription(_searchQuery),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: SunTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.clear),
            label: Text(l10n.payrollClearSearch),
            style: TextButton.styleFrom(
              foregroundColor: SunTheme.sunOrange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
