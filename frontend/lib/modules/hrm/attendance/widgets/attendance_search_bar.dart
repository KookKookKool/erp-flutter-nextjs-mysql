import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import '/theme/sun_theme.dart';

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
      decoration: BoxDecoration(
        color: SunTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SunTheme.primary, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 1), // เงาแนบกับ input
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: SunTheme.primary),
          hintText: l10n.searchHint,
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
