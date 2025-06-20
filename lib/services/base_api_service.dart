import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'auth_service.dart';

class BaseApiService {
  static final http.Client _client = http.Client();

  // Get headers with authentication token
  static Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    if (includeAuth) {
      final token = await _getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  // Get access token from storage
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Handle API response with token refresh logic
  static Future<Map<String, dynamic>> _handleResponse(
    http.Response response, {
    Function? retryRequest,
    bool includeAuth = true,
  }) async {
    try {
      final responseData = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else if (response.statusCode == 401 && includeAuth && retryRequest != null) {
        // Token expired, try to refresh
        final refreshResult = await AuthService.refreshToken();
        
        if (refreshResult['success']) {
          // Retry the original request with new token
          return await retryRequest();
        } else {
          // Refresh failed, return unauthorized error
          return {
            'success': false,
            'message': 'Session expired. Please login again.',
            'statusCode': 401,
            'error': 'token_expired',
          };
        }
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Request failed',
          'statusCode': response.statusCode,
          'error': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to parse response: ${e.toString()}',
        'statusCode': response.statusCode,
      };
    }
  }

  // Handle network errors
  static Map<String, dynamic> _handleError(dynamic error) {
    if (error is SocketException) {
      return {
        'success': false,
        'message': 'No internet connection',
        'error': 'network_error',
      };
    } else if (error is HttpException) {
      return {
        'success': false,
        'message': 'HTTP error: ${error.message}',
        'error': 'http_error',
      };
    } else {
      return {
        'success': false,
        'message': 'Network error: ${error.toString()}',
        'error': 'unknown_error',
      };
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      Future<Map<String, dynamic>> makeRequest() async {
        final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
            .replace(queryParameters: queryParams);
        
        final headers = await _getHeaders(includeAuth: includeAuth);
        
        final response = await _client
            .get(uri, headers: headers)
            .timeout(ApiConfig.requestTimeout);
        
        return await _handleResponse(
          response,
          retryRequest: makeRequest,
          includeAuth: includeAuth,
        );
      }
      
      return await makeRequest();
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      Future<Map<String, dynamic>> makeRequest() async {
        final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
        final headers = await _getHeaders(includeAuth: includeAuth);
        
        final response = await _client
            .post(
              uri,
              headers: headers,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(ApiConfig.requestTimeout);
        
        return await _handleResponse(
          response,
          retryRequest: makeRequest,
          includeAuth: includeAuth,
        );
      }
      
      return await makeRequest();
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      Future<Map<String, dynamic>> makeRequest() async {
        final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
        final headers = await _getHeaders(includeAuth: includeAuth);
        
        final response = await _client
            .put(
              uri,
              headers: headers,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(ApiConfig.requestTimeout);
        
        return await _handleResponse(
          response,
          retryRequest: makeRequest,
          includeAuth: includeAuth,
        );
      }
      
      return await makeRequest();
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      Future<Map<String, dynamic>> makeRequest() async {
        final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
        final headers = await _getHeaders(includeAuth: includeAuth);
        
        final response = await _client
            .delete(uri, headers: headers)
            .timeout(ApiConfig.requestTimeout);
        
        return await _handleResponse(
          response,
          retryRequest: makeRequest,
          includeAuth: includeAuth,
        );
      }
      
      return await makeRequest();
    } catch (e) {
      return _handleError(e);
    }
  }

  // PATCH request
  static Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      Future<Map<String, dynamic>> makeRequest() async {
        final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
        final headers = await _getHeaders(includeAuth: includeAuth);
        
        final response = await _client
            .patch(
              uri,
              headers: headers,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(ApiConfig.requestTimeout);
        
        return await _handleResponse(
          response,
          retryRequest: makeRequest,
          includeAuth: includeAuth,
        );
      }
      
      return await makeRequest();
    } catch (e) {
      return _handleError(e);
    }
  }

  // Dispose client
  static void dispose() {
    _client.close();
  }
}