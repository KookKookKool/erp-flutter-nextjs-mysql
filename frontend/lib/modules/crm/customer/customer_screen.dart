import 'package:flutter/material.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.crmCustomerModule)),
      body: Center(child: Text(l10n.crmCustomerContent)),
    );
  }
}
