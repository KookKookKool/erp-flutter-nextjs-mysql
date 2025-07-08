import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/hrm/leave/widgets/add_leave_dialog.dart';
import 'package:frontend/modules/hrm/leave/bloc/leave_cubit.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: SunTheme.sunGold,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        final employees = [
          'EMP001:สมชาย ใจดี',
          'EMP002:สมหญิง ขยัน',
          'EMP003:John Doe',
        ];

        final leaveCubit = context.read<LeaveCubit>();
        final result = await showDialog(
          context: context,
          builder: (dialogContext) => AddLeaveDialog(
            onSave: (leave) async {
              Navigator.of(dialogContext).pop(leave);
            },
            employees: employees,
          ),
        );

        if (result != null) {
          leaveCubit.addLeave(result);
          // แสดงข้อความสำเร็จ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)?.localeName == 'th'
                    ? 'ส่งคำขอลาสำเร็จ รอการอนุมัติ'
                    : 'Leave request submitted successfully. Waiting for approval.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      icon: const Icon(Icons.beach_access, color: SunTheme.sunDeepOrange),
      label: Text(
        AppLocalizations.of(context)?.leave ?? 'Request Leave',
        style: textTheme.labelLarge?.copyWith(color: SunTheme.sunDeepOrange),
      ),
    );
  }
}
