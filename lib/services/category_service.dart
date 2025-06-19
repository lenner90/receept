import 'base_api_service.dart';
import '../config/api_config.dart';

class CategoryService {
  // Get all categories
  static Future<Map<String, dynamic>> getCategories() async {
    return await BaseApiService.get(ApiConfig.categoriesEndpoint);
  }

  // Get a specific category by ID
  static Future<Map<String, dynamic>> getCategoryById(String categoryId) async {
    return await BaseApiService.get(
      '${ApiConfig.categoriesEndpoint}/$categoryId',
    );
  }

  // Create a new category
  static Future<Map<String, dynamic>> createCategory({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final body = {
      'name': name,
    };
    
    if (description != null) body['description'] = description;
    if (color != null) body['color'] = color;
    if (icon != null) body['icon'] = icon;
    
    return await BaseApiService.post(
      ApiConfig.categoriesEndpoint,
      body: body,
    );
  }

  // Update an existing category
  static Future<Map<String, dynamic>> updateCategory(
    String categoryId, {
    String? name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final body = <String, dynamic>{};
    
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (color != null) body['color'] = color;
    if (icon != null) body['icon'] = icon;
    
    return await BaseApiService.put(
      '${ApiConfig.categoriesEndpoint}/$categoryId',
      body: body,
    );
  }

  // Delete a category
  static Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    return await BaseApiService.delete(
      '${ApiConfig.categoriesEndpoint}/$categoryId',
    );
  }

  // Get category statistics (receipts count, total amount, etc.)
  static Future<Map<String, dynamic>> getCategoryStats(
    String categoryId, {
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{};
    
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;
    
    return await BaseApiService.get(
      '${ApiConfig.categoriesEndpoint}/$categoryId/stats',
      queryParams: queryParams,
    );
  }

  // Get receipts by category
  static Future<Map<String, dynamic>> getReceiptsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    return await BaseApiService.get(
      '${ApiConfig.categoriesEndpoint}/$categoryId/receipts',
      queryParams: queryParams,
    );
  }
}