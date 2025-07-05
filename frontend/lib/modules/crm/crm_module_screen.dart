import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/bloc/module_cubit.dart';
import 'customer/customer_screen.dart';
import 'history/history_screen.dart';
import 'activity/activity_screen.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class CrmModuleScreen extends StatelessWidget {
  final String? submodule;
  const CrmModuleScreen({super.key, this.submodule});

  static const List<String> submodules = ['customer', 'history', 'activity'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _CrmDesktopView(submodule: submodule)
        : _CrmMobileView(submodule: submodule);
  }
}

class _CrmDesktopView extends StatelessWidget {
  final String? submodule;
  const _CrmDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'history':
        return HistoryScreen();
      case 'activity':
        return ActivityScreen();
      case 'customer':
      default:
        return CustomerScreen();
    }
  }
}

class _CrmMobileView extends StatefulWidget {
  final String? submodule;
  const _CrmMobileView({this.submodule});
  @override
  State<_CrmMobileView> createState() => _CrmMobileViewState();
}

class _CrmMobileViewState extends State<_CrmMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = CrmModuleScreen.submodules;
  final List<Widget> _screens = [
    CustomerScreen(),
    HistoryScreen(),
    ActivityScreen(),
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
  void didUpdateWidget(covariant _CrmMobileView oldWidget) {
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
      cubit.select(ModuleType.crm, submodule: _submodules[i]);
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
            label: l10n.crmCustomerModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: l10n.crmHistoryModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: l10n.crmActivityModule,
          ),
        ],
      ),
    );
  }
}
