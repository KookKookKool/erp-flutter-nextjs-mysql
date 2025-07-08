import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class AttendanceSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const AttendanceSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: SunTheme.sunSearchBoxDecoration,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: SunTheme.primary),
          hintText: l10n.searchHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(color: SunTheme.textPrimary),
        onChanged: onChanged,
      ),
    );
  }
}
