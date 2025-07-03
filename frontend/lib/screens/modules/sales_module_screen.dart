import 'package:flutter/material.dart';

class SalesModuleScreen extends StatelessWidget {
  const SalesModuleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sales Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
