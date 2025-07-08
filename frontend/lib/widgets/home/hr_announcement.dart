import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/modules/hrm/announcement/bloc/announcement_cubit.dart';
import 'home_announcement_card.dart';
import 'announcement_summary.dart';
import 'announcement_view_dialog.dart';

class HrAnnouncement extends StatelessWidget {
  const HrAnnouncement({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.localeName == 'th' ? 'ประกาศล่าสุด' : 'Recent Announcements',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const AnnouncementSummary(),
        BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (state.error != null) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.error_outline, color: Colors.red),
                  title: Text(
                    l10n.localeName == 'th' ? 'เกิดข้อผิดพลาด' : 'Error',
                  ),
                  subtitle: Text(state.error!),
                ),
              );
            }

            final recentAnnouncements = state.announcements
                .where((announcement) => announcement.isActive)
                .take(3)
                .toList();

            if (recentAnnouncements.isEmpty) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.announcement_outlined,
                    color: Colors.grey,
                  ),
                  title: Text(
                    l10n.localeName == 'th'
                        ? 'ไม่มีประกาศ'
                        : 'No Announcements',
                  ),
                  subtitle: Text(
                    l10n.localeName == 'th'
                        ? 'ยังไม่มีประกาศในขณะนี้'
                        : 'No announcements available at the moment',
                  ),
                ),
              );
            }

            return Column(
              children: recentAnnouncements.map((announcement) {
                return HomeAnnouncementCard(
                  announcement: announcement,
                  onTap: () {
                    // Show view-only announcement dialog (ไม่สามารถแก้ไขหรือลบได้)
                    showDialog(
                      context: context,
                      builder: (ctx) =>
                          AnnouncementViewDialog(announcement: announcement),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
