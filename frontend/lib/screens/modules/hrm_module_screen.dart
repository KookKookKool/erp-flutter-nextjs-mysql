import 'package:flutter/material.dart';

class HRMModuleScreen extends StatelessWidget {
  const HRMModuleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'HRM Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
