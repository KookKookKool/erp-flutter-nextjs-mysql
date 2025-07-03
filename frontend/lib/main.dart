import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/sun_theme.dart';
import 'bloc/simple_bloc_observer.dart';
import 'screens/splash_screen.dart';
import 'screens/org_code_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const SunErpApp());
}

class SunErpApp extends StatelessWidget {
  const SunErpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUN ERP',
      debugShowCheckedModeBanner: false,
      theme: SunTheme.themeData,
      home: const SplashScreen(),
      routes: {
        '/org': (context) => const OrgCodeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
