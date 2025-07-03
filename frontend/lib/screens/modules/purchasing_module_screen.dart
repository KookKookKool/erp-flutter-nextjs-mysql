import 'package:flutter/material.dart';

class PurchasingModuleScreen extends StatelessWidget {
  const PurchasingModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Purchasing Module',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
