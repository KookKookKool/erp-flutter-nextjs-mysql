import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/main.dart';
import 'package:frontend/core/l10n/app_localizations.dart';
import 'package:frontend/core/bloc/module_cubit.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class SunDrawer extends StatefulWidget {
  const SunDrawer({super.key});

  static final List<Map<String, dynamic>> modules = [
    {'icon': Icons.home, 'labelKey': 'home', 'type': ModuleType.home},
    {
      'icon': Icons.people,
      'labelKey': 'hrm',
      'type': ModuleType.hrm,
      'subs': [
        {'labelKey': 'employeeModule', 'subType': 'employee'},
        {'labelKey': 'attendanceModule', 'subType': 'attendance'},
        {'labelKey': 'payrollModule', 'subType': 'payroll'},
        {'labelKey': 'leaveModule', 'subType': 'leave'},
        {'labelKey': 'leaveApprovalModule', 'subType': 'leaveApproval'},
        {'labelKey': 'announcementModule', 'subType': 'announcement'},
      ],
    },
    {
      'icon': Icons.assignment,
      'labelKey': 'project',
      'type': ModuleType.project,
      'subs': [
        {'labelKey': 'projectTaskModule', 'subType': 'task'},
        {'labelKey': 'projectStatusModule', 'subType': 'status'},
        {'labelKey': 'projectNotificationModule', 'subType': 'notification'},
      ],
    },
    {
      'icon': Icons.sell,
      'labelKey': 'sales',
      'type': ModuleType.sales,
      'subs': [
        {'labelKey': 'salesCustomerModule', 'subType': 'customer'},
        {'labelKey': 'salesQuotationModule', 'subType': 'quotation'},
        {'labelKey': 'salesReportModule', 'subType': 'report'},
      ],
    },
    {
      'icon': Icons.shopping_cart,
      'labelKey': 'purchasing',
      'type': ModuleType.purchasing,
      'subs': [
        {'labelKey': 'purchasingOrderModule', 'subType': 'order'},
        {'labelKey': 'purchasingSupplierModule', 'subType': 'supplier'},
        {'labelKey': 'purchasingReportModule', 'subType': 'report'},
      ],
    },
    {
      'icon': Icons.inventory,
      'labelKey': 'inventory',
      'type': ModuleType.inventory,
      'subs': [
        {'labelKey': 'inventoryProductModule', 'subType': 'product'},
        {'labelKey': 'inventoryStockModule', 'subType': 'stock'},
        {'labelKey': 'inventoryTransactionModule', 'subType': 'transaction'},
      ],
    },
    {
      'icon': Icons.account_balance,
      'labelKey': 'accounting',
      'type': ModuleType.accounting,
      'subs': [
        {'labelKey': 'accountingIncomeModule', 'subType': 'income'},
        {'labelKey': 'accountingFinanceModule', 'subType': 'finance'},
        {'labelKey': 'accountingReportModule', 'subType': 'report'},
      ],
    },
    {
      'icon': Icons.people_alt,
      'labelKey': 'crm',
      'type': ModuleType.crm,
      'subs': [
        {'labelKey': 'crmCustomerModule', 'subType': 'customer'},
        {'labelKey': 'crmHistoryModule', 'subType': 'history'},
        {'labelKey': 'crmActivityModule', 'subType': 'activity'},
      ],
    },
    {
      'icon': Icons.analytics,
      'labelKey': 'reports',
      'type': ModuleType.reports,
      'subs': [
        {'labelKey': 'reportsDashboardModule', 'subType': 'dashboard'},
      ],
    },
    {
      'icon': Icons.settings,
      'labelKey': 'settings',
      'type': ModuleType.settings,
      'subs': [
        {'labelKey': 'settingsUserModule', 'subType': 'user'},
        {'labelKey': 'settingsPermissionModule', 'subType': 'permission'},
        {'labelKey': 'settingsConfigModule', 'subType': 'config'},
        {'labelKey': 'settingsNotificationModule', 'subType': 'notification'},
      ],
    },
  ];

  @override
  State<SunDrawer> createState() => _SunDrawerState();
}

