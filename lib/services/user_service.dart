import 'base_api_service.dart';
import '../config/api_config.dart';

class UserService {
  // Get current user profile
  static Future<Map<String, dynamic>> getCurrentUser() async {
    return await BaseApiService.get('${ApiConfig.usersEndpoint}/profile');
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatar,
    Map<String, dynamic>? preferences,
  }) async {
    final body = <String, dynamic>{};
    
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (phone != null) body['phone'] = phone;
    if (avatar != null) body['avatar'] = avatar;
    if (preferences != null) body['preferences'] = preferences;
    
    return await BaseApiService.put(
      '${ApiConfig.usersEndpoint}/profile',
      body: body,
    );
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await BaseApiService.post(
      '${ApiConfig.usersEndpoint}/change-password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  // Upload user avatar
  static Future<Map<String, dynamic>> uploadAvatar(String imagePath) async {
    // Note: This would typically use multipart/form-data
    // For now, this is a placeholder for the avatar upload endpoint
    return await BaseApiService.post(
      '${ApiConfig.usersEndpoint}/avatar',
      body: {'imagePath': imagePath},
    );
  }

  // Get user preferences
  static Future<Map<String, dynamic>> getPreferences() async {
    return await BaseApiService.get('${ApiConfig.usersEndpoint}/preferences');
  }

  // Update user preferences
  static Future<Map<String, dynamic>> updatePreferences(
    Map<String, dynamic> preferences,
  ) async {
    return await BaseApiService.put(
      '${ApiConfig.usersEndpoint}/preferences',
      body: preferences,
    );
  }

  // Delete user account
  static Future<Map<String, dynamic>> deleteAccount(String password) async {
    return await BaseApiService.delete(
      '${ApiConfig.usersEndpoint}/account',
    );
  }

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats() async {
    return await BaseApiService.get('${ApiConfig.usersEndpoint}/stats');
  }

  // Request password reset
  static Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    return await BaseApiService.post(
      '${ApiConfig.authEndpoint}/forgot-password',
      body: {'email': email},
      includeAuth: false,
    );
  }

  // Reset password with token
  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await BaseApiService.post(
      '${ApiConfig.authEndpoint}/reset-password',
      body: {
        'token': token,
        'newPassword': newPassword,
      },
      includeAuth: false,
    );
  }
}