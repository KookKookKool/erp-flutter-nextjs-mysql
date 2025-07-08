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
        label = l10n.leaveStatusApproved;
        break;
      case 'rejected':
        color = Colors.red;
        label = l10n.leaveStatusRejected;
        break;
      default:
        color = Colors.orange;
        label = l10n.leaveStatusPending;
    }
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color),
    );
  }
}
