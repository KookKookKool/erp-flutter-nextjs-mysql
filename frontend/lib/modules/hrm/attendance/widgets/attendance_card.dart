import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import '../attendance_screen.dart';

class AttendanceCard extends StatelessWidget {
  final EmployeeAttendance emp;
  final DateTime todayKey;
  final void Function() onEdit;
  const AttendanceCard({
    super.key,
    required this.emp,
    required this.todayKey,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rec = emp.records[todayKey] ?? {'in': null, 'out': null};
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: SunTheme.cardColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: SunTheme.primaryLight,
          child: Text(
            emp.name.characters.first,
            style: TextStyle(color: SunTheme.onPrimary),
          ),
        ),
        title: Text(
          '${emp.id} - ${emp.name}',
          style: TextStyle(color: SunTheme.textPrimary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.checkIn +
                  ': ' +
                  (rec['in'] != null ? _formatTime(rec['in']) : '-'),
              style: TextStyle(color: SunTheme.textSecondary),
            ),
            Text(
              l10n.checkOut +
                  ': ' +
                  (rec['out'] != null ? _formatTime(rec['out']) : '-'),
              style: TextStyle(color: SunTheme.textSecondary),
            ),
          ],
        ),
        trailing: Icon(Icons.edit, color: SunTheme.primary),
        onTap: onEdit,
      ),
    );
  }

  String _formatTime(DateTime? dt) => dt == null
      ? '-'
      : '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
