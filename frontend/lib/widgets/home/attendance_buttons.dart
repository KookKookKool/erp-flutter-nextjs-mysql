import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class AttendanceButtons extends StatelessWidget {
  const AttendanceButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.sunOrange,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.login, color: Colors.white),
          label: Text(
            AppLocalizations.of(context)!.checkIn,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.sunDeepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Colors.white),
          label: Text(
            AppLocalizations.of(context)!.checkOut,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