class _SunDrawerState extends State<SunDrawer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = context.watch<ModuleCubit>().state;
    final localizations = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.of(context).size.width >= 900;
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
                  for (final m in SunDrawer.modules)
                    m.containsKey('subs') && isDesktop
                        ? _ControlledExpansionTile(
                            module: m,
                            selected: selected,
                            textTheme: textTheme,
                            localizations: localizations,
                          )
                        : ListTile(
                            leading: Icon(
                              m['icon'] as IconData,
                              color: SunTheme.sunDeepOrange,
                            ),
                            title: Text(
                              _getModuleLabel(
                                localizations,
                                m['labelKey'] as String,
                              ),
                              style: textTheme.bodyLarge,
                            ),
                            selected: selected.module == m['type'],
                            selectedTileColor: SunTheme.sunLight,
                            onTap: () {
                              if (selected.module != m['type']) {
                                context.read<ModuleCubit>().select(
                                  m['type'] as ModuleType,
                                );
                              }
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

// Controlled ExpansionTile for Drawer
class _ControlledExpansionTile extends StatelessWidget {
  final Map<String, dynamic> module;
  final ModuleState selected;
  final TextTheme textTheme;
  final AppLocalizations localizations;
  const _ControlledExpansionTile({
    required this.module,
    required this.selected,
    required this.textTheme,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = selected.module == module['type'];
    return ExpansionTile(
      leading: Icon(module['icon'] as IconData, color: SunTheme.sunDeepOrange),
      title: Text(
        _getModuleLabel(localizations, module['labelKey'] as String),
        style: textTheme.bodyLarge,
      ),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        if (expanded && !isExpanded) {
          context.read<ModuleCubit>().select(module['type'] as ModuleType);
        }
      },
      children: [
        for (final sub in module['subs'])
          ListTile(
            title: Text(
              _getModuleLabel(localizations, sub['labelKey'] as String),
              style: isExpanded && selected.submodule == sub['subType']
                  ? textTheme.bodyLarge?.copyWith(color: SunTheme.sunDeepOrange)
                  : textTheme.bodyLarge,
            ),
            selected: isExpanded && selected.submodule == sub['subType'],
            selectedTileColor: SunTheme.sunLight,
            onTap: () {
              if (!(isExpanded && selected.submodule == sub['subType'])) {
                context.read<ModuleCubit>().select(
                  module['type'] as ModuleType,
                  submodule: sub['subType'],
                );
              }
              Navigator.of(context).maybePop();
            },
          ),
      ],
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
    // submodules
    case 'employeeModule':
      return loc.employeeModule;
    case 'attendanceModule':
      return loc.attendanceModule;
    case 'payrollModule':
      return loc.payrollModule;
    case 'leaveModule':
      return loc.leaveModule;
    case 'leaveApprovalModule':
      return loc.leaveApprovalModule;
    case 'announcementModule':
      return loc.announcementModule;
    case 'projectTaskModule':
      return loc.projectTaskModule;
    case 'projectStatusModule':
      return loc.projectStatusModule;
    case 'projectNotificationModule':
      return loc.projectNotificationModule;
    case 'salesCustomerModule':
      return loc.salesCustomerModule;
    case 'salesQuotationModule':
      return loc.salesQuotationModule;
    case 'salesReportModule':
      return loc.salesReportModule;
    case 'purchasingOrderModule':
      return loc.purchasingOrderModule;
    case 'purchasingSupplierModule':
      return loc.purchasingSupplierModule;
    case 'purchasingReportModule':
      return loc.purchasingReportModule;
    case 'inventoryProductModule':
      return loc.inventoryProductModule;
    case 'inventoryStockModule':
      return loc.inventoryStockModule;
    case 'inventoryTransactionModule':
      return loc.inventoryTransactionModule;
    case 'accountingIncomeModule':
      return loc.accountingIncomeModule;
    case 'accountingFinanceModule':
      return loc.accountingFinanceModule;
    case 'accountingReportModule':
      return loc.accountingReportModule;
    case 'crmCustomerModule':
      return loc.crmCustomerModule;
    case 'crmHistoryModule':
      return loc.crmHistoryModule;
    case 'crmActivityModule':
      return loc.crmActivityModule;
    case 'reportsDashboardModule':
      return loc.reportsDashboardModule;
    case 'settingsUserModule':
      return loc.settingsUserModule;
    case 'settingsPermissionModule':
      return loc.settingsPermissionModule;
    case 'settingsConfigModule':
      return loc.settingsConfigModule;
    case 'settingsNotificationModule':
      return loc.settingsNotificationModule;
    default:
      return key;
  }
}
