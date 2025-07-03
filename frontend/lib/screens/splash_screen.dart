import 'package:flutter/material.dart';
import '../theme/sun_theme.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/language');
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
    return Scaffold(
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
                color: SunTheme.textOnGradient.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
