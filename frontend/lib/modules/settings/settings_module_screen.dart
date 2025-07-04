import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/module_cubit.dart';
import 'user/user_screen.dart';
import 'permission/permission_screen.dart';
import 'config/config_screen.dart';
import 'notification/notification_screen.dart';
import '../../core/l10n/app_localizations.dart';

class SettingsModuleScreen extends StatelessWidget {
  final String? submodule;
  const SettingsModuleScreen({super.key, this.submodule});

  static const List<String> submodules = [
    'user',
    'permission',
    'config',
    'notification',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _SettingsDesktopView(submodule: submodule)
        : _SettingsMobileView(submodule: submodule);
  }
}

class _SettingsDesktopView extends StatelessWidget {
  final String? submodule;
  const _SettingsDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'permission':
        return PermissionScreen();
      case 'config':
        return ConfigScreen();
      case 'notification':
        return NotificationScreen();
      case 'user':
      default:
        return UserScreen();
    }
  }
}

class _SettingsMobileView extends StatefulWidget {
  final String? submodule;
  const _SettingsMobileView({this.submodule});
  @override
  State<_SettingsMobileView> createState() => _SettingsMobileViewState();
}

class _SettingsMobileViewState extends State<_SettingsMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = SettingsModuleScreen.submodules;
  final List<Widget> _screens = [
    UserScreen(),
    PermissionScreen(),
    ConfigScreen(),
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
  void didUpdateWidget(covariant _SettingsMobileView oldWidget) {
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
      cubit.select(ModuleType.settings, submodule: _submodules[i]);
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
            icon: Icon(Icons.person),
            label: l10n.settingsUserModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: l10n.settingsPermissionModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: l10n.settingsConfigModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: l10n.settingsNotificationModule,
          ),
        ],
      ),
    );
  }
}
