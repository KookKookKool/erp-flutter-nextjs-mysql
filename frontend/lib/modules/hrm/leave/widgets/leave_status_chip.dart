import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class LeaveStatusChip extends StatelessWidget {
  final String status;
  const LeaveStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color;
    String label;
    switch (status) {
      case 'approved':
        color = Colors.green;
        label =
            l10n.leaveStatusApproved ??
            (l10n.localeName == 'th' ? 'อนุมัติ' : 'Approved');
        break;
      case 'rejected':
        color = Colors.red;
        label =
            l10n.leaveStatusRejected ??
            (l10n.localeName == 'th' ? 'ไม่อนุมัติ' : 'Rejected');
        break;
      default:
        color = Colors.orange;
        label =
            l10n.leaveStatusPending ??
            (l10n.localeName == 'th' ? 'รออนุมัติ' : 'Pending');
    }
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }
}
