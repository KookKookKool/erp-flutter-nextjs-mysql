import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/module_cubit.dart';
import 'order/order_screen.dart';
import 'supplier/supplier_screen.dart';
import 'report/report_screen.dart';
import '../../core/l10n/app_localizations.dart';

class PurchasingModuleScreen extends StatelessWidget {
  final String? submodule;
  const PurchasingModuleScreen({super.key, this.submodule});

  static const List<String> submodules = ['order', 'supplier', 'report'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _PurchasingDesktopView(submodule: submodule)
        : _PurchasingMobileView(submodule: submodule);
  }
}

class _PurchasingDesktopView extends StatelessWidget {
  final String? submodule;
  const _PurchasingDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'supplier':
        return SupplierScreen();
      case 'report':
        return ReportScreen();
      case 'order':
      default:
        return OrderScreen();
    }
  }
}

class _PurchasingMobileView extends StatefulWidget {
  final String? submodule;
  const _PurchasingMobileView({this.submodule});
  @override
  State<_PurchasingMobileView> createState() => _PurchasingMobileViewState();
}

class _PurchasingMobileViewState extends State<_PurchasingMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = PurchasingModuleScreen.submodules;
  final List<Widget> _screens = [
    OrderScreen(),
    SupplierScreen(),
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
  void didUpdateWidget(covariant _PurchasingMobileView oldWidget) {
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
      cubit.select(ModuleType.purchasing, submodule: _submodules[i]);
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
            icon: Icon(Icons.shopping_cart),
            label: l10n.purchasingOrderModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: l10n.purchasingSupplierModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: l10n.purchasingReportModule,
          ),
        ],
      ),
    );
  }
}
