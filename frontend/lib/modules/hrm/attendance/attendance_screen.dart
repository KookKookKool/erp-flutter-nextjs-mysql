import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.attendanceTitle ?? 'Time Attendance')),
      body: Center(
        child: Text(l10n.attendanceContent ?? 'Attendance content here'),
      ),
    );
  }
}
