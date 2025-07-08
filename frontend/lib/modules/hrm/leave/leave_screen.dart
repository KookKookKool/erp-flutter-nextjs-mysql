import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'widgets/leave_card.dart';
import 'widgets/leave_search_bar.dart';
import 'widgets/add_leave_dialog.dart';
import 'leave_repository.dart';
import 'bloc/leave_cubit.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repository = context.read<LeaveCubit>().repository;
    return _LeaveScreenView(l10n: l10n, repository: repository);
  }
}

class _LeaveScreenView extends StatefulWidget {
  final AppLocalizations l10n;
  final LeaveRepository repository;
  const _LeaveScreenView({required this.l10n, required this.repository});
  @override
  State<_LeaveScreenView> createState() => _LeaveScreenViewState();
}

class _LeaveScreenViewState extends State<_LeaveScreenView> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.l10n.leaveTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LeaveSearchBar(
              value: _search,
              onChanged: (v) => setState(() => _search = v.trim()),
            ),
            Expanded(
              child: BlocBuilder<LeaveCubit, LeaveState>(
                builder: (context, state) {
                  final filtered = _search.isEmpty
                      ? state.leaves
                      : state.leaves
                            .where(
                              (leave) =>
                                  leave.employeeName.toLowerCase().contains(
                                    _search.toLowerCase(),
                                  ) ||
                                  leave.employeeId.toLowerCase().contains(
                                    _search.toLowerCase(),
                                  ),
                            )
                            .toList();
                  return ResponsiveCardGrid(
                    cardHeight: WidgetStyles.cardHeightMedium,
                    children: filtered
                        .map(
                          (leave) => GestureDetector(
                            onTap: () => _showEditDialog(leave),
                            child: LeaveCard(
                              leave: leave,
                              onEdit: () => _showEditDialog(leave),
                              onDelete: () => _deleteLeave(leave.id),
                              showEdit: true,
                              showStatusChip: true,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _mockEmployees() => [
    'EMP001:สมชาย ใจดี',
    'EMP002:สมหญิง ขยัน',
    'EMP003:John Doe',
  ];

  void _showEditDialog(Leave leave) async {
    final result = await showDialog<Leave>(
      context: context,
      builder: (ctx) => AddLeaveDialog(
        onSave: (edited) async {
          Navigator.of(ctx).pop(edited);
        },
        onDelete: () =>
            _deleteLeave(leave.id), // ใช้ leave.id แทน leave.employeeId
        employees: _mockEmployees(),
        initial: leave,
      ),
    );
    if (result != null) {
      context.read<LeaveCubit>().editLeave(result);
    }
  }

  void _deleteLeave(String id) {
    context.read<LeaveCubit>().deleteLeave(id);
  }
}
