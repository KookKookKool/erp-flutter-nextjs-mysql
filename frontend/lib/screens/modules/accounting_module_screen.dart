import 'package:flutter/material.dart';

class AccountingModuleScreen extends StatelessWidget {
  const AccountingModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Accounting Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
