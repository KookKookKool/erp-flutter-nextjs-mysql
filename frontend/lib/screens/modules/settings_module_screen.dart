import 'package:flutter/material.dart';

class SettingsModuleScreen extends StatelessWidget {
  const SettingsModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
