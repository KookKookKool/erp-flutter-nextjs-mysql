import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/core/auth/models/employee_model.dart';

class EmployeeAuthService {
  final String baseUrl;

  EmployeeAuthService({required this.baseUrl});

  Future<Map<String, dynamic>> loginWithEmployeeId({
    required String orgCode,
    required String employeeId,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/employee-login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'orgCode': orgCode,
          'employeeId': employeeId,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchEmployeeProfile({
    required String orgCode,
    required String employeeId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hrm/employee/profile?employeeId=$employeeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
        },
      );

      final data = json.decode(response.body);

      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Employee>> fetchEmployees({
    required String orgCode,
    required String token,
    String? searchQuery,
    String? department,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (department != null && department.isNotEmpty) {
        queryParams['department'] = department;
      }
      if (isActive != null) {
        queryParams['isActive'] = isActive.toString();
      }

      final uri = Uri.parse(
        '$baseUrl/hrm/employee',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
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

  Future<Map<String, dynamic>> createEmployee({
    required String orgCode,
    required String token,
    required Map<String, dynamic> employeeData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hrm/employee'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
        },
        body: json.encode(employeeData),
      );

      final data = json.decode(response.body);

      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> updateEmployee({
    required String orgCode,
    required String token,
    required String employeeId,
    required Map<String, dynamic> employeeData,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/hrm/employee/$employeeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
        },
        body: json.encode(employeeData),
      );

      final data = json.decode(response.body);

      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> deleteEmployee({
    required String orgCode,
    required String token,
    required String employeeId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/hrm/employee/$employeeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Org-Code': orgCode,
        },
      );

      final data = json.decode(response.body);

      return {'statusCode': response.statusCode, 'body': data};
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
