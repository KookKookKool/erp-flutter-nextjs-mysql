import 'package:flutter/material.dart';
import '../../theme/sun_theme.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: SunTheme.sunGold,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.beach_access, color: SunTheme.sunDeepOrange),
      label: Text(
        'ขอลา',
        style: textTheme.labelLarge?.copyWith(color: SunTheme.sunDeepOrange),
      ),
    );
  }
}
