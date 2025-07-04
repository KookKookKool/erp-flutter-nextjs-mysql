import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  final String baseUrl;
  EmployeeService({required this.baseUrl});

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl?action=employee'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return (data['employees'] as List)
            .map((e) => Employee.fromJson(e))
            .toList();
      } else {
        throw Exception('API error: ${data['status']}');
      }
    } else {
      throw Exception('Network error: ${response.statusCode}');
    }
  }
}

class Employee {
  final int id;
  final String username;
  final String email;
  final String createdAt;

  Employee({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
