import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/bloc/app_state_cubit.dart';
import 'package:frontend/core/theme/sun_theme.dart';

import '../widgets/sun_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _navigate(AppStatus status) {
    if (!mounted) return;
    switch (status) {
      case AppStatus.home:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case AppStatus.org:
        Navigator.of(context).pushReplacementNamed('/org');
        break;
      case AppStatus.login:
        Navigator.of(context).pushReplacementNamed('/login');
        break;
      case AppStatus.language:
      default:
        Navigator.of(context).pushReplacementNamed('/language');
        break;
    }
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
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        print('[SplashScreen] BlocListener: state.status = \\${state.status}');
        Future.delayed(const Duration(milliseconds: 500), () {
          _navigate(state.status);
        });
        // Fallback: ถ้า 5 วินาทีแล้วยังไม่ navigate ให้ไปหน้า language
        Future.delayed(const Duration(seconds: 5), () {
          final route = ModalRoute.of(context);
          if (mounted && (route?.isCurrent ?? false)) {
            print('[SplashScreen] Fallback: force navigate to /language');
            _navigate(AppStatus.language);
          }
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
