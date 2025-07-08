import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/widgets/responsive_card_grid.dart';
import 'package:frontend/core/theme/widget_styles.dart';
import 'package:frontend/core/theme/sun_theme.dart';
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

class _LeaveScreenViewState extends State<_LeaveScreenView>
    with TickerProviderStateMixin {
  String _search = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 16),
            // Tab Bar สำหรับสลับระหว่างการลาและอนุมัติการลา
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: SunTheme.sunOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    text: widget.l10n.leaveModule,
                    icon: const Icon(Icons.beach_access),
                  ),
                  Tab(
                    text: widget.l10n.leaveApprovalModule,
                    icon: const Icon(Icons.approval),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildLeaveTab(), _buildApprovalTab()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLeaveDialog,
        backgroundColor: SunTheme.sunOrange,
        tooltip: widget.l10n.leaveAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Tab สำหรับแสดงรายการการลา
  Widget _buildLeaveTab() {
    return BlocBuilder<LeaveCubit, LeaveState>(
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
    );
  }

  // Tab สำหรับแสดงรายการอนุมัติการลา
  Widget _buildApprovalTab() {
    return BlocBuilder<LeaveCubit, LeaveState>(
      builder: (context, state) {
        final filtered = state.leaves
            .where((leave) => leave.status == 'pending')
            .where(
              (leave) =>
                  _search.isEmpty ||
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
                (leave) => LeaveCard(
                  leave: leave,
                  showEdit: false,
                  showStatusChip: false,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        tooltip: widget.l10n.leaveStatusApproved,
                        onPressed: () => _approveLeave(leave),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
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
    );
  }

  List<String> _mockEmployees() => [
    'EMP001:สมชาย ใจดี',
    'EMP002:สมหญิง ขยัน',
    'EMP003:John Doe',
  ];

  void _showAddLeaveDialog() async {
    final employees = _mockEmployees();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.l10n.localeName == 'th'
                  ? 'เพิ่มการลาสำเร็จ รอการอนุมัติ'
                  : 'Leave request added successfully. Waiting for approval.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showEditDialog(Leave leave) async {
    final result = await showDialog<Leave>(
      context: context,
      builder: (ctx) => AddLeaveDialog(
        onSave: (edited) async {
          Navigator.of(ctx).pop(edited);
        },
        onDelete: () => _deleteLeave(leave.id),
        employees: _mockEmployees(),
        initial: leave,
      ),
    );
    if (result != null && mounted) {
      context.read<LeaveCubit>().editLeave(result);
    }
  }

  void _deleteLeave(String id) {
    context.read<LeaveCubit>().deleteLeave(id);
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
    if (deductSalary != null && mounted) {
      context.read<LeaveCubit>().approveLeave(
        leave.id,
        true,
        deductSalary: deductSalary,
      );
      // แสดงข้อความยืนยันการอนุมัติ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.l10n.localeName == 'th'
                ? 'อนุมัติการลาเรียบร้อยแล้ว'
                : 'Leave approved successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _rejectLeave(Leave leave) {
    context.read<LeaveCubit>().approveLeave(leave.id, false);
    // แสดงข้อความยืนยันการปฏิเสธ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.l10n.localeName == 'th'
              ? 'ปฏิเสธการลาเรียบร้อยแล้ว'
              : 'Leave rejected successfully',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
