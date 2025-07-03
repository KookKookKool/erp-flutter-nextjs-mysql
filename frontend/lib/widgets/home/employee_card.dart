import 'package:flutter/material.dart';
import '../../theme/sun_theme.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: SunTheme.sunGold,
              child: Icon(
                Icons.person,
                size: 40,
                color: SunTheme.sunDeepOrange,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ชื่อพนักงาน',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('ตำแหน่งงาน', style: textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text('รหัสพนักงาน: EMP001', style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
