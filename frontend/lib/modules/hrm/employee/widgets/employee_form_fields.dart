import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '/theme/sun_theme.dart';

class EmployeeFormFields extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController employeeId;
  final String level;
  final ValueChanged<String?> onLevelChanged;
  final List<String> levels;
  final TextEditingController position;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController startDate;
  final VoidCallback onPickDate;
  final TextEditingController password;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final AppLocalizations l10n;

  const EmployeeFormFields({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.level,
    required this.onLevelChanged,
    required this.levels,
    required this.position,
    required this.email,
    required this.phone,
    required this.startDate,
    required this.onPickDate,
    required this.password,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: firstName,
          decoration: InputDecoration(
            labelText: l10n.name,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? l10n.name + ' ' + l10n.error : null,
        ),
        TextFormField(
          controller: lastName,
          decoration: InputDecoration(
            labelText: l10n.surname,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? l10n.surname + ' ' + l10n.error : null,
        ),
        TextFormField(
          controller: employeeId,
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
        ),
        DropdownButtonFormField<String>(
          value: level,
          items: levels
              .map((lv) => DropdownMenuItem(value: lv, child: Text(lv)))
              .toList(),
          onChanged: onLevelChanged,
          decoration: InputDecoration(
            labelText: l10n.level,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
        ),
        TextFormField(
          controller: position,
          decoration: InputDecoration(
            labelText: l10n.position,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
        ),
        TextFormField(
          controller: email,
          decoration: InputDecoration(
            labelText: l10n.email,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
        ),
        TextFormField(
          controller: phone,
          decoration: InputDecoration(
            labelText: l10n.phone,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
        ),
        TextFormField(
          controller: startDate,
          readOnly: true,
          decoration: InputDecoration(
            labelText: l10n.startDate,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
          ),
          onTap: onPickDate,
        ),
        TextFormField(
          controller: password,
          decoration: InputDecoration(
            labelText: l10n.password,
            labelStyle: TextStyle(color: SunTheme.textPrimary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.primary),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: SunTheme.cardColor),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: SunTheme.textSecondary,
              ),
              onPressed: onTogglePassword,
              tooltip: obscurePassword ? l10n.showPassword : l10n.hidePassword,
            ),
          ),
          obscureText: obscurePassword,
        ),
      ],
    );
  }
}
