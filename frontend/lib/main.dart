import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/sun_theme.dart';
import 'core/bloc/module_cubit.dart';
import 'core/bloc/simple_bloc_observer.dart';
import 'core/bloc/app_state_cubit.dart';
import 'modules/hrm/leave/leave_repository.dart';
import 'modules/hrm/leave/bloc/leave_cubit.dart';
import 'modules/hrm/announcement/announcement_repository.dart';
import 'modules/hrm/announcement/bloc/announcement_cubit.dart';
import 'screens/splash_screen.dart';
import 'screens/org_code_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_select_screen.dart';

// Global repository instances
final globalLeaveRepository = LeaveRepository();
final globalAnnouncementRepository = AnnouncementRepository();

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ModuleCubit>(create: (_) => ModuleCubit()),
        BlocProvider<AppStateCubit>(create: (_) => AppStateCubit()),
        BlocProvider<LeaveCubit>(
          create: (_) => LeaveCubit(globalLeaveRepository),
        ),
        BlocProvider<AnnouncementCubit>(
          create: (_) => AnnouncementCubit(globalAnnouncementRepository),
        ),
      ],
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
    if (_locale != locale) {
      setState(() {
        _locale = locale;
      });
    }
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
      // Add builder to handle media query changes gracefully
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Prevent text scaling issues on different devices
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
