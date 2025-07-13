// ...existing imports...

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/config/environment.dart';

/// คลาสสำหรับส่ง Employee พร้อม password (top-level)
class EmployeeWithPassword {
  final Employee employee;
  final String password;
  EmployeeWithPassword({required this.employee, required this.password});
}

class EmployeeService {
  String get baseUrl {
    final apiUrl = Environment.apiUrl;
    if (apiUrl.isEmpty) {
      throw Exception(
        'API base URL is not set. Please check your environment configuration.',
      );
    }
    if (kIsWeb) {
      return apiUrl;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      if (apiUrl.contains('localhost')) {
        return apiUrl.replaceAll('localhost', '10.0.2.2');
      }
      return apiUrl;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return apiUrl;
    } else {
      return apiUrl;
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final orgCode = prefs.getString('org_code');
      if (token == null || orgCode == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อน');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/hrm/employees'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-org-code': orgCode,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return (data['employees'] as List)
              .map((e) => Employee.fromJson(e))
              .toList();
        } else {
          throw Exception(
            'เกิดข้อผิดพลาด: ${data['message'] ?? 'ไม่สามารถดึงข้อมูล'}',
          );
        }
      } else {
        throw Exception('เกิดข้อผิดพลาดเครือข่าย (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('ดึงข้อมูลพนักงานไม่สำเร็จ: $e');
    }
  }

  Future<Map<String, dynamic>> createEmployee(
    Map<String, dynamic> employeeData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final orgCode = prefs.getString('org_code');
      if (token == null || orgCode == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อน');
      }
      final response = await http.post(
        Uri.parse('$baseUrl/hrm/employees'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-org-code': orgCode,
          'Content-Type': 'application/json',
        },
        body: json.encode(employeeData),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'statusCode': response.statusCode, 'body': data};
      } else {
        throw Exception(
          'เพิ่มพนักงานไม่สำเร็จ: ${data['error'] ?? 'ไม่ทราบสาเหตุ'}',
        );
      }
    } catch (e) {
      throw Exception('เพิ่มพนักงานไม่สำเร็จ: $e');
    }
  }

  Future<Map<String, dynamic>> updateEmployee(
    String employeeId,
    Map<String, dynamic> employeeData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final orgCode = prefs.getString('org_code');
      if (token == null || orgCode == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อน');
      }
      final response = await http.put(
        Uri.parse('$baseUrl/hrm/employees?id=$employeeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-org-code': orgCode,
          'Content-Type': 'application/json',
        },
        body: json.encode(employeeData),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'statusCode': response.statusCode, 'body': data};
      } else {
        throw Exception(
          'แก้ไขข้อมูลพนักงานไม่สำเร็จ: ${data['error'] ?? 'ไม่ทราบสาเหตุ'}',
        );
      }
    } catch (e) {
      throw Exception('แก้ไขข้อมูลพนักงานไม่สำเร็จ: $e');
    }
  }

  Future<Map<String, dynamic>> deleteEmployee(String employeeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final orgCode = prefs.getString('org_code');
      if (token == null || orgCode == null) {
        throw Exception('กรุณาเข้าสู่ระบบก่อน');
      }
      final response = await http.delete(
        Uri.parse('$baseUrl/hrm/employees?id=$employeeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'x-org-code': orgCode,
          'Content-Type': 'application/json',
        },
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {'statusCode': response.statusCode, 'body': data};
      } else {
        throw Exception(
          'ลบพนักงานไม่สำเร็จ: ${data['error'] ?? 'ไม่ทราบสาเหตุ'}',
        );
      }
    } catch (e) {
      throw Exception('ลบพนักงานไม่สำเร็จ: $e');
    }
  }
}

/// Model ข้อมูลพนักงาน รองรับข้อมูลจาก backend ได้ครบถ้วน
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
  final DateTime? startDate;
  final bool isActive;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.startDate,
    required this.isActive,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  /// สร้าง Employee จาก json (ตรวจสอบและแปลงวันที่ให้ปลอดภัย)
  factory Employee.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return Employee(
      id: json['id']?.toString() ?? '',
      employeeId: json['employee_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      position: json['position']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      startDate: parseDate(json['start_date']),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      profileImage: json['profile_image']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  /// แปลง Employee เป็น json สำหรับส่งไป backend
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
      'start_date': startDate?.toIso8601String(),
      'is_active': isActive,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
