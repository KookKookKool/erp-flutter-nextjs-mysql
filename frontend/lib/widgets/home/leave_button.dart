import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/modules/hrm/leave/widgets/add_leave_dialog.dart';
import 'package:frontend/modules/hrm/leave/bloc/leave_cubit.dart';
import 'package:frontend/modules/hrm/leave/leave_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final cubit = BlocProvider.of<LeaveCubit>(context);
        final employees = ['สมชาย ใจดี', 'สมหญิง ขยัน', 'John Doe'];
        final result = await showDialog<Leave>(
          context: context,
          builder: (ctx) => AddLeaveDialog(
            onSave: (leave) => Navigator.of(ctx).pop(leave),
            employees: employees,
          ),
        );
        if (result != null) {
          cubit.addLeave(result.copyWith(status: 'pending'));
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
