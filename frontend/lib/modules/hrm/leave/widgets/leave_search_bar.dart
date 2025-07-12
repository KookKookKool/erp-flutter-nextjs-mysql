import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class LeaveSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const LeaveSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SunTheme.sunSearchBoxDecoration,
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          prefixIcon: Icon(Icons.search, color: SunTheme.textSecondary),
          hintText: l10n.searchHint,
          hintStyle: TextStyle(color: SunTheme.textSecondary, fontSize: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: onChanged,
      ),
    );
  }
}
