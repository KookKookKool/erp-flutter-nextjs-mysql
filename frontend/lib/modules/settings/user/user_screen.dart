import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsUserModule)),
      body: Center(child: Text(l10n.settingsUserContent)),
    );
  }
}
