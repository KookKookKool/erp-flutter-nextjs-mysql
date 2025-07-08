import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/modules/hrm/services/ot_service.dart';

class AttendanceButtons extends StatelessWidget {
  const AttendanceButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: SunTheme.sunOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.login, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.checkIn,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: SunTheme.sunDeepOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.checkOut,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _showOtRequestDialog(context),
            icon: const Icon(Icons.access_time, color: Colors.white),
            label: Text(
              AppLocalizations.of(context)!.localeName == 'th'
                  ? 'ขอ OT'
                  : 'Request OT',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showOtRequestDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const OtRequestDialog());
  }
}

class OtRequestDialog extends StatefulWidget {
  const OtRequestDialog({super.key});

  @override
  State<OtRequestDialog> createState() => _OtRequestDialogState();
}

class _OtRequestDialogState extends State<OtRequestDialog> {
  DateTime? startTime;
  DateTime? endTime;
  final reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.localeName == 'th' ? 'ขอ OT' : 'Request OT'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 18, minute: 0),
                    );
                    if (picked != null) {
                      setState(() {
                        final now = DateTime.now();
                        startTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    startTime == null
                        ? (l10n.localeName == 'th'
                              ? 'เวลาเริ่ม OT'
                              : 'Start Time')
                        : '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 20, minute: 0),
                    );
                    if (picked != null) {
                      setState(() {
                        final now = DateTime.now();
                        endTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    endTime == null
                        ? (l10n.localeName == 'th'
                              ? 'เวลาสิ้นสุด OT'
                              : 'End Time')
                        : '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reasonController,
            decoration: InputDecoration(
              labelText: l10n.localeName == 'th'
                  ? 'เหตุผลการขอ OT'
                  : 'Reason for OT',
              border: const OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.leaveCancel),
        ),
        ElevatedButton(
          onPressed:
              startTime != null &&
                  endTime != null &&
                  reasonController.text.isNotEmpty
              ? () async {
                  try {
                    await OtService().submitOtRequest(
                      employeeId: 'EMP001', // TODO: ใช้ employee ID จริง
                      employeeName:
                          'สมชาย ใจดี', // TODO: ใช้ employee name จริง
                      date: DateTime.now(),
                      startTime: startTime!,
                      endTime: endTime!,
                      reason: reasonController.text,
                    );

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.localeName == 'th'
                              ? 'ส่งคำขอ OT เรียบร้อยแล้ว'
                              : 'OT request submitted successfully',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.localeName == 'th'
                              ? 'เกิดข้อผิดพลาดในการส่งคำขอ OT'
                              : 'Error submitting OT request',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              : null,
          child: Text(l10n.leaveSave),
        ),
      ],
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }
}
