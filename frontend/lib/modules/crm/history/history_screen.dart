import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.crmHistoryModule)),
      body: Center(child: Text(l10n.crmHistoryContent)),
    );
  }
}
