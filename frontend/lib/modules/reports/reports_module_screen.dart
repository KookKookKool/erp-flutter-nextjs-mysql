import 'package:flutter/material.dart';
import 'package:frontend/modules/reports/dashboard/dashboard_screen.dart';

class ReportsModuleScreen extends StatelessWidget {
  final String? submodule;
  const ReportsModuleScreen({super.key, this.submodule});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return isDesktop
        ? _ReportsDesktopView(submodule: submodule)
        : _ReportsMobileView();
  }
}

class _ReportsDesktopView extends StatelessWidget {
  final String? submodule;
  const _ReportsDesktopView({this.submodule});
  @override
  Widget build(BuildContext context) {
    // มีแค่ dashboard เป็น default
    return DashboardScreen();
  }
}

class _ReportsMobileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardScreen();
  }
}
