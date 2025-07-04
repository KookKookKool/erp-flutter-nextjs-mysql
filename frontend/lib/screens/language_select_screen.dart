import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/core/l10n/app_localizations.dart';

class LanguageSelectScreen extends StatelessWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.selectLanguage,
                style: textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/flags/th.png',
                      width: 32,
                      height: 32,
                    ),
                    label: Text('ไทย', style: textTheme.titleLarge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      SunErpApp.setLocale(context, const Locale('th'));
                      Navigator.of(context).pushReplacementNamed('/org');
                    },
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/flags/en.png',
                      width: 32,
                      height: 32,
                    ),
                    label: Text('English', style: textTheme.titleLarge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      SunErpApp.setLocale(context, const Locale('en'));
                      Navigator.of(context).pushReplacementNamed('/org');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
