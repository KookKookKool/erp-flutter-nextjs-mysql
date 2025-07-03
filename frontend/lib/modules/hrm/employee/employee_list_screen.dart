import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.employeeListTitle ?? 'Employee List')),
      body: Center(
        child: Text(l10n.employeeListContent ?? 'Employee list content here'),
      ),
    );
  }
}
