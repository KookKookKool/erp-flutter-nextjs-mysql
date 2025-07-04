import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

class EmployeeSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String? hintText;
  const EmployeeSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText ?? l10n?.searchHint ?? 'ค้นหาชื่อหรือรหัสพนักงาน',
        ),
        onChanged: (v) => onChanged(v.trim()),
      ),
    );
  }
}
