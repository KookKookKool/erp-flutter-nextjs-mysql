import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/modules/hrm/announcement/models/announcement.dart';

class AnnouncementViewDialog extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementViewDialog({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.dialogTheme.backgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with priority indicator only (no action menu)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(
                        announcement.priority,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getPriorityIcon(announcement.priority),
                      color: _getPriorityColor(announcement.priority),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(announcement.priority),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getPriorityText(announcement.priority, l10n),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                announcement.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SunTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  announcement.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: SunTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Meta information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SunTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${l10n.localeName == 'th' ? 'ผู้เขียน' : 'Author'}: ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            announcement.author,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${l10n.localeName == 'th' ? 'วันที่สร้าง' : 'Created'}: ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatDateTime(announcement.createdDate),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Close button only
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SunTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(l10n.localeName == 'th' ? 'ปิด' : 'Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPriorityIcon(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.high:
        return Icons.warning;
      case AnnouncementPriority.medium:
        return Icons.info;
      case AnnouncementPriority.low:
        return Icons.info_outline;
    }
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.high:
        return Colors.red;
      case AnnouncementPriority.medium:
        return Colors.orange;
      case AnnouncementPriority.low:
        return Colors.blue;
    }
  }

  String _getPriorityText(
    AnnouncementPriority priority,
    AppLocalizations l10n,
  ) {
    switch (priority) {
      case AnnouncementPriority.high:
        return l10n.localeName == 'th' ? 'สำคัญมาก' : 'High';
      case AnnouncementPriority.medium:
        return l10n.localeName == 'th' ? 'ปานกลาง' : 'Medium';
      case AnnouncementPriority.low:
        return l10n.localeName == 'th' ? 'ทั่วไป' : 'Low';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
