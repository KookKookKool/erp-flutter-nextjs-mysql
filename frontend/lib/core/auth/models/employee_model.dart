import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/auth/bloc/employee_auth_cubit.dart';
import 'package:frontend/widgets/home/employee_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocBuilder<EmployeeAuthCubit, EmployeeAuthState>(
        builder: (context, state) {
          if (state is EmployeeProfileLoaded) {
            return EmployeeCard(employee: state.employee);
          } else if (state is EmployeeAuthSuccess) {
            return EmployeeCard(
              employee: state.loginResponse.employee,
              permissions: state.loginResponse.permissions,
            );
          } else if (state is EmployeeAuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeAuthError) {
            return Center(child: Text(state.message));
          } else {
            return EmployeeCard(employee: EmployeeCard.mock());
          }
        },
      ),
    );
  }
}

// วิธีใช้งานที่ถูกต้องในหน้า HomeScreen (หรือหน้าที่ต้องการแสดง EmployeeCard)
// ให้ใช้ BlocBuilder เพื่อดึงข้อมูล employee จาก Bloc แล้วส่งไปยัง EmployeeCard
// ตัวอย่าง:
// BlocBuilder<EmployeeAuthCubit, EmployeeAuthState>(
//   builder: (context, state) {
//     if (state is EmployeeProfileLoaded) {
//       return EmployeeCard(employee: state.employee);
//     } else if (state is EmployeeAuthSuccess) {
//       return EmployeeCard(employee: state.loginResponse.employee, permissions: state.loginResponse.permissions);
//     } else if (state is EmployeeAuthLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else if (state is EmployeeAuthError) {
//       return Center(child: Text(state.message));
//     } else {
//       return EmployeeCard(employee: EmployeeCard.mock());
//     }
//   },
// )

class Employee {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String level;
  final DateTime startDate;
  final bool isActive;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Employee({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.level,
    required this.startDate,
    required this.isActive,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> json) {
    // Fix is_active: handle int or bool
    final isActiveRaw = json['is_active'];
    bool isActive;
    if (isActiveRaw is bool) {
      isActive = isActiveRaw;
    } else if (isActiveRaw is int) {
      isActive = isActiveRaw == 1;
    } else {
      isActive = true;
    }
    return Employee(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position'] ?? '',
      department: json['department'] ?? '',
      level: json['level'] ?? '',
      startDate: DateTime.parse(
        json['start_date'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: isActive,
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'position': position,
      'department': department,
      'level': level,
      'start_date': startDate.toIso8601String(),
      'is_active': isActive,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class EmployeeLoginResponse {
  final String token;
  final Employee employee;
  final Map<String, dynamic> organization;
  final Map<String, dynamic> permissions;

  EmployeeLoginResponse({
    required this.token,
    required this.employee,
    required this.organization,
    required this.permissions,
  });

  factory EmployeeLoginResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeLoginResponse(
      token: json['token'] ?? '',
      employee: Employee.fromJson(json['employee'] ?? {}),
      organization: json['organization'] ?? {},
      permissions: json['permissions'] ?? {},
    );
  }
}
