import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import '../models/ot_request.dart';

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
            ? Colors.blue.withOpacity(0.1)
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
                      _buildStatusChip(),
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
                        '${_formatTime(widget.otRequest.startTime)} - ${_formatTime(widget.otRequest.endTime)} (${hours.toStringAsFixed(1)} ชม.)',
                        style: TextStyle(color: SunTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'เหตุผล: ${widget.otRequest.reason}',
                    style: TextStyle(color: SunTheme.textSecondary),
                  ),
                  if (widget.otRequest.status == OtStatus.pending &&
                      !widget.isMultiSelectMode) ...[
                    const SizedBox(height: 12),
                    _buildApprovalButtons(),
                  ],
                  if (widget.otRequest.status == OtStatus.approved &&
                      widget.otRequest.rate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'อนุมัติแล้ว (เรท x${widget.otRequest.rate})',
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

  Widget _buildStatusChip() {
    Color color;
    String text;
    switch (widget.otRequest.status) {
      case OtStatus.pending:
        color = Colors.orange;
        text = 'รออนุมัติ';
        break;
      case OtStatus.approved:
        color = Colors.green;
        text = 'อนุมัติแล้ว';
        break;
      case OtStatus.rejected:
        color = Colors.red;
        text = 'ปฏิเสธ';
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

  Widget _buildApprovalButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: widget.onApprove != null
                ? () => _showRateDialog()
                : null,
            icon: const Icon(Icons.check, size: 16),
            label: const Text('อนุมัติ'),
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
            label: const Text('ปฏิเสธ'),
          ),
        ),
      ],
    );
  }

  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('เลือกเรท OT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('อนุมัติ OT ของ ${widget.otRequest.employeeName}'),
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
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
