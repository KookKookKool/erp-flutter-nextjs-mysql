import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import '../attendance_screen.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class AttendanceEditDialog extends StatefulWidget {
  final EmployeeAttendance employee;
  final DateTime today;
  const AttendanceEditDialog({
    super.key,
    required this.employee,
    required this.today,
  });
  @override
  State<AttendanceEditDialog> createState() => _AttendanceEditDialogState();
}

class _AttendanceEditDialogState extends State<AttendanceEditDialog> {
  late DateTime selectedDate;
  DateTime? checkIn;
  DateTime? checkOut;
  DateTime? otStart;
  DateTime? otEnd;
  double otRate = 1.5;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(
      widget.today.year,
      widget.today.month,
      widget.today.day,
    );
    final rec =
        widget.employee.records[selectedDate] ??
        {
          'in': null,
          'out': null,
          'otStart': null,
          'otEnd': null,
          'otRate': 1.5,
        };
    checkIn = rec['in'];
    checkOut = rec['out'];
    otStart = rec['otStart'];
    otEnd = rec['otEnd'];
    otRate = rec['otRate'] ?? 1.5;
  }

  Future<void> _pickTime(
    BuildContext context,
    DateTime? initial,
    ValueChanged<DateTime?> onPicked,
  ) async {
    final now = TimeOfDay.now();
    final init = initial != null
        ? TimeOfDay(hour: initial.hour, minute: initial.minute)
        : now;
    final picked = await showTimePicker(context: context, initialTime: init);
    if (picked != null) {
      final dt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );
      onPicked(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: SunTheme.cardColor,
      title: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.employee.id} - ${widget.employee.name}',
              style: TextStyle(color: SunTheme.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: l10n.pickStartDate,
            color: SunTheme.primary,
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                  final rec =
                      widget.employee.records[selectedDate] ??
                      {
                        'in': null,
                        'out': null,
                        'otStart': null,
                        'otEnd': null,
                        'otRate': 1.5,
                      };
                  checkIn = rec['in'];
                  checkOut = rec['out'];
                  otStart = rec['otStart'];
                  otEnd = rec['otEnd'];
                  otRate = rec['otRate'] ?? 1.5;
                });
              }
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: SunTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.checkIn}:',
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickTime(
                    context,
                    checkIn,
                    (dt) => setState(() => checkIn = dt),
                  ),
                  child: Text(
                    _formatTime(checkIn),
                    style: TextStyle(color: SunTheme.primary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => checkIn = null),
                  tooltip: l10n.cancel,
                  color: SunTheme.error,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.checkOut}:',
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickTime(
                    context,
                    checkOut,
                    (dt) => setState(() => checkOut = dt),
                  ),
                  child: Text(
                    _formatTime(checkOut),
                    style: TextStyle(color: SunTheme.primary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => checkOut = null),
                  tooltip: l10n.cancel,
                  color: SunTheme.error,
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.otStart,
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickTime(
                    context,
                    otStart,
                    (dt) => setState(() => otStart = dt),
                  ),
                  child: Text(
                    _formatTime(otStart),
                    style: TextStyle(color: SunTheme.primary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => otStart = null),
                  tooltip: l10n.cancel,
                  color: SunTheme.error,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.otEnd,
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickTime(
                    context,
                    otEnd,
                    (dt) => setState(() => otEnd = dt),
                  ),
                  child: Text(
                    _formatTime(otEnd),
                    style: TextStyle(color: SunTheme.primary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => otEnd = null),
                  tooltip: l10n.cancel,
                  color: SunTheme.error,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.otRate,
                    style: TextStyle(color: SunTheme.textPrimary),
                  ),
                ),
                DropdownButton<double>(
                  value: otRate,
                  items: [1.0, 1.5, 2.0, 3.0]
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(
                            'x$r',
                            style: TextStyle(color: SunTheme.textPrimary),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => otRate = v ?? 1.5),
                  dropdownColor: SunTheme.cardColor,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: TextStyle(color: SunTheme.primary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.primary,
            foregroundColor: SunTheme.onPrimary,
          ),
          onPressed: () {
            widget.employee.records[selectedDate] = {
              'in': checkIn,
              'out': checkOut,
              'otStart': otStart,
              'otEnd': otEnd,
              'otRate': otRate,
            };
            Navigator.pop(context);
          },
          child: Text(l10n.save, style: TextStyle(color: SunTheme.onPrimary)),
        ),
      ],
    );
  }

  String _formatTime(dynamic dt) {
    if (dt == null || dt is! DateTime) return '-';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
