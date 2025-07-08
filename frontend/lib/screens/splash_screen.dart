import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/bloc/app_state_cubit.dart';
import 'package:frontend/core/theme/sun_theme.dart';
import 'package:frontend/core/utils/debug_utils.dart';

import '../widgets/sun_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    DebugUtils.logNavigation('Unknown', 'SplashScreen', 'App start');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Safety fallback: force navigate after 10 seconds if nothing happens
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && !_hasNavigated) {
        DebugUtils.logNavigation(
          'SplashScreen',
          'LanguageScreen',
          'Emergency fallback',
        );
        _safeNavigate(AppStatus.language);
      }
    });
  }

  void _safeNavigate(AppStatus status) {
    if (!mounted || _hasNavigated) {
      DebugUtils.logNavigation(
        'SplashScreen',
        'Cancelled',
        'Not mounted or already navigated',
      );
      return;
    }

    // Check if we're still on splash screen
    final route = ModalRoute.of(context);
    if (route?.isCurrent != true) {
      DebugUtils.logNavigation(
        'SplashScreen',
        'Cancelled',
        'Not current route',
      );
      return;
    }

    _hasNavigated = true;
    _controller.stop(); // Stop animation before navigation

    String routeName;
    switch (status) {
      case AppStatus.home:
        routeName = '/home';
        break;
      case AppStatus.org:
        routeName = '/org';
        break;
      case AppStatus.login:
        routeName = '/login';
        break;
      case AppStatus.language:
      default:
        routeName = '/language';
        break;
    }

    DebugUtils.logNavigation(
      'SplashScreen',
      routeName,
      'Status: ${status.toString()}',
    );

    // Use safe navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(routeName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<AppStateCubit, AppState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status != AppStatus.splash,
      listener: (context, state) {
        DebugUtils.logBlocEvent(
          'SplashScreen',
          'BlocListener',
          'state.status = ${state.status}',
        );
        // Add a small delay to ensure smooth transition
        Future.delayed(const Duration(milliseconds: 300), () {
          _safeNavigate(state.status);
        });
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: SunTheme.sunGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _controller,
                child: const SunLogo(size: 120),
              ),
              const SizedBox(height: 32),
              Text(
                'SUN ERP',
                style: textTheme.displayLarge?.copyWith(
                  color: SunTheme.textOnGradient,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Empowering Your Enterprise',
                style: textTheme.bodyLarge?.copyWith(
                  color: SunTheme.textOnGradient.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
