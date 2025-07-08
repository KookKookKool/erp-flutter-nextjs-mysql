import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/sun_theme.dart';
import '../widgets/sun_app_bar.dart';
import '../widgets/sun_drawer.dart';
import '../widgets/home/employee_card.dart';
import '../widgets/home/attendance_buttons.dart';
import '../widgets/home/leave_button.dart';
import '../widgets/home/task_list.dart';
import '../widgets/home/hr_announcement.dart';
import '../widgets/home/urgent_announcement_banner.dart';
import '../core/bloc/module_cubit.dart';
import '../modules/hrm/hrm_module_screen.dart';
import '../modules/crm/crm_module_screen.dart';
import '../modules/project/project_module_screen.dart';
import '../modules/purchasing/purchasing_module_screen.dart';
import '../modules/sales/sales_module_screen.dart';
import '../modules/inventory/inventory_module_screen.dart';
import '../modules/accounting/accounting_module_screen.dart';
import '../modules/reports/reports_module_screen.dart';
import '../modules/settings/settings_module_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        return Scaffold(
          key: scaffoldKey,
          drawer: isDesktop ? null : SunDrawer(),
          appBar: SunAppBar(
            isDesktop: isDesktop,
            onMenuPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          body: Row(
            children: [
              if (isDesktop) SizedBox(width: 260, child: SunDrawer()),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: SunTheme.sunGradient,
                  ),
                  child: BlocBuilder<ModuleCubit, ModuleState>(
                    builder: (context, state) {
                      switch (state.module) {
                        case ModuleType.home:
                          return _HomeContent();
                        case ModuleType.hrm:
                          return HRMModuleScreen(submodule: state.submodule);
                        case ModuleType.project:
                          return ProjectModuleScreen(
                            submodule: state.submodule,
                          );
                        case ModuleType.purchasing:
                          return PurchasingModuleScreen(
                            submodule: state.submodule,
                          );
                        case ModuleType.sales:
                          return SalesModuleScreen(submodule: state.submodule);
                        case ModuleType.inventory:
                          return InventoryModuleScreen(
                            submodule: state.submodule,
                          );
                        case ModuleType.accounting:
                          return AccountingModuleScreen(
                            submodule: state.submodule,
                          );
                        case ModuleType.reports:
                          return ReportsModuleScreen(
                            submodule: state.submodule,
                          );
                        case ModuleType.settings:
                          return SettingsModuleScreen(
                            submodule: state.submodule,
                          );
                        case ModuleType.crm:
                          return CrmModuleScreen(submodule: state.submodule);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UrgentAnnouncementBanner(),
            EmployeeCard(),
            SizedBox(height: 24),
            AttendanceButtons(),
            SizedBox(height: 24),
            LeaveButton(),
            SizedBox(height: 24),
            TaskList(),
            SizedBox(height: 24),
            HrAnnouncement(),
          ],
        ),
      ),
    );
  }
}
