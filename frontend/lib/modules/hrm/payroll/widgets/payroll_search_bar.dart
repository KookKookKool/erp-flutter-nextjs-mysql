import 'package:flutter/material.dart';
import 'package:frontend/core/theme/sun_theme.dart';

class PayrollSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const PayrollSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: SunTheme.sunSearchBoxDecoration,
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          prefixIcon: Icon(Icons.search, color: SunTheme.textSecondary),
          hintText: 'ค้นหาพนักงาน (ชื่อ หรือ รหัสพนักงาน)',
          hintStyle: TextStyle(color: SunTheme.textSecondary, fontSize: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: onChanged,
      ),
    );
  }
}
