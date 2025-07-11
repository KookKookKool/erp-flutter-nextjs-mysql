import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/environment.dart';

class ApiService {
  // ใช้ Environment configuration แบบ fixed สำหรับความปลอดภัย
  static String get baseUrl {
    final apiUrl = Environment.apiUrl;
    if (apiUrl.isEmpty) {
      throw Exception(
        'API base URL is not set. Please check your environment configuration.',
      );
    }
    if (kIsWeb) {
      return apiUrl;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android Emulator: ถ้า apiUrl เป็น localhost ให้ใช้ 10.0.2.2
      if (apiUrl.contains('localhost')) {
        return apiUrl.replaceAll('localhost', '10.0.2.2');
      }
      return apiUrl;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS Simulator: ใช้ IP เครื่องจริง
      return apiUrl;
    } else {
      // Desktop หรือ platform อื่น ๆ
      return apiUrl;
    }
  }

  // Log API calls in debug mode
  static void _logApiCall(
    String method,
    String url, {
    Map<String, dynamic>? body,
  }) {
    if (Environment.debugMode) {
      print('🌐 API $method: $url');
      if (body != null) {
        print('📤 Body: ${json.encode(body)}');
      }
    }
  }

  static void _logApiResponse(String url, int statusCode, dynamic body) {
    if (Environment.debugMode) {
      print('📥 Response from $url: $statusCode');
      if (statusCode >= 400) {
        print('❌ Error: $body');
      }
    }
  }

  // Get organization status
  static Future<Map<String, dynamic>> getOrganizationStatus(
    String orgCode,
  ) async {
    final url = '/org-status/${orgCode.toUpperCase()}';
    _logApiCall('GET', '$baseUrl$url');

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$url'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Environment.apiTimeout);

      final responseBody = json.decode(response.body);
      _logApiResponse('$baseUrl$url', response.statusCode, responseBody);

      return {'statusCode': response.statusCode, 'body': responseBody};
    } catch (e) {
      _logApiResponse('$baseUrl$url', 500, 'API Error: $e');

      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'},
      };
    }
  }

  // Get all approved organizations
  static Future<Map<String, dynamic>> getOrganizations() async {
    const url = '/organizations';
    _logApiCall('GET', '$baseUrl$url');

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$url'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Environment.apiTimeout);

      final responseBody = json.decode(response.body);
      _logApiResponse('$baseUrl$url', response.statusCode, responseBody);

      return {'statusCode': response.statusCode, 'body': responseBody};
    } catch (e) {
      _logApiResponse('$baseUrl$url', 500, 'API Error: $e');

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
    required String companyRegistrationNumber,
    required String taxId,
    required String businessType, // เพิ่ม
    required String employeeCount, // เพิ่ม
    required String website, // เพิ่ม
    required String adminName,
    required String adminEmail,
    required String adminPassword,
  }) async {
    const url = '/register';

    final requestBody = {
      'orgName': orgName,
      'orgCode': orgCode.toUpperCase(),
      'orgEmail': orgEmail,
      'orgPhone': orgPhone,
      'orgAddress': orgAddress,
      'orgDescription': orgDescription,
      'companyRegistrationNumber': companyRegistrationNumber,
      'taxId': taxId,
      'businessType': businessType, // เพิ่ม
      'employeeCount': employeeCount, // เพิ่ม
      'website': website, // เพิ่ม
      'adminName': adminName,
      'adminEmail': adminEmail,
      'adminPassword': adminPassword,
    };

    _logApiCall('POST', '$baseUrl$url', body: requestBody);

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$url'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(Environment.apiTimeout);

      final responseBody = json.decode(response.body);
      _logApiResponse('$baseUrl$url', response.statusCode, responseBody);

      return {'statusCode': response.statusCode, 'body': responseBody};
    } catch (e) {
      _logApiResponse('$baseUrl$url', 500, 'API Error: $e');

      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการสมัครสมาชิก: $e'},
      };
    }
  }

  // Login to organization
  static Future<Map<String, dynamic>> login({
    required String orgCode,
    required String email,
    required String password,
  }) async {
    const url = '/login';

    final requestBody = {
      'orgCode': orgCode.toUpperCase(),
      'email': email,
      'password': password,
    };

    _logApiCall('POST', '$baseUrl$url', body: requestBody);

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$url'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(Environment.apiTimeout);

      final responseBody = json.decode(response.body);
      _logApiResponse('$baseUrl$url', response.statusCode, responseBody);

      return {'statusCode': response.statusCode, 'body': responseBody};
    } catch (e) {
      _logApiResponse('$baseUrl$url', 500, 'API Error: $e');

      return {
        'statusCode': 500,
        'body': {'error': 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ: $e'},
      };
    }
  }

  // Get API base URL for debugging
  static String getApiBaseUrl() {
    return baseUrl;
  }

  // Get environment info
  static Map<String, dynamic> getEnvironmentInfo() {
    return {...Environment.info, 'currentBaseUrl': baseUrl};
  }
}
