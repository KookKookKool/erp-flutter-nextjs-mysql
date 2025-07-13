import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'package:frontend/modules/hrm/leave/leave_repository.dart';
import 'package:frontend/modules/hrm/leave/bloc/leave_cubit.dart';
import 'package:frontend/modules/hrm/leave/widgets/leave_approval_card.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class LeaveApprovalTab extends StatefulWidget {
  final String search;

  const LeaveApprovalTab({super.key, required this.search});

  @override
  State<LeaveApprovalTab> createState() => _LeaveApprovalTabState();
}

class _LeaveApprovalTabState extends State<LeaveApprovalTab> {
  bool _isMultiSelectMode = false;
  Set<String> _selectedIds = {};

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<Leave> pendingRequests) {
    setState(() {
      _selectedIds = pendingRequests.map((req) => req.id).toSet();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedIds.clear();
    });
  }

  Future<void> _approveSelected(BuildContext context) async {
    final cubit = context.read<LeaveCubit>();
    for (String id in _selectedIds) {
      cubit.approveLeave(id);
    }
    _toggleMultiSelectMode();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'อนุมัติการลา ${_selectedIds.length} รายการเรียบร้อยแล้ว',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _rejectSelected(BuildContext context) async {
    final cubit = context.read<LeaveCubit>();
    for (String id in _selectedIds) {
      cubit.rejectLeave(id);
    }
    _toggleMultiSelectMode();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ปฏิเสธการลา ${_selectedIds.length} รายการแล้ว'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBatchApprovalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('อนุมัติการลา'),
        content: Text('ต้องการอนุมัติการลา ${_selectedIds.length} รายการ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              _approveSelected(context);
            },
            child: const Text('อนุมัติ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBatchRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ปฏิเสธการลา'),
        content: Text('ต้องการปฏิเสธการลา ${_selectedIds.length} รายการ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _rejectSelected(context);
            },
            child: const Text('ปฏิเสธ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LeaveCubit, LeaveState>(
      builder: (context, state) {
        // Filter pending leaves by search term
        final searchFiltered = state.leaves
            .where((leave) => leave.status == 'pending')
            .where(
              (leave) =>
                  widget.search.isEmpty ||
                  leave.employeeName.toLowerCase().contains(
                    widget.search.toLowerCase(),
                  ) ||
                  leave.employeeId.toLowerCase().contains(
                    widget.search.toLowerCase(),
                  ),
            )
            .toList();

        // Get pending requests for multi-select actions
        final pendingRequests = searchFiltered;

        return Stack(
          children: [
            Column(
              children: [
                // Multi-select toggle controls
                _buildMultiSelectToggle(pendingRequests, l10n),

                // Content
                Expanded(child: _buildContent(pendingRequests, l10n)),
              ],
            ),

            // Fixed bottom action bar for multi-select
            if (_isMultiSelectMode && _selectedIds.isNotEmpty)
              _buildBottomActionBar(l10n),
          ],
        );
      },
    );
  }

  Widget _buildMultiSelectToggle(
    List<Leave> pendingRequests,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Multi-select toggle button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isMultiSelectMode ? Colors.orange : Colors.grey,
              foregroundColor: Colors.white,
            ),
            onPressed: pendingRequests.isNotEmpty
                ? _toggleMultiSelectMode
                : null,
            icon: Icon(_isMultiSelectMode ? Icons.close : Icons.checklist),
            label: Text(
              _isMultiSelectMode ? l10n.CancelMultiSelect : l10n.MultiSelect,
            ),
          ),

          if (_isMultiSelectMode) ...[
            const SizedBox(width: 8),
            // Select all/deselect all
            TextButton.icon(
              onPressed: _selectedIds.length == pendingRequests.length
                  ? _deselectAll
                  : () => _selectAll(pendingRequests),
              icon: Icon(
                _selectedIds.length == pendingRequests.length
                    ? Icons.deselect
                    : Icons.select_all,
              ),
              label: Text(
                _selectedIds.length == pendingRequests.length
                    ? l10n.DeselectAll
                    : l10n.SelectAll,
              ),
            ),

            const Spacer(),

            // Selected count
            Text(l10n.SelectedCount(_selectedIds.length)),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(AppLocalizations l10n) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Row(
            children: [
              // Selected count
              Expanded(
                child: Text(
                  l10n.SelectedCount(_selectedIds.length),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Batch approve button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _showBatchApprovalDialog(context),
                icon: const Icon(Icons.check),
                label: Text(l10n.approve),
              ),

              const SizedBox(width: 8),

              // Batch reject button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _showBatchRejectDialog(context),
                icon: const Icon(Icons.close),
                label: const Text('ปฏิเสธ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<Leave> filtered, AppLocalizations l10n) {
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.beach_access, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _isMultiSelectMode
                  ? 'ไม่มีรายการการลาที่รอนุมัติ'
                  : 'No leave requests found',
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: _isMultiSelectMode && _selectedIds.isNotEmpty ? 80 : 0,
        ),
        child: ResponsiveCardGrid(
          cardHeight: WidgetStyles.cardHeightExtraLarge,
          children: filtered
              .map(
                (leave) => LeaveApprovalCard(
                  leave: leave,
                  isSelected: _selectedIds.contains(leave.id),
                  isMultiSelectMode: _isMultiSelectMode,
                  onToggleSelection: () => _toggleSelection(leave.id),
                  onApprove: _isMultiSelectMode
                      ? null
                      : () => context.read<LeaveCubit>().approveLeave(leave.id),
                  onReject: _isMultiSelectMode
                      ? null
                      : () => context.read<LeaveCubit>().rejectLeave(leave.id),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
