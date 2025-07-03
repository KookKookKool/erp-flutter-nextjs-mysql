import 'package:flutter/material.dart';
import '../../theme/sun_theme.dart';

class AttendanceButtons extends StatelessWidget {
  const AttendanceButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.sunOrange,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text(
            'ลงเวลาเข้า',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: SunTheme.sunDeepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text('ลงเวลาออก', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
