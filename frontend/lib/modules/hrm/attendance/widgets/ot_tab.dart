import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'package:frontend/modules/hrm/attendance/models/ot_request.dart';
import 'package:frontend/modules/hrm/attendance/bloc/ot_cubit.dart';
import 'package:frontend/modules/hrm/attendance/bloc/ot_state.dart';
import 'package:frontend/modules/hrm/attendance/widgets/ot_request_card.dart';

class OtTab extends StatefulWidget {
  final String search;

  const OtTab({super.key, required this.search});

  @override
  State<OtTab> createState() => _OtTabState();
}

class _OtTabState extends State<OtTab> {
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

  void _selectAll(List<OtRequest> pendingRequests) {
    setState(() {
      _selectedIds = pendingRequests.map((req) => req.id).toSet();
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedIds.clear();
    });
  }

  Future<void> _approveSelected(BuildContext context, double rate) async {
    final cubit = context.read<OtCubit>();
    for (String id in _selectedIds) {
      await cubit.approveOtRequest(id, otRate: rate);
    }
    _toggleMultiSelectMode();
  }

  Future<void> _rejectSelected(BuildContext context) async {
    final cubit = context.read<OtCubit>();
    for (String id in _selectedIds) {
      await cubit.rejectOtRequest(id);
    }
    _toggleMultiSelectMode();
  }

  void _showBatchApprovalDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.otSelectRate),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.otApprove} ${_selectedIds.length} ${l10n.otRequest}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _approveSelected(context, 1.5);
                  },
                  child: const Text('x1.5'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _approveSelected(context, 3.0);
                  },
                  child: const Text('x3.0'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showBatchRejectDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.otReject),
        content: Text(
          '${l10n.otReject} ${_selectedIds.length} ${l10n.otRequest}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _rejectSelected(context);
            },
            child: Text(
              l10n.otReject,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtCubit, OtState>(
      listener: (context, state) {
        if (state is OtError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is OtSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is OtProcessed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.blue,
            ),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        if (state is OtInitial) {
          return Center(child: Text(l10n.loading));
        }

        if (state is OtLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OtError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<OtCubit>().loadOtRequests(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        final otRequests = state is OtLoaded ? state.requests : <OtRequest>[];

        // Filter by search term
        final searchFiltered = widget.search.isEmpty
            ? otRequests
            : otRequests
                  .where(
                    (ot) =>
                        ot.employeeName.toLowerCase().contains(
                          widget.search.toLowerCase(),
                        ) ||
                        ot.employeeId.toLowerCase().contains(
                          widget.search.toLowerCase(),
                        ),
                  )
                  .toList();

        // If in multi-select mode, show only pending requests
        final filtered = _isMultiSelectMode
            ? searchFiltered
                  .where((ot) => ot.status == OtStatus.pending)
                  .toList()
            : searchFiltered;

        // Get pending requests for multi-select actions
        final pendingRequests = filtered
            .where((ot) => ot.status == OtStatus.pending)
            .toList();

        return Stack(
          children: [
            Column(
              children: [
                // Multi-select toggle controls (only toggle button)
                _buildMultiSelectToggle(pendingRequests),

                // Content
                Expanded(child: _buildContent(filtered)),
              ],
            ),

            // Fixed bottom action bar for multi-select
            if (_isMultiSelectMode && _selectedIds.isNotEmpty)
              _buildBottomActionBar(),
          ],
        );
      },
    );
  }

  Widget _buildMultiSelectToggle(List<OtRequest> pendingRequests) {
    final l10n = AppLocalizations.of(context)!;
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
              _isMultiSelectMode
                  ? l10n.cancelMultiSelect
                  : l10n.multiSelect,
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
                    ? l10n.deselectAll
                    : l10n.selectAll,
              ),
            ),

            const Spacer(),

            // Selected count
            Text(l10n.selectedCount(_selectedIds.length)),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.selectedCount(_selectedIds.length),
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
                label: Text(l10n.reject),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<OtRequest> filtered) {
    final l10n = AppLocalizations.of(context)!;
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _isMultiSelectMode ? l10n.otNoPendingRequests : l10n.otNoRequests,
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
                (otRequest) => OtRequestCard(
                  otRequest: otRequest,
                  isSelected: _selectedIds.contains(otRequest.id),
                  isMultiSelectMode: _isMultiSelectMode,
                  onToggleSelection: () => _toggleSelection(otRequest.id),
                  onApprove: _isMultiSelectMode
                      ? null
                      : (rate) => context.read<OtCubit>().approveOtRequest(
                          otRequest.id,
                          otRate: rate,
                        ),
                  onReject: _isMultiSelectMode
                      ? null
                      : () => context.read<OtCubit>().rejectOtRequest(
                          otRequest.id,
                        ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
