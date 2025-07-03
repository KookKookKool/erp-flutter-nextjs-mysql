import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class LeaveApprovalScreen extends StatelessWidget {
  const LeaveApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaveApprovalTitle ?? 'Leave Approval')),
      body: Center(
        child: Text(l10n.leaveApprovalContent ?? 'Leave approval content here'),
      ),
    );
  }
}
