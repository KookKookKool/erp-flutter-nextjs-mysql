import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Environment configuration for Flutter app
class Environment {
  // API Configuration - รองรับทั้ง Web และ Mobile/Desktop
  static String get apiUrl {
    if (kIsWeb) {
      // สำหรับ Web ใช้ค่าจาก --dart-define
      return const String.fromEnvironment('DEV_API_URL', defaultValue: '');
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android Emulator ใช้ ANDROID_EMULATOR_API_URL ถ้ามี
      return dotenv.env['ANDROID_EMULATOR_API_URL'] ??
          dotenv.env['DEV_API_URL'] ??
          '';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS ใช้ LOCAL_NETWORK_API_URL ถ้ามี
      return dotenv.env['LOCAL_NETWORK_API_URL'] ??
          dotenv.env['DEV_API_URL'] ??
          '';
    } else {
      // Desktop ใช้ DEV_API_URL
      return dotenv.env['DEV_API_URL'] ?? '';
    }
  }

  // App Configuration
  static const String _prodAppName = 'ERP System';
  static const String _devAppName = 'ERP System (Dev)';

  // Debug Configuration
  static const bool _prodDebugMode = false;
  static const bool _devDebugMode = true;

  // Get current environment from build mode
  static bool get isProduction {
    return const bool.fromEnvironment('dart.vm.product');
  }

  static bool get isDevelopment => !isProduction;
  // App name based on environment
  static String get appName {
    return isProduction ? _prodAppName : _devAppName;
  }

  // Debug mode based on environment
  static bool get debugMode {
    return isProduction ? _prodDebugMode : _devDebugMode;
  }

  // API timeout configuration
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache configuration
  static const Duration cacheTimeout = Duration(minutes: 5);

  // Environment info for debugging (no custom URL override for security)
  static Map<String, dynamic> get info {
    return {
      'environment': isProduction ? 'production' : 'development',
      'apiUrl': apiUrl,
      'appName': appName,
      'debugMode': debugMode,
    };
  }
}
