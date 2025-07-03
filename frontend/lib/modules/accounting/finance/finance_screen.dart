import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountingFinanceModule)),
      body: Center(child: Text(l10n.accountingFinanceContent)),
    );
  }
}
