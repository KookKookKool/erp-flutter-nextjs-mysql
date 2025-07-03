import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.projectNotificationModule)),
      body: Center(child: Text(l10n.projectNotificationContent)),
    );
  }
}
