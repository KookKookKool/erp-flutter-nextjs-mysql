import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import '../leave_repository.dart';

class AddLeaveDialog extends StatefulWidget {
  final void Function(Leave leave) onSave;
  final void Function()? onDelete;
  final List<String> employees;
  final Leave? initial;
  const AddLeaveDialog({
    super.key,
    required this.onSave,
    required this.employees,
    this.initial,
    this.onDelete,
  });

  @override
  State<AddLeaveDialog> createState() => _AddLeaveDialogState();
}

class _AddLeaveDialogState extends State<AddLeaveDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _id;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _employee;
  String? _leaveType;
  String? _note;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _id = widget.initial!.id;
      _startDate = widget.initial!.startDate;
      _endDate = widget.initial!.endDate;
      _employee = widget.initial!.employee;
      _leaveType = widget.initial!.type;
      _note = widget.initial!.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.dialogBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.addLeaveTitle, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _id,
                  decoration: InputDecoration(labelText: l10n.employeeIdLabel),
                  onChanged: (v) => _id = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.employeeIdLabel : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _employee,
                  decoration: InputDecoration(labelText: l10n.employeeName),
                  items: widget.employees
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _employee = v),
                  validator: (v) => v == null ? l10n.employeeName : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _leaveType,
                  decoration: InputDecoration(labelText: l10n.leaveTypeLabel),
                  items: [
                    DropdownMenuItem(
                      value: 'sick',
                      child: Text(l10n.leaveTypeSick),
                    ),
                    DropdownMenuItem(
                      value: 'personal',
                      child: Text(l10n.leaveTypePersonal),
                    ),
                    DropdownMenuItem(
                      value: 'vacation',
                      child: Text(l10n.leaveTypeVacation),
                    ),
                  ],
                  onChanged: (v) => setState(() => _leaveType = v),
                  validator: (v) => v == null ? l10n.leaveTypeLabel : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: l10n.leaveDate + ' (Start)',
                        ),
                        controller: TextEditingController(
                          text: _startDate == null
                              ? ''
                              : '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}',
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            locale: Locale(l10n.localeName),
                          );
                          if (picked != null)
                            setState(() => _startDate = picked);
                        },
                        validator: (v) =>
                            _startDate == null ? l10n.leaveDate : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: l10n.leaveDate + ' (End)',
                        ),
                        controller: TextEditingController(
                          text: _endDate == null
                              ? ''
                              : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                _endDate ?? (_startDate ?? DateTime.now()),
                            firstDate: _startDate ?? DateTime(2000),
                            lastDate: DateTime(2100),
                            locale: Locale(l10n.localeName),
                          );
                          if (picked != null) setState(() => _endDate = picked);
                        },
                        validator: (v) =>
                            _endDate == null ? l10n.leaveDate : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: _note,
                  decoration: InputDecoration(labelText: l10n.leaveReason),
                  onChanged: (v) => _note = v,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.initial != null && widget.onDelete != null) ...[
                      TextButton(
                        onPressed: () async {
                          final l10n = AppLocalizations.of(context)!;
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                l10n.localeName == 'th'
                                    ? 'ยืนยันการลบ'
                                    : 'Confirm Delete',
                              ),
                              content: Text(
                                l10n.localeName == 'th'
                                    ? 'คุณต้องการลบรายการนี้หรือไม่?'
                                    : 'Do you want to delete this item?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(l10n.delete),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            widget.onDelete!();
                            Navigator.of(context).pop();
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l10n.delete),
                      ),
                      const SizedBox(width: 8),
                    ],
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave(
                            Leave(
                              id: _id!,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              employee: _employee!,
                              type: _leaveType!,
                              note: _note ?? '',
                              status: 'approved', // HR เพิ่ม = อนุมัติทันที
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(l10n.save),
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
