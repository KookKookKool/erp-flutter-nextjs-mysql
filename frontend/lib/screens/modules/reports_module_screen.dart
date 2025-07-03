import 'package:flutter/material.dart';

class ReportsModuleScreen extends StatelessWidget {
  const ReportsModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Reports Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
