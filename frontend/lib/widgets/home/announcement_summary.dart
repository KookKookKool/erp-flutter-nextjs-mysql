import 'package:flutter/material.dart';

class AnnouncementSummary extends StatelessWidget {
  const AnnouncementSummary({super.key});

  @override
  Widget build(BuildContext context) {
    // ลบ summary cards ออกตามที่ขอ - ไม่แสดงปุ่มสำคัญมาก ปานกลาง ทั่วไป
    return const SizedBox.shrink();
  }
}
