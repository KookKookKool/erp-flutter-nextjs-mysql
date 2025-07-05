import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/bloc/module_cubit.dart';
import 'task/task_screen.dart';
import 'status/status_screen.dart';
import 'notification/notification_screen.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class ProjectModuleScreen extends StatelessWidget {
  final String? submodule;
  const ProjectModuleScreen({super.key, this.submodule});

  static const List<String> submodules = ['task', 'status', 'notification'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _ProjectDesktopView(submodule: submodule)
        : _ProjectMobileView(submodule: submodule);
  }
}

class _ProjectDesktopView extends StatelessWidget {
  final String? submodule;
  const _ProjectDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'status':
        return StatusScreen();
      case 'notification':
        return NotificationScreen();
      case 'task':
      default:
        return TaskScreen();
    }
  }
}

class _ProjectMobileView extends StatefulWidget {
  final String? submodule;
  const _ProjectMobileView({this.submodule});
  @override
  State<_ProjectMobileView> createState() => _ProjectMobileViewState();
}

class _ProjectMobileViewState extends State<_ProjectMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = ProjectModuleScreen.submodules;
  final List<Widget> _screens = [
    TaskScreen(),
    StatusScreen(),
    NotificationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.submodule != null) {
      final idx = _submodules.indexOf(widget.submodule!);
      if (idx != -1) {
        _selectedIndex = idx;
      }
    }
  }

  @override
  void didUpdateWidget(covariant _ProjectMobileView oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    final cubit = context.read<ModuleCubit>();
    if (cubit.state.submodule != _submodules[i]) {
      cubit.select(ModuleType.project, submodule: _submodules[i]);
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
            icon: Icon(Icons.assignment),
            label: l10n.projectTaskModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: l10n.projectStatusModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: l10n.projectNotificationModule,
          ),
        ],
      ),
    );
  }
}
