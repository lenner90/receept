import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_api_service.dart';
import '../config/api_config.dart';

class AuthService {
  
  // Login method
  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    final result = await BaseApiService.post(
      '${ApiConfig.authEndpoint}/login',
      body: {
        'identifier': identifier,
        'password': password,
      },
      includeAuth: false, // No auth needed for login
    );

    if (result['success']) {
      final data = result['data'];
      
      // Save tokens to shared preferences
      await _saveTokens(
        data['accessToken'],
        data['refreshToken'],
      );
      
      // Save user data
      await _saveUserData(data['user']);
      
      return {
        'success': true,
        'message': data['message'],
        'user': data['user'],
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
      };
    } else {
      return {
        'success': false,
        'message': result['message'] ?? 'Login failed',
      };
    }
  }

  // Save tokens to shared preferences
  static Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Save user data to shared preferences
  static Future<void> _saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user));
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }
}