class ApiConfig {
  // Environment-based configuration
  // Different development URLs based on platform and environment
  // - localhost: Only works on web or desktop apps
  // - 10.0.2.2: Special IP for Android emulator to access host machine's localhost
  // - Your actual IP (like 192.168.10.123): Use for physical devices on same network
  
  // Uncomment the appropriate URL for your testing environment:
  // static const String _devBaseUrl = 'http://localhost:3000/api';  // For web/desktop
  static const String _devBaseUrl = 'http://192.168.10.123:3000/api';  // For physical devices
  // static const String _devBaseUrl = 'http://10.0.2.2:3000/api';  // For Android emulator
  static const String _prodBaseUrl = 'https://your-production-api.com/api';
  
  // Current environment (change this based on your build configuration)
  static const bool _isDevelopment = true;
  
  // Base URL getter
  static String get baseUrl => _isDevelopment ? _devBaseUrl : _prodBaseUrl;
  
  // API endpoints
  static const String authEndpoint = '/auth';
  static const String receiptsEndpoint = '/receipts';
  static const String categoriesEndpoint = '/categories';
  static const String usersEndpoint = '/users';
  
  // Request timeouts
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  
  // Common headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Accept-Encoding': 'gzip, deflate, br',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
  };
}