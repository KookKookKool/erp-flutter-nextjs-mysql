import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/sun_theme.dart';
import 'bloc/module_cubit.dart';
import 'core/bloc/simple_bloc_observer.dart';
import 'screens/splash_screen.dart';
import 'screens/org_code_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_select_screen.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider<ModuleCubit>(
      create: (_) => ModuleCubit(),
      child: const SunErpApp(),
    ),
  );
}

class SunErpApp extends StatefulWidget {
  const SunErpApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _SunErpAppState? state = context
        .findAncestorStateOfType<_SunErpAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<SunErpApp> createState() => _SunErpAppState();
}

class _SunErpAppState extends State<SunErpApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUN ERP',
      debugShowCheckedModeBanner: false,
      theme: SunTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/language': (context) => const LanguageSelectScreen(),
        '/org': (context) => const OrgCodeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
