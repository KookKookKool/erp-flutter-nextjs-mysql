import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ต้องติดตั้ง image_picker ใน pubspec.yaml
import '../../../l10n/app_localizations.dart';

class Employee {
  File? image;
  String firstName;
  String lastName;
  String employeeId;
  String level; // เดิม position
  String position; // เดิม department
  String email;
  String phone;
  String startDate;
  String password;
  Employee({
    this.image,
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.level,
    required this.position,
    required this.email,
    required this.phone,
    required this.startDate,
    required this.password,
  });
}

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final List<Employee> employees = [
    Employee(
      firstName: 'สมชาย',
      lastName: 'ใจดี',
      employeeId: 'EMP001',
      level: 'Manager',
      position: 'HR',
      email: 'somchai@example.com',
      phone: '0812345678',
      startDate: '2023-01-01',
      password: 'password123',
    ),
  ];
  String _search = '';

  List<Employee> get _filteredEmployees {
    if (_search.isEmpty) return employees;
    return employees.where((e) =>
      e.firstName.contains(_search) ||
      e.lastName.contains(_search) ||
      e.employeeId.contains(_search)
    ).toList();
  }

  void _addOrEditEmployee({Employee? employee, int? index}) async {
    final result = await showDialog<Employee>(
      context: context,
      builder: (context) => EmployeeDialog(employee: employee),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          employees[index] = result;
        } else {
          employees.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.employeeListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'เพิ่มพนักงาน',
            onPressed: () => _addOrEditEmployee(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ค้นหาชื่อหรือรหัสพนักงาน',
              ),
              onChanged: (v) => setState(() => _search = v.trim()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredEmployees.length,
              itemBuilder: (context, i) {
                final emp = _filteredEmployees[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: emp.image != null
                        ? CircleAvatar(backgroundImage: FileImage(emp.image!))
                        : const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('${emp.firstName} ${emp.lastName}'),
                    subtitle: Text(emp.position),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _addOrEditEmployee(employee: emp, index: employees.indexOf(emp)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeDialog extends StatefulWidget {
  final Employee? employee;
  const EmployeeDialog({this.employee, super.key});
  @override
  State<EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<EmployeeDialog> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _employeeId;
  String _level = 'Junior';
  late TextEditingController _position;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _startDate;
  late TextEditingController _password;
  bool _obscurePassword = true;

  final List<String> _levels = ['Junior', 'Senior', 'Manager', 'Director'];

  @override
  void initState() {
    final emp = widget.employee;
    _image = emp?.image;
    _firstName = TextEditingController(text: emp?.firstName ?? '');
    _lastName = TextEditingController(text: emp?.lastName ?? '');
    _employeeId = TextEditingController(text: emp?.employeeId ?? '');
    _level = emp?.level ?? 'Junior';
    _position = TextEditingController(text: emp?.position ?? '');
    _email = TextEditingController(text: emp?.email ?? '');
    _phone = TextEditingController(text: emp?.phone ?? '');
    _startDate = TextEditingController(text: emp?.startDate ?? '');
    _password = TextEditingController(text: emp?.password ?? '');
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.employee == null ? 'เพิ่มพนักงาน' : 'แก้ไขข้อมูลพนักงาน',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _image != null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(_image!),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 40,
                        child: const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstName,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              TextFormField(
                controller: _lastName,
                decoration: const InputDecoration(labelText: 'นามสกุล'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'กรุณากรอกนามสกุล' : null,
              ),
              TextFormField(
                controller: _employeeId,
                decoration: const InputDecoration(labelText: 'รหัสพนักงาน'),
              ),
              DropdownButtonFormField<String>(
                value: _level,
                items: _levels
                    .map((lv) => DropdownMenuItem(
                          value: lv,
                          child: Text(lv),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _level = val);
                },
                decoration: const InputDecoration(labelText: 'ระดับ'),
              ),
              TextFormField(
                controller: _position,
                decoration: const InputDecoration(labelText: 'ตำแหน่ง'),
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'อีเมล'),
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'เบอร์โทร'),
              ),
              TextFormField(
                controller: _startDate,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'วันที่เริ่มงาน'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate.text.isNotEmpty ? DateTime.tryParse(_startDate.text) ?? DateTime.now() : DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _startDate.text = picked.toIso8601String().split('T').first;
                  }
                },
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                Employee(
                  image: _image,
                  firstName: _firstName.text,
                  lastName: _lastName.text,
                  employeeId: _employeeId.text,
                  level: _level,
                  position: _position.text,
                  email: _email.text,
                  phone: _phone.text,
                  startDate: _startDate.text,
                  password: _password.text,
                ),
              );
            }
          },
          child: const Text('บันทึก'),
        ),
      ],
    );
  }
}
