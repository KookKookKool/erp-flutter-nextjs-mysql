import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/module_cubit.dart';
import '../theme/sun_theme.dart';

class SunDrawer extends StatelessWidget {
  const SunDrawer({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> modules = [
    {'icon': Icons.home, 'label': 'หน้าแรก', 'type': ModuleType.home},
    {'icon': Icons.people, 'label': 'HRM', 'type': ModuleType.hrm},
    {'icon': Icons.assignment, 'label': 'Project', 'type': ModuleType.project},
    {
      'icon': Icons.shopping_cart,
      'label': 'Purchasing',
      'type': ModuleType.purchasing,
    },
    {'icon': Icons.sell, 'label': 'Sales', 'type': ModuleType.sales},
    {
      'icon': Icons.inventory,
      'label': 'Inventory',
      'type': ModuleType.inventory,
    },
    {
      'icon': Icons.account_balance,
      'label': 'Accounting',
      'type': ModuleType.accounting,
    },
    {'icon': Icons.analytics, 'label': 'Reports', 'type': ModuleType.reports},
    {'icon': Icons.settings, 'label': 'Settings', 'type': ModuleType.settings},
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = context.watch<ModuleCubit>().state;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'SUN ERP',
                style: textTheme.titleLarge?.copyWith(
                  color: SunTheme.sunOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final m in modules)
                    ListTile(
                      leading: Icon(
                        m['icon'] as IconData,
                        color: SunTheme.sunDeepOrange,
                      ),
                      title: Text(
                        m['label'] as String,
                        style: textTheme.bodyLarge,
                      ),
                      selected: selected == m['type'],
                      selectedTileColor: SunTheme.sunLight,
                      onTap: () {
                        context.read<ModuleCubit>().select(
                          m['type'] as ModuleType,
                        );
                        Navigator.of(context).maybePop();
                      },
                    ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/org');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
