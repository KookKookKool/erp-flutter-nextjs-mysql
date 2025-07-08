import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/payroll_employee.dart';
import '../../../../core/theme/sun_theme.dart';

class EditPayrollDialog extends StatefulWidget {
  final PayrollEmployee employee;
  final Function(PayrollEmployee) onUpdate;

  const EditPayrollDialog({
    super.key,
    required this.employee,
    required this.onUpdate,
  });

  @override
  State<EditPayrollDialog> createState() => _EditPayrollDialogState();
}

class _EditPayrollDialogState extends State<EditPayrollDialog> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();

  late PayrollType _selectedPayrollType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPayrollType = widget.employee.payrollType;
    _salaryController.text = widget.employee.salary.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final salary = double.parse(_salaryController.text.replaceAll(',', ''));
      final updatedEmployee = widget.employee.copyWith(
        payrollType: _selectedPayrollType,
        salary: salary,
      );

      await widget.onUpdate(updatedEmployee);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
      );
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
                  Icon(Icons.edit, color: SunTheme.sunOrange, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'แก้ไขข้อมูลเงินเดือน',
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

              // Employee info (read-only)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ข้อมูลพนักงาน',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.employee.fullName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'รหัส: ${widget.employee.employeeId}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
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
                'เงินเดือน (บาท)',
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
                      ? 'เช่น 25000'
                      : 'เช่น 500',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: 'บาท',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกจำนวนเงิน';
                  }
                  final amount = double.tryParse(value.replaceAll(',', ''));
                  if (amount == null || amount <= 0) {
                    return 'กรุณากรอกจำนวนเงินที่ถูกต้อง';
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
                          : const Text('บันทึก'),
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
