import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/modules/hrm/leave/leave_repository.dart';
import 'package:frontend/modules/hrm/leave/widgets/leave_status_chip.dart';

class LeaveApprovalCard extends StatelessWidget {
  final Leave leave;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const LeaveApprovalCard({
    super.key,
    required this.leave,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onToggleSelection,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: isMultiSelectMode && leave.status == 'pending'
          ? onToggleSelection
          : null,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
        ),
        color: isSelected
            ? Colors.blue.withValues(alpha: 0.1)
            : SunTheme.cardColor,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: SunTheme.primaryLight,
                        child: Text(
                          _getEmployeeInitial(leave.employeeName),
                          style: TextStyle(color: SunTheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${leave.employeeId} - ${leave.employeeName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SunTheme.textPrimary,
                              ),
                            ),
                            Text(
                              leave.type,
                              style: TextStyle(color: SunTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (!isMultiSelectMode)
                        LeaveStatusChip(status: leave.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: SunTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)}',
                        style: TextStyle(color: SunTheme.textSecondary),
                      ),
                    ],
                  ),
                  if (leave.note.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'หมายเหตุ: ${leave.note}',
                      style: TextStyle(color: SunTheme.textSecondary),
                    ),
                  ],
                  if (!isMultiSelectMode && leave.status == 'pending') ...[
                    const SizedBox(height: 12),
                    _buildApprovalButtons(context, l10n),
                  ],
                ],
              ),
            ),
            // Selection checkbox for multi-select mode
            if (isMultiSelectMode && leave.status == 'pending')
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalButtons(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: onApprove,
            icon: const Icon(Icons.check, size: 16),
            label: Text(l10n.leaveStatusApproved),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: onReject,
            icon: const Icon(Icons.close, size: 16),
            label: Text(l10n.leaveStatusRejected),
          ),
        ),
      ],
    );
  }

  String _getEmployeeInitial(String employeeName) {
    if (employeeName.isEmpty) return 'U';
    return employeeName.characters.first.toUpperCase();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
