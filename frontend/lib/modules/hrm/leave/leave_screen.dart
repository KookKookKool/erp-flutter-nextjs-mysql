import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaveTitle ?? 'Leave Management')),
      body: Center(
        child: Text(l10n.leaveContent ?? 'Leave management content here'),
      ),
    );
  }
}
