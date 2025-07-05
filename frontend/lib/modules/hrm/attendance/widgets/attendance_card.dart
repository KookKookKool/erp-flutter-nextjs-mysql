import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/theme/widget_styles.dart';
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
    return SizedBox(
      height: WidgetStyles.cardHeightSmall,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: SunTheme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // กึ่งกลางแนวนอน
            crossAxisAlignment: CrossAxisAlignment.center, // กึ่งกลางแนวตั้ง
            children: [
              CircleAvatar(
                backgroundColor: SunTheme.primaryLight,
                child: Text(
                  emp.name.characters.first,
                  style: TextStyle(color: SunTheme.onPrimary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // กึ่งกลางแนวตั้ง
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${emp.id} - ${emp.name}',
                      style: TextStyle(color: SunTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
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
              ),
              IconButton(
                icon: Icon(Icons.edit, color: SunTheme.primary),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) => dt == null
      ? '-'
      : '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
