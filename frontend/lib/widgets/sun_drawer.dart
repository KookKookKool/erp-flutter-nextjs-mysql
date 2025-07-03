import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/main.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '../bloc/module_cubit.dart';
import '../theme/sun_theme.dart';

class SunDrawer extends StatelessWidget {
  const SunDrawer({super.key});

  static final List<Map<String, dynamic>> modules = [
    {'icon': Icons.home, 'labelKey': 'home', 'type': ModuleType.home},
    {'icon': Icons.people, 'labelKey': 'hrm', 'type': ModuleType.hrm},
    {
      'icon': Icons.assignment,
      'labelKey': 'project',
      'type': ModuleType.project,
    },
    {
      'icon': Icons.shopping_cart,
      'labelKey': 'purchasing',
      'type': ModuleType.purchasing,
    },
    {'icon': Icons.sell, 'labelKey': 'sales', 'type': ModuleType.sales},
    {
      'icon': Icons.inventory,
      'labelKey': 'inventory',
      'type': ModuleType.inventory,
    },
    {
      'icon': Icons.account_balance,
      'labelKey': 'accounting',
      'type': ModuleType.accounting,
    },
    {
      'icon': Icons.analytics,
      'labelKey': 'reports',
      'type': ModuleType.reports,
    },
    {
      'icon': Icons.settings,
      'labelKey': 'settings',
      'type': ModuleType.settings,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = context.watch<ModuleCubit>().state;
    final localizations = AppLocalizations.of(context)!;
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
                        _getModuleLabel(localizations, m['labelKey'] as String),
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
            // เปลี่ยนภาษาเป็น Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _LanguageDropdown(),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                localizations.logout,
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

// ignore: must_be_immutable
class _LanguageDropdown extends StatefulWidget {
  @override
  State<_LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<_LanguageDropdown> {
  late String _selectedLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    _selectedLang = locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedLang,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(),
      items: [
        DropdownMenuItem(
          value: 'th',
          child: Row(
            children: [
              Image.asset('assets/flags/th.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text('ไทย'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Row(
            children: [
              Image.asset('assets/flags/en.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedLang = val;
          });
          SunErpApp.setLocale(context, Locale(val));
        }
      },
    );
  }
}

// เพิ่มฟังก์ชัน helper สำหรับแปลง labelKey เป็นข้อความจริง
String _getModuleLabel(AppLocalizations loc, String key) {
  switch (key) {
    case 'home':
      return loc.home;
    case 'hrm':
      return loc.hrm;
    case 'project':
      return loc.project;
    case 'purchasing':
      return loc.purchasing;
    case 'sales':
      return loc.sales;
    case 'inventory':
      return loc.inventory;
    case 'accounting':
      return loc.accounting;
    case 'reports':
      return loc.reports;
    case 'settings':
      return loc.settings;
    default:
      return key;
  }
}
