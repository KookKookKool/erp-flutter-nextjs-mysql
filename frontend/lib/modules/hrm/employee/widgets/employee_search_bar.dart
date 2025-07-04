import 'package:flutter/material.dart';

class EmployeeSearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const EmployeeSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'ค้นหาชื่อหรือรหัสพนักงาน',
        ),
        onChanged: (v) => onChanged(v.trim()),
      ),
    );
  }
}
