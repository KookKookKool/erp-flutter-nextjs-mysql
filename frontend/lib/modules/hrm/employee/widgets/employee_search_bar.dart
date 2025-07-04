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
      decoration: BoxDecoration(
        color: SunTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SunTheme.primary, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: SunTheme.primary),
          hintText: l10n?.searchHint ?? hintText,
          filled: true,
          fillColor: SunTheme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
        ),
        style: TextStyle(color: SunTheme.textPrimary),
        onChanged: onChanged,
      ),
    );
  }
}
