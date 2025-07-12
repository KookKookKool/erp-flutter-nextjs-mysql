import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/modules/hrm/leave/leave_repository.dart';

class AddLeaveDialog extends StatefulWidget {
  final Future<void> Function(Leave leave) onSave;
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
  String? _employeeId;
  String? _employeeName;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _leaveType;
  String? _note;

  // สมมติ employees เป็น List<String> เช่น ['EMP001:สมชาย ใจดี', ...]
  late final Map<String, String> _employeeMap; // id -> name
  late final Map<String, String> _nameToIdMap; // name -> id

  @override
  void initState() {
    super.initState();
    _employeeMap = {};
    _nameToIdMap = {};
    for (var e in widget.employees) {
      if (e.contains(':')) {
        final parts = e.split(':');
        final id = parts[0].trim();
        final name = parts[1].trim();
        _employeeMap[id] = name;
        _nameToIdMap[name] = id;
      }
    }
    if (widget.initial != null) {
      _employeeId = widget.initial!.employeeId;
      _employeeName = widget.initial!.employeeName;
      _startDate = widget.initial!.startDate;
      _endDate = widget.initial!.endDate;
      _leaveType = widget.initial!.type;
      _note = widget.initial!.note;
    } else {
      // สำหรับการขอลาใหม่
      _employeeId = '';
      _employeeName = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: SunTheme.cardColor,
      title: Text(
        l10n.addLeaveTitle,
        style: TextStyle(color: SunTheme.textPrimary),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Autocomplete รหัสพนักงาน (id)
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _employeeId ?? ''),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return _employeeMap.keys;
                  }
                  return _employeeMap.keys.where((String option) {
                    return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                },
                onSelected: (String selection) {
                  setState(() {
                    _employeeId = selection;
                    _employeeName = _employeeMap[selection] ?? '';
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      // ไม่ต้องเขียนทับ controller.text ให้ผู้ใช้พิมพ์ได้
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: l10n.employeeIdLabel,
                          labelStyle: TextStyle(color: SunTheme.textPrimary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: SunTheme.primary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: SunTheme.cardColor),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? l10n.employeeIdLabel
                            : null,
                        onChanged: (v) {
                          setState(() {
                            _employeeId = v;
                            if (_employeeMap.containsKey(v)) {
                              _employeeName = _employeeMap[v]!;
                            } else {
                              _employeeName = '';
                            }
                          });
                        },
                      );
                    },
              ),
              const SizedBox(height: 12),
              // Autocomplete ชื่อพนักงาน (name)
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _employeeName ?? ''),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return _nameToIdMap.keys;
                  }
                  return _nameToIdMap.keys.where((String option) {
                    return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                },
                onSelected: (String selection) {
                  setState(() {
                    _employeeName = selection;
                    _employeeId = _nameToIdMap[selection] ?? '';
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      // ไม่ต้องเขียนทับ controller.text ให้ผู้ใช้พิมพ์ได้
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: l10n.employeeName,
                          labelStyle: TextStyle(color: SunTheme.textPrimary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: SunTheme.primary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: SunTheme.cardColor),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? l10n.employeeName : null,
                        onChanged: (v) {
                          setState(() {
                            _employeeName = v;
                            if (_nameToIdMap.containsKey(v)) {
                              _employeeId = _nameToIdMap[v]!;
                            } else {
                              _employeeId = '';
                            }
                          });
                        },
                      );
                    },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: InputDecoration(
                  labelText: l10n.leaveTypeLabel,
                  labelStyle: TextStyle(color: SunTheme.textPrimary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.cardColor),
                  ),
                ),
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
                        labelText: '${l10n.leaveDate} (Start)',
                        labelStyle: TextStyle(color: SunTheme.textPrimary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: SunTheme.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: SunTheme.cardColor),
                        ),
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
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                elevatedButtonTheme: ElevatedButtonThemeData(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SunTheme.primary,
                                    foregroundColor: SunTheme.onPrimary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _startDate = picked);
                        }
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
                        labelText: '${l10n.leaveDate} (End)',
                        labelStyle: TextStyle(color: SunTheme.textPrimary),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: SunTheme.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: SunTheme.cardColor),
                        ),
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
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                elevatedButtonTheme: ElevatedButtonThemeData(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SunTheme.primary,
                                    foregroundColor: SunTheme.onPrimary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
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
                decoration: InputDecoration(
                  labelText: l10n.leaveReason,
                  labelStyle: TextStyle(color: SunTheme.textPrimary),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: SunTheme.cardColor),
                  ),
                ),
                onChanged: (v) => _note = v,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.initial != null && widget.onDelete != null)
          TextButton(
            onPressed: () async {
              final l10n = AppLocalizations.of(context)!;
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: SunTheme.cardColor,
                  title: Text(
                    l10n.localeName == 'th' ? 'ยืนยันการลบ' : 'Confirm Delete',
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                  content: Text(
                    l10n.localeName == 'th'
                        ? 'คุณต้องการลบรายการนี้หรือไม่?'
                        : 'Do you want to delete this item?',
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(color: SunTheme.primary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SunTheme.error,
                        foregroundColor: SunTheme.onPrimary,
                      ),
                      child: Text(
                        l10n.delete,
                        style: TextStyle(color: SunTheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true && mounted) {
                widget.onDelete!();
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(foregroundColor: SunTheme.error),
            child: Text(l10n.delete, style: TextStyle(color: SunTheme.error)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: TextStyle(color: SunTheme.primary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.primary,
            foregroundColor: SunTheme.onPrimary,
          ),
          onPressed: () async {
            if (_formKey.currentState?.validate() != true) return;

            // ตรวจสอบข้อมูลที่จำเป็น
            if (_employeeId == null || _employeeId!.isEmpty) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณาเลือกรหัสพนักงาน')),
                );
              }
              return;
            }
            if (_employeeName == null || _employeeName!.isEmpty) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณาเลือกชื่อพนักงาน')),
                );
              }
              return;
            }
            if (_startDate == null || _endDate == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณาเลือกวันที่ลา')),
                );
              }
              return;
            }
            if (_leaveType == null || _leaveType!.isEmpty) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กรุณาเลือกประเภทการลา')),
                );
              }
              return;
            }

            final leave = Leave(
              id:
                  widget.initial?.id ??
                  'TEMP_ID', // ปล่อยให้ repository สร้าง unique ID
              employeeId: _employeeId!,
              employeeName: _employeeName!,
              startDate: _startDate!,
              endDate: _endDate!,
              type: _leaveType!,
              note: _note ?? '',
              status: widget.initial?.status ?? 'pending',
            );

            try {
              await widget.onSave(leave);
            } catch (e, stack) {
              debugPrint('AddLeaveDialog save error: $e\n$stack');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
                );
              }
            }
            // ไม่ต้อง pop dialog ที่นี่ ให้ leave_screen.dart เป็นคน pop
          },
          child: Text(l10n.save, style: TextStyle(color: SunTheme.onPrimary)),
        ),
      ],
    );
  }
}
