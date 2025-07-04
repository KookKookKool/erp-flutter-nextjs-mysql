import 'package:flutter/material.dart';

class EmployeeFormFields extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController employeeId;
  final String level;
  final ValueChanged<String?> onLevelChanged;
  final List<String> levels;
  final TextEditingController position;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController startDate;
  final VoidCallback onPickDate;
  final TextEditingController password;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const EmployeeFormFields({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.level,
    required this.onLevelChanged,
    required this.levels,
    required this.position,
    required this.email,
    required this.phone,
    required this.startDate,
    required this.onPickDate,
    required this.password,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: firstName,
          decoration: const InputDecoration(labelText: 'ชื่อ'),
          validator: (v) => v == null || v.isEmpty ? 'กรุณากรอกชื่อ' : null,
        ),
        TextFormField(
          controller: lastName,
          decoration: const InputDecoration(labelText: 'นามสกุล'),
          validator: (v) => v == null || v.isEmpty ? 'กรุณากรอกนามสกุล' : null,
        ),
        TextFormField(
          controller: employeeId,
          decoration: const InputDecoration(labelText: 'รหัสพนักงาน'),
        ),
        DropdownButtonFormField<String>(
          value: level,
          items: levels
              .map((lv) => DropdownMenuItem(value: lv, child: Text(lv)))
              .toList(),
          onChanged: onLevelChanged,
          decoration: const InputDecoration(labelText: 'ระดับ'),
        ),
        TextFormField(
          controller: position,
          decoration: const InputDecoration(labelText: 'ตำแหน่ง'),
        ),
        TextFormField(
          controller: email,
          decoration: const InputDecoration(labelText: 'อีเมล'),
        ),
        TextFormField(
          controller: phone,
          decoration: const InputDecoration(labelText: 'เบอร์โทร'),
        ),
        TextFormField(
          controller: startDate,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'วันที่เริ่มงาน'),
          onTap: onPickDate,
        ),
        TextFormField(
          controller: password,
          decoration: InputDecoration(
            labelText: 'รหัสผ่าน',
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onTogglePassword,
            ),
          ),
          obscureText: obscurePassword,
        ),
      ],
    );
  }
}
