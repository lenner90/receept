class ApiConfig {
  // Environment-based configuration
  // static const String _devBaseUrl = 'http://localhost:3000/api';
  static const String _devBaseUrl = 'http://192.168.10.123:3000/api';
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