import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SunTheme.sunSearchBoxDecoration,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: SunTheme.textSecondary),
          hintText: l10n?.searchHint ?? hintText,
          hintStyle: TextStyle(color: SunTheme.textSecondary, fontSize: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: onChanged,
      ),
    );
  }
}
