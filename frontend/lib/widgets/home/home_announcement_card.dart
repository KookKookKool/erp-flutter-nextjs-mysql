import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/modules/hrm/announcement/models/announcement.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class HomeAnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback? onTap;

  const HomeAnnouncementCard({
    super.key,
    required this.announcement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                _getPriorityColor(
                  announcement.priority,
                ).withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: SunTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.content,
                  style: TextStyle(
                    color: SunTheme.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          announcement.author,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(announcement.createdDate),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
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
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
