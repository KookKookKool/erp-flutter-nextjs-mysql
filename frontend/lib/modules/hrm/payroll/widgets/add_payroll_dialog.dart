import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/modules/hrm/payroll/models/payroll_employee.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class AddPayrollDialog extends StatefulWidget {
  final List<Employee> availableEmployees;
  final Function(
    String employeeId,
    String firstName,
    String lastName,
    PayrollType payrollType,
    double salary,
    double socialSecurity,
  )
  onAdd;

  const AddPayrollDialog({
    super.key,
    required this.availableEmployees,
    required this.onAdd,
  });

  @override
  State<AddPayrollDialog> createState() => _AddPayrollDialogState();
}

class _AddPayrollDialogState extends State<AddPayrollDialog> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  final _socialSecurityController = TextEditingController();

  Employee? _selectedEmployee;
  PayrollType _selectedPayrollType = PayrollType.monthly;
  bool _isLoading = false;

  @override
  void dispose() {
    _salaryController.dispose();
    _socialSecurityController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedEmployee == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final salary = double.parse(_salaryController.text.replaceAll(',', ''));
      final socialSecurity =
          double.tryParse(_socialSecurityController.text.replaceAll(',', '')) ??
          0.0;
      await widget.onAdd(
        _selectedEmployee!.employeeId,
        _selectedEmployee!.firstName,
        _selectedEmployee!.lastName,
        _selectedPayrollType,
        salary,
        socialSecurity,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.person_add, color: SunTheme.sunOrange, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'เพิ่มข้อมูลเงินเดือน',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SunTheme.sunOrange,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Employee selection
              Text(
                'เลือกพนักงาน',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Employee>(
                value: _selectedEmployee,
                decoration: InputDecoration(
                  hintText: 'เลือกพนักงาน',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                items: widget.availableEmployees.map((employee) {
                  return DropdownMenuItem(
                    value: employee,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          employee.fullName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'รหัส: ${employee.employeeId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (employee) {
                  setState(() {
                    _selectedEmployee = employee;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'กรุณาเลือกพนักงาน';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Payroll type selection
              Text(
                'ประเภทเงินเดือน',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: PayrollType.values.map((type) {
                  return Expanded(
                    child: RadioListTile<PayrollType>(
                      title: Text(type.displayName),
                      value: type,
                      groupValue: _selectedPayrollType,
                      onChanged: (PayrollType? value) {
                        if (value != null) {
                          setState(() {
                            _selectedPayrollType = value;
                          });
                        }
                      },
                      activeColor: SunTheme.sunOrange,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Salary input
              Text(
                AppLocalizations.of(context)!.payrollSalaryLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: _selectedPayrollType == PayrollType.monthly
                      ? AppLocalizations.of(context)!.payrollSalaryHintMonthly
                      : AppLocalizations.of(context)!.payrollSalaryHintDaily,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: AppLocalizations.of(context)!.payrollBaht,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.payrollSalaryRequired;
                  }
                  final amount = double.tryParse(value.replaceAll(',', ''));
                  if (amount == null || amount <= 0) {
                    return AppLocalizations.of(context)!.payrollSalaryInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Social Security input
              Text(
                AppLocalizations.of(context)!.payrollSocialSecurityLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _socialSecurityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(
                    context,
                  )!.payrollSocialSecurityHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.security),
                  suffixText: AppLocalizations.of(context)!.payrollBaht,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final amount = double.tryParse(value.replaceAll(',', ''));
                    if (amount == null || amount < 0) {
                      return AppLocalizations.of(
                        context,
                      )!.payrollSocialSecurityInvalid;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('ยกเลิก'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SunTheme.sunOrange,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('เพิ่ม'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
