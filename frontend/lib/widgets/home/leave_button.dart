import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: SunTheme.sunGold,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.beach_access, color: SunTheme.sunDeepOrange),
      label: Text(
        AppLocalizations.of(context)!.leave,
        style: textTheme.labelLarge?.copyWith(color: SunTheme.sunDeepOrange),
      ),
    );
  }
}
