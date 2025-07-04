import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'employee_image_picker.dart';
import 'employee_form_fields.dart';
import '../employee_list_screen.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class EmployeeDialog extends StatefulWidget {
  final Employee? employee;
  final VoidCallback? onDelete;
  const EmployeeDialog({this.employee, this.onDelete, super.key});
  @override
  State<EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<EmployeeDialog> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _employeeId;
  String _level = 'Junior';
  late TextEditingController _position;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _startDate;
  late TextEditingController _password;
  bool _obscurePassword = true;

  final List<String> _levels = ['Junior', 'Senior', 'Manager', 'Director'];

  @override
  void initState() {
    final emp = widget.employee;
    _image = emp?.image;
    _firstName = TextEditingController(text: emp?.firstName ?? '');
    _lastName = TextEditingController(text: emp?.lastName ?? '');
    _employeeId = TextEditingController(text: emp?.employeeId ?? '');
    _level = emp?.level ?? 'Junior';
    _position = TextEditingController(text: emp?.position ?? '');
    _email = TextEditingController(text: emp?.email ?? '');
    _phone = TextEditingController(text: emp?.phone ?? '');
    _startDate = TextEditingController(text: emp?.startDate ?? '');
    _password = TextEditingController(text: emp?.password ?? '');
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: SunTheme.cardColor,
      title: Text(
        widget.employee == null ? l10n.addEmployee : l10n.editEmployee,
        style: TextStyle(color: SunTheme.textPrimary),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmployeeImagePicker(
                image: _image,
                onPick: _pickImage,
                tooltip: l10n.changeImage,
              ),
              const SizedBox(height: 16),
              EmployeeFormFields(
                firstName: _firstName,
                lastName: _lastName,
                employeeId: _employeeId,
                level: _level,
                onLevelChanged: (val) {
                  if (val != null) setState(() => _level = val);
                },
                levels: _levels,
                position: _position,
                email: _email,
                phone: _phone,
                startDate: _startDate,
                onPickDate: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate.text.isNotEmpty
                        ? DateTime.tryParse(_startDate.text) ?? DateTime.now()
                        : DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: l10n.pickStartDate,
                  );
                  if (picked != null) {
                    _startDate.text = picked.toIso8601String().split('T').first;
                  }
                },
                password: _password,
                obscurePassword: _obscurePassword,
                onTogglePassword: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                l10n: l10n,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.employee != null && widget.onDelete != null)
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: SunTheme.cardColor,
                  title: Text(
                    l10n.confirmDelete,
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                  content: Text(
                    l10n.confirmDeleteMessage,
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(color: SunTheme.primary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
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
              if (confirm == true) {
                Navigator.pop(context, 'delete');
                widget.onDelete?.call();
              }
            },
            style: TextButton.styleFrom(foregroundColor: SunTheme.error),
            child: Text(l10n.delete, style: TextStyle(color: SunTheme.error)),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: TextStyle(color: SunTheme.primary)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                Employee(
                  image: _image,
                  firstName: _firstName.text,
                  lastName: _lastName.text,
                  employeeId: _employeeId.text,
                  level: _level,
                  position: _position.text,
                  email: _email.text,
                  phone: _phone.text,
                  startDate: _startDate.text,
                  password: _password.text,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.primary,
            foregroundColor: SunTheme.onPrimary,
          ),
          child: Text(l10n.save, style: TextStyle(color: SunTheme.onPrimary)),
        ),
      ],
    );
  }
}
