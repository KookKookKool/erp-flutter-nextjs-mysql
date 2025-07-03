import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/module_cubit.dart';
import 'income/income_screen.dart';
import 'finance/finance_screen.dart';
import 'report/report_screen.dart';
import '../../l10n/app_localizations.dart';

class AccountingModuleScreen extends StatelessWidget {
  final String? submodule;
  const AccountingModuleScreen({super.key, this.submodule});

  static const List<String> submodules = ['income', 'finance', 'report'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _AccountingDesktopView(submodule: submodule)
        : _AccountingMobileView(submodule: submodule);
  }
}

class _AccountingDesktopView extends StatelessWidget {
  final String? submodule;
  const _AccountingDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'finance':
        return FinanceScreen();
      case 'report':
        return ReportScreen();
      case 'income':
      default:
        return IncomeScreen();
    }
  }
}

class _AccountingMobileView extends StatefulWidget {
  final String? submodule;
  const _AccountingMobileView({this.submodule});
  @override
  State<_AccountingMobileView> createState() => _AccountingMobileViewState();
}

class _AccountingMobileViewState extends State<_AccountingMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = AccountingModuleScreen.submodules;
  final List<Widget> _screens = [
    IncomeScreen(),
    FinanceScreen(),
    ReportScreen(),
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
  void didUpdateWidget(covariant _AccountingMobileView oldWidget) {
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
      cubit.select(ModuleType.accounting, submodule: _submodules[i]);
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
            icon: Icon(Icons.attach_money),
            label: l10n.accountingIncomeModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: l10n.accountingFinanceModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: l10n.accountingReportModule,
          ),
        ],
      ),
    );
  }
}
