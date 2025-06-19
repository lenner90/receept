import 'base_api_service.dart';
import '../config/api_config.dart';

class ReceiptService {
  // Get all receipts for the current user
  static Future<Map<String, dynamic>> getReceipts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (category != null) queryParams['category'] = category;
    if (searchQuery != null) queryParams['search'] = searchQuery;
    
    return await BaseApiService.get(
      ApiConfig.receiptsEndpoint,
      queryParams: queryParams,
    );
  }

  // Get a specific receipt by ID
  static Future<Map<String, dynamic>> getReceiptById(String receiptId) async {
    return await BaseApiService.get(
      '${ApiConfig.receiptsEndpoint}/$receiptId',
    );
  }

  // Create a new receipt
  static Future<Map<String, dynamic>> createReceipt({
    required String title,
    required double amount,
    required String date,
    String? description,
    String? category,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final body = {
      'title': title,
      'amount': amount,
      'date': date,
    };
    
    if (description != null) body['description'] = description;
    if (category != null) body['category'] = category;
    if (imageUrl != null) body['imageUrl'] = imageUrl;
    if (metadata != null) body['metadata'] = metadata;
    
    return await BaseApiService.post(
      ApiConfig.receiptsEndpoint,
      body: body,
    );
  }

  // Update an existing receipt
  static Future<Map<String, dynamic>> updateReceipt(
    String receiptId, {
    String? title,
    double? amount,
    String? date,
    String? description,
    String? category,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final body = <String, dynamic>{};
    
    if (title != null) body['title'] = title;
    if (amount != null) body['amount'] = amount;
    if (date != null) body['date'] = date;
    if (description != null) body['description'] = description;
    if (category != null) body['category'] = category;
    if (imageUrl != null) body['imageUrl'] = imageUrl;
    if (metadata != null) body['metadata'] = metadata;
    
    return await BaseApiService.put(
      '${ApiConfig.receiptsEndpoint}/$receiptId',
      body: body,
    );
  }

  // Delete a receipt
  static Future<Map<String, dynamic>> deleteReceipt(String receiptId) async {
    return await BaseApiService.delete(
      '${ApiConfig.receiptsEndpoint}/$receiptId',
    );
  }

  // Upload receipt image
  static Future<Map<String, dynamic>> uploadReceiptImage(
    String receiptId,
    String imagePath,
  ) async {
    // Note: This would typically use multipart/form-data
    // For now, this is a placeholder for the image upload endpoint
    return await BaseApiService.post(
      '${ApiConfig.receiptsEndpoint}/$receiptId/upload',
      body: {'imagePath': imagePath},
    );
  }

  // Get receipt items by receipt ID
  static Future<Map<String, dynamic>> getReceiptItems(String receiptId) async {
    return await BaseApiService.get(
      '${ApiConfig.receiptsEndpoint}/$receiptId/items',
    );
  }

  // Get receipt statistics
  static Future<Map<String, dynamic>> getReceiptStats({
    String? startDate,
    String? endDate,
    String? category,
  }) async {
    final queryParams = <String, String>{};
    
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;
    if (category != null) queryParams['category'] = category;
    
    return await BaseApiService.get(
      '${ApiConfig.receiptsEndpoint}/stats',
      queryParams: queryParams,
    );
  }
}