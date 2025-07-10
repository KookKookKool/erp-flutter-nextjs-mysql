import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // เลือก URL ตาม platform
  static String get baseUrl {
    if (kIsWeb) {
      // สำหรับ Web ใช้ localhost
      return 'http://localhost:3000/api';
    } else {
      // สำหรับ Android และอื่นๆ ใช้ localhost
      return 'http://localhost:3000/api';
    }
  }

  // Test connection
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/test'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return {
        'statusCode': response.statusCode,
        'body': {'message': 'Connection successful'},
      };
    } catch (e) {
      print('Connection test failed: $e');
      return {
        'statusCode': 500,
        'body': {'error': 'Connection failed: $e'},
      };
    }
  }

  // Get organization status
  static Future<Map<String, dynamic>> getOrganizationStatus(
    String orgCode,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/org-status/${orgCode.toUpperCase()}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      return {
        'statusCode': response.statusCode,
        'body': json.decode(response.body),
      };
    } catch (e) {
      print('API Error: $e');
      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'},
      };
    }
  }

  // Get all approved organizations
  static Future<Map<String, dynamic>> getOrganizations() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/organizations'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      return {
        'statusCode': response.statusCode,
        'body': json.decode(response.body),
      };
    } catch (e) {
      print('API Error: $e');
      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'},
      };
    }
  }

  // Register new organization
  static Future<Map<String, dynamic>> registerOrganization({
    required String orgName,
    required String orgCode,
    required String orgEmail,
    required String orgPhone,
    required String orgAddress,
    required String orgDescription,
    required String adminName,
    required String adminEmail,
    required String adminPassword,
  }) async {
    try {
      print('Attempting to register with URL: $baseUrl/register');

      final requestBody = {
        'orgName': orgName,
        'orgCode': orgCode.toUpperCase(),
        'orgEmail': orgEmail,
        'orgPhone': orgPhone,
        'orgAddress': orgAddress,
        'orgDescription': orgDescription,
        'adminName': adminName,
        'adminEmail': adminEmail,
        'adminPassword': adminPassword,
      };

      print('Request body: $requestBody');

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return {
        'statusCode': response.statusCode,
        'body': json.decode(response.body),
      };
    } catch (e) {
      print('API Error in registerOrganization: $e');
      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'},
      };
    }
  }

  // Login to organization
  static Future<Map<String, dynamic>> login({
    required String orgCode,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'orgCode': orgCode.toUpperCase(),
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return {
        'statusCode': response.statusCode,
        'body': json.decode(response.body),
      };
    } catch (e) {
      print('API Error: $e');
      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'},
      };
    }
  }
}
