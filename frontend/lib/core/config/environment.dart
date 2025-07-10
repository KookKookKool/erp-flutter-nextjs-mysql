// Environment configuration for Flutter app
class Environment {
  // API Configuration - Fixed for security
  static const String _prodApiUrl = 'https://your-production-domain.com/api';
  static const String _devApiUrl = 'http://localhost:3000/api';

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

  // Fixed API URL based on environment - no custom URL override for security
  static String get apiUrl {
    return isProduction ? _prodApiUrl : _devApiUrl;
  }

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
