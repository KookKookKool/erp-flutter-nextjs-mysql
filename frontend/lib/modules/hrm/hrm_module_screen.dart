import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/bloc/module_cubit.dart';
import 'employee/employee_list_screen.dart';
import 'attendance/attendance_screen.dart';
import 'payroll/payroll_screen.dart';
import 'leave/leave_screen.dart';
import 'leave/leave_approval_screen.dart';
import 'leave/leave_repository.dart';
import 'leave/bloc/leave_cubit.dart';
import '../../core/l10n/app_localizations.dart';

class HRMModuleScreen extends StatelessWidget {
  final String? submodule;
  const HRMModuleScreen({super.key, this.submodule});

  static final LeaveRepository leaveRepository = LeaveRepository();

  static const List<String> submodules = [
    'employee',
    'attendance',
    'payroll',
    'leave',
    'leaveApproval',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return MultiBlocProvider(
      providers: [
        BlocProvider<LeaveCubit>(
          create: (_) => LeaveCubit(leaveRepository),
        ),
      ],
      child: isDesktop
          ? _HRMDesktopView(submodule: submodule)
          : _HRMMobileView(submodule: submodule),
    );
  }
}

class _HRMDesktopView extends StatelessWidget {
  final String? submodule;
  const _HRMDesktopView({this.submodule});

  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'attendance':
        return AttendanceScreen();
      case 'payroll':
        return PayrollScreen();
      case 'leave':
        return LeaveScreen();
      case 'leaveApproval':
        return LeaveApprovalScreen(repository: HRMModuleScreen.leaveRepository);
      case 'employee':
      default:
        return EmployeeListScreen();
    }
  }
}

class _HRMMobileView extends StatefulWidget {
  final String? submodule;
  const _HRMMobileView({this.submodule});
  @override
  State<_HRMMobileView> createState() => _HRMMobileViewState();
}

class _HRMMobileViewState extends State<_HRMMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = HRMModuleScreen.submodules;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      EmployeeListScreen(),
      AttendanceScreen(),
      PayrollScreen(),
      LeaveScreen(),
      LeaveApprovalScreen(repository: HRMModuleScreen.leaveRepository),
    ];
    if (widget.submodule != null) {
      final idx = _submodules.indexOf(widget.submodule!);
      if (idx != -1) {
        _selectedIndex = idx;
      }
    }
  }

  @override
  void didUpdateWidget(covariant _HRMMobileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // sync index with submodule from state
    if (widget.submodule != null) {
      final idx = _submodules.indexOf(widget.submodule!);
      if (idx != -1 && idx != _selectedIndex) {
        setState(() {
          _selectedIndex = idx;
        });
      }
    }
  }

  void _onTab(int i) {
    setState(() {
      _selectedIndex = i;
    });
    // sync submodule to state
    final cubit = context.read<ModuleCubit>();
    if (cubit.state.submodule != _submodules[i]) {
      cubit.select(ModuleType.hrm, submodule: _submodules[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTab,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: l10n.employeeModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: l10n.attendanceModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: l10n.payrollModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: l10n.leaveModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: l10n.leaveApprovalModule,
          ),
        ],
      ),
    );
  }
}
