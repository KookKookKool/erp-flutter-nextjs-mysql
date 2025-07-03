import 'package:flutter/material.dart';

class InventoryModuleScreen extends StatelessWidget {
  const InventoryModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Inventory Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
