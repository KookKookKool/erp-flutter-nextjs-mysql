import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/sun_theme.dart';
import '../widgets/sun_app_bar.dart';
import '../widgets/sun_drawer.dart';
import '../widgets/home/employee_card.dart';
import '../widgets/home/attendance_buttons.dart';
import '../widgets/home/leave_button.dart';
import '../widgets/home/task_list.dart';
import '../widgets/home/hr_announcement.dart';
import '../bloc/module_cubit.dart';
import 'modules/hrm_module_screen.dart';
import 'modules/project_module_screen.dart';
import 'modules/purchasing_module_screen.dart';
import 'modules/sales_module_screen.dart';
import 'modules/inventory_module_screen.dart';
import 'modules/accounting_module_screen.dart';
import 'modules/reports_module_screen.dart';
import 'modules/settings_module_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
        return BlocProvider(
          create: (_) => ModuleCubit(),
          child: Scaffold(
            key: scaffoldKey,
            drawer: isDesktop ? null : const SunDrawer(),
            body: Row(
              children: [
                if (isDesktop) const SizedBox(width: 260, child: SunDrawer()),
                Expanded(
                  child: Scaffold(
                    appBar: SunAppBar(
                      isDesktop: isDesktop,
                      onMenuPressed: () =>
                          scaffoldKey.currentState?.openDrawer(),
                    ),
                    body: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: SunTheme.sunGradient,
                      ),
                      child: BlocBuilder<ModuleCubit, ModuleType>(
                        builder: (context, module) {
                          switch (module) {
                            case ModuleType.home:
                              return const _HomeContent();
                            case ModuleType.hrm:
                              return const HRMModuleScreen();
                            case ModuleType.project:
                              return const ProjectModuleScreen();
                            case ModuleType.purchasing:
                              return const PurchasingModuleScreen();
                            case ModuleType.sales:
                              return const SalesModuleScreen();
                            case ModuleType.inventory:
                              return const InventoryModuleScreen();
                            case ModuleType.accounting:
                              return const AccountingModuleScreen();
                            case ModuleType.reports:
                              return const ReportsModuleScreen();
                            case ModuleType.settings:
                              return const SettingsModuleScreen();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
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
