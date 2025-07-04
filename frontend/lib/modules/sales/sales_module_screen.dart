import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/module_cubit.dart';
import 'customer/customer_screen.dart';
import 'quotation/quotation_screen.dart';
import 'report/report_screen.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class SalesModuleScreen extends StatelessWidget {
  final String? submodule;
  const SalesModuleScreen({super.key, this.submodule});

  static const List<String> submodules = ['customer', 'quotation', 'report'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _SalesDesktopView(submodule: submodule)
        : _SalesMobileView(submodule: submodule);
  }
}

class _SalesDesktopView extends StatelessWidget {
  final String? submodule;
  const _SalesDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'quotation':
        return QuotationScreen();
      case 'report':
        return ReportScreen();
      case 'customer':
      default:
        return CustomerScreen();
    }
  }
}

class _SalesMobileView extends StatefulWidget {
  final String? submodule;
  const _SalesMobileView({this.submodule});
  @override
  State<_SalesMobileView> createState() => _SalesMobileViewState();
}

class _SalesMobileViewState extends State<_SalesMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = SalesModuleScreen.submodules;
  final List<Widget> _screens = [
    CustomerScreen(),
    QuotationScreen(),
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
  void didUpdateWidget(covariant _SalesMobileView oldWidget) {
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
      cubit.select(ModuleType.sales, submodule: _submodules[i]);
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
            label: l10n.salesCustomerModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: l10n.salesQuotationModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: l10n.salesReportModule,
          ),
        ],
      ),
    );
  }
}
