import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/bloc/module_cubit.dart';
import 'product/product_screen.dart';
import 'stock/stock_screen.dart';
import 'transaction/transaction_screen.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class InventoryModuleScreen extends StatelessWidget {
  final String? submodule;
  const InventoryModuleScreen({super.key, this.submodule});

  static const List<String> submodules = ['product', 'stock', 'transaction'];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _InventoryDesktopView(submodule: submodule)
        : _InventoryMobileView(submodule: submodule);
  }
}

class _InventoryDesktopView extends StatelessWidget {
  final String? submodule;
  const _InventoryDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    switch (submodule) {
      case 'stock':
        return StockScreen();
      case 'transaction':
        return TransactionScreen();
      case 'product':
      default:
        return ProductScreen();
    }
  }
}

class _InventoryMobileView extends StatefulWidget {
  final String? submodule;
  const _InventoryMobileView({this.submodule});
  @override
  State<_InventoryMobileView> createState() => _InventoryMobileViewState();
}

class _InventoryMobileViewState extends State<_InventoryMobileView> {
  int _selectedIndex = 0;
  final List<String> _submodules = InventoryModuleScreen.submodules;
  final List<Widget> _screens = [
    ProductScreen(),
    StockScreen(),
    TransactionScreen(),
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
  void didUpdateWidget(covariant _InventoryMobileView oldWidget) {
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
      cubit.select(ModuleType.inventory, submodule: _submodules[i]);
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
            icon: Icon(Icons.inventory),
            label: l10n.inventoryProductModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: l10n.inventoryStockModule,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: l10n.inventoryTransactionModule,
          ),
        ],
      ),
    );
  }
}
