import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import '../models/ot_request.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class OtRequestCard extends StatefulWidget {
  final OtRequest otRequest;
  final Function(double)? onApprove;
  final VoidCallback? onReject;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback? onToggleSelection;

  const OtRequestCard({
    super.key,
    required this.otRequest,
    this.onApprove,
    this.onReject,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onToggleSelection,
  });

  @override
  State<OtRequestCard> createState() => _OtRequestCardState();
}

class _OtRequestCardState extends State<OtRequestCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duration = widget.otRequest.endTime.difference(
      widget.otRequest.startTime,
    );
    final hours = duration.inMinutes / 60;

    return GestureDetector(
      onTap:
          widget.isMultiSelectMode &&
              widget.otRequest.status == OtStatus.pending
          ? widget.onToggleSelection
          : null,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: widget.isSelected
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
        ),
        color: widget.isSelected
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
                          widget.otRequest.employeeName.characters.first,
                          style: TextStyle(color: SunTheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.otRequest.employeeId} - ${widget.otRequest.employeeName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SunTheme.textPrimary,
                              ),
                            ),
                            Text(
                              _formatDate(widget.otRequest.date),
                              style: TextStyle(color: SunTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(l10n),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: SunTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatTime(widget.otRequest.startTime)} - ${_formatTime(widget.otRequest.endTime)} (${hours.toStringAsFixed(1)} ${l10n.otHourShort})',
                        style: TextStyle(color: SunTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.otReason(widget.otRequest.reason),
                    style: TextStyle(color: SunTheme.textSecondary),
                  ),
                  if (widget.otRequest.status == OtStatus.pending &&
                      !widget.isMultiSelectMode) ...[
                    const SizedBox(height: 12),
                    _buildApprovalButtons(l10n),
                  ],
                  if (widget.otRequest.status == OtStatus.approved &&
                      widget.otRequest.rate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.otApprovedWithRate(
                        widget.otRequest.rate!.toString(),
                      ),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Selection checkbox for multi-select mode
            if (widget.isMultiSelectMode &&
                widget.otRequest.status == OtStatus.pending)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  widget.isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: widget.isSelected ? Colors.blue : Colors.grey,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppLocalizations l10n) {
    Color color;
    String text;
    switch (widget.otRequest.status) {
      case OtStatus.pending:
        color = Colors.orange;
        text = l10n.otStatusPending;
        break;
      case OtStatus.approved:
        color = Colors.green;
        text = l10n.otStatusApproved;
        break;
      case OtStatus.rejected:
        color = Colors.red;
        text = l10n.otStatusRejected;
        break;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildApprovalButtons(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: widget.onApprove != null
                ? () => _showRateDialog(l10n)
                : null,
            icon: const Icon(Icons.check, size: 16),
            label: Text(l10n.otApproveButton),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: widget.onReject,
            icon: const Icon(Icons.close, size: 16),
            label: Text(l10n.otRejectButton),
          ),
        ),
      ],
    );
  }

  void _showRateDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.otSelectRateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.otApproveOf(widget.otRequest.employeeName)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    widget.onApprove!(1.5);
                  },
                  child: const Text('x1.5'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    widget.onApprove!(3.0);
                  },
                  child: const Text('x3.0'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.otCancel),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
