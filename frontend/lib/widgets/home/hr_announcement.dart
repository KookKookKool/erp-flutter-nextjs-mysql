import 'package:flutter/material.dart';
import '../../theme/sun_theme.dart';

class HrAnnouncement extends StatelessWidget {
  const HrAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ประกาศจาก HR',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.announcement,
              color: SunTheme.sunDeepOrange,
            ),
            title: const Text('แจ้งวันหยุดประจำปี'),
            subtitle: const Text('บริษัทจะหยุดทำการวันที่ 12-15 เมษายน'),
          ),
        ),
      ],
    );
  }
}
