import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class HrAnnouncement extends StatelessWidget {
  const HrAnnouncement({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.hrAnnouncement,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.announcement,
              color: SunTheme.sunDeepOrange,
            ),
            title: Text(AppLocalizations.of(context)!.hrAnnouncementTitle),
            subtitle: Text(
              AppLocalizations.of(context)!.hrAnnouncementSubtitle,
            ),
          ),
        ),
      ],
    );
  }
}
