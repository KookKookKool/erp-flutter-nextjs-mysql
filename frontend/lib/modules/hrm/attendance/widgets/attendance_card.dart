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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
        ),
        color: SunTheme.cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(WidgetStyles.cardBorderRadius),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // กึ่งกลางแนวนอน
              crossAxisAlignment: CrossAxisAlignment.center, // กึ่งกลางแนวตั้ง
              children: [
                CircleAvatar(
                  backgroundColor: SunTheme.sunOrange.withOpacity(0.1),
                  child: Text(
                    emp.name.characters.first.toUpperCase(),
                    style: TextStyle(
                      color: SunTheme.sunOrange,
                      fontWeight: FontWeight.bold,
                    ),
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
                        style: TextStyle(
                          color: SunTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${l10n.checkIn}: ${rec['in'] != null ? _formatTime(rec['in']) : '-'}',
                              style: TextStyle(
                                color: SunTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${l10n.checkOut}: ${rec['out'] != null ? _formatTime(rec['out']) : '-'}',
                              style: TextStyle(
                                color: SunTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: SunTheme.textSecondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: SunTheme.sunOrange, size: 20),
                          const SizedBox(width: 12),
                          const Text('แก้ไข'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) => dt == null
      ? '-'
      : '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
