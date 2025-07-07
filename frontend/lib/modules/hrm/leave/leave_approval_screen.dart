import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'widgets/leave_card.dart';
import 'widgets/leave_search_bar.dart';
import 'leave_repository.dart';
import 'bloc/leave_cubit.dart';

class LeaveApprovalScreen extends StatelessWidget {
  final LeaveRepository repository;
  const LeaveApprovalScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _LeaveApprovalScreenView(l10n: l10n);
  }
}

class _LeaveApprovalScreenView extends StatefulWidget {
  final AppLocalizations l10n;
  const _LeaveApprovalScreenView({required this.l10n});
  @override
  State<_LeaveApprovalScreenView> createState() =>
      _LeaveApprovalScreenViewState();
}

class _LeaveApprovalScreenViewState extends State<_LeaveApprovalScreenView> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.l10n.leaveApprovalTitle),
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
                  final filtered = state.leaves
                      .where((leave) => leave.status == 'pending')
                      .where(
                        (leave) =>
                            _search.isEmpty ||
                            leave.employee.toLowerCase().contains(
                              _search.toLowerCase(),
                            ) ||
                            leave.id.toLowerCase().contains(
                              _search.toLowerCase(),
                            ),
                      )
                      .toList();
                  return ResponsiveCardGrid(
                    cardHeight: WidgetStyles.cardHeightMedium,
                    children: filtered
                        .map(
                          (leave) => LeaveCard(
                            leave: leave,
                            showEdit: false,
                            showStatusChip: false,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  tooltip: widget.l10n.leaveStatusApproved,
                                  onPressed: () => _approveLeave(leave),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  tooltip: widget.l10n.leaveStatusRejected,
                                  onPressed: () => _rejectLeave(leave),
                                ),
                              ],
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

  void _approveLeave(Leave leave) async {
    final l10n = widget.l10n;
    bool? deductSalary = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.leaveStatusApproved),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.localeName == 'th'
                  ? 'ต้องการหักเงินเดือนสำหรับการลาครั้งนี้หรือไม่?'
                  : 'Deduct salary for this leave?',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.localeName == 'th' ? 'หักเงิน' : 'Deduct'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    l10n.localeName == 'th' ? 'ไม่หักเงิน' : 'No Deduct',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (deductSalary != null) {
      context.read<LeaveCubit>().approveLeave(
        leave.id,
        true,
        deductSalary: deductSalary,
      );
      setState(() {});
    }
  }

  void _rejectLeave(Leave leave) {
    context.read<LeaveCubit>().approveLeave(leave.id, false);
    setState(() {});
  }
}
