import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'leave_status_chip.dart';

class LeaveCard extends StatelessWidget {
  final dynamic leave;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showEdit;
  final bool showStatusChip;
  final Widget? trailing;
  const LeaveCard({
    super.key,
    required this.leave,
    this.onEdit,
    this.onDelete,
    this.showEdit = false,
    this.showStatusChip = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: SunTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(child: Text(_getEmployeeInitial(leave.employeeName))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${leave.employeeId} - ${_getEmployeeName(leave.employeeName)}',
                    style: TextStyle(
                      color: SunTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    leave.type,
                    style: TextStyle(color: SunTheme.textSecondary),
                  ),
                  Text(
                    _formatDate(leave.startDate),
                    style: TextStyle(
                      color: SunTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  if (leave.note != null && leave.note.isNotEmpty)
                    Text(
                      leave.note,
                      style: TextStyle(
                        color: SunTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (showStatusChip) LeaveStatusChip(status: leave.status),
            if ((showEdit && onEdit != null) || onDelete != null) ...[
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    final l10n = AppLocalizations.of(context)!;
                    final confirmed = await _showDeleteConfirmation(
                      context,
                      l10n,
                    );
                    if (confirmed == true) onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  if (showEdit && onEdit != null)
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: SunTheme.sunOrange),
                          const SizedBox(width: 8),
                          Text(l10n.localeName == 'th' ? 'แก้ไข' : 'Edit'),
                        ],
                      ),
                    ),
                  if (onDelete != null)
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            l10n.localeName == 'th' ? 'ลบ' : 'Delete',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // Helper functions for employee name/initial
  String _getEmployeeName(dynamic employee) {
    if (employee == null) return '';
    if (employee is String) return employee;
    if (employee is Map && employee.containsKey('name')) {
      return employee['name'];
    }
    if (employee is Map && employee.containsKey('fullName')) {
      return employee['fullName'];
    }
    try {
      if (employee.name != null) return employee.name;
    } catch (_) {}
    return employee.toString();
  }

  String _getEmployeeInitial(dynamic employee) {
    final name = _getEmployeeName(employee);
    return name.isNotEmpty ? name.substring(0, 1) : '?';
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.localeName == 'th' ? 'ยืนยันการลบ' : 'Confirm Delete'),
        content: Text(
          l10n.localeName == 'th'
              ? 'คุณต้องการลบรายการนี้หรือไม่?'
              : 'Do you want to delete this item?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
