import 'package:flutter/material.dart';
import '../theme/sun_theme.dart';

class SunLogo extends StatelessWidget {
  final double size;
  const SunLogo({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SunTheme.sunGradient,
        boxShadow: [
          BoxShadow(
            color: SunTheme.sunDeepOrange.withOpacity(0.3),
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.wb_sunny,
          color: SunTheme.sunDeepOrange,
          size: size * 0.6,
        ),
      ),
    );
  }
}
