import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeService {
  final String baseUrl;
  EmployeeService({required this.baseUrl});

  Future<List<Employee>> fetchEmployees() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final orgCode = prefs.getString('org_code');

      if (token == null || orgCode == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/hrm/employees'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
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
          throw Exception('API error: ${data['message']}');
        }
      } else {
        throw Exception('Network error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
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
        throw Exception('Authentication required');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/hrm/employees'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
          'Content-Type': 'application/json',
        },
        body: json.encode(employeeData),
      );

      final data = json.decode(response.body);
      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Failed to create employee: $e');
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
        throw Exception('Authentication required');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/hrm/employees/$employeeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
          'Content-Type': 'application/json',
        },
        body: json.encode(employeeData),
      );

      final data = json.decode(response.body);
      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  Future<Map<String, dynamic>> deleteEmployee(String employeeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final orgCode = prefs.getString('org_code');

      if (token == null || orgCode == null) {
        throw Exception('Authentication required');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/hrm/employees/$employeeId'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
          'Content-Type': 'application/json',
        },
      );

      final data = json.decode(response.body);
      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }
}

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
      isActive: json['is_active'] ?? true,
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
