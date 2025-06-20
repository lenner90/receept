import 'dart:convert';
import '../config/api_config.dart';
import 'base_api_service.dart';

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

  // Create a new receipt with items
  static Future<Map<String, dynamic>> createReceipt({
    required String merchantName,
    required double amount,
    required String receiptDate,
    required String currency,
    String? description,
    double? taxAmount,
    String? location,
    String? category,
    List<ReceiptItem>? items,
  }) async {
    final receiptData = {
      'merchant_name': merchantName,
      'amount': amount,
      'receipt_date': receiptDate,
      'currency': currency,
    };
    
    if (description != null) receiptData['description'] = description;
    if (taxAmount != null) receiptData['tax_amount'] = taxAmount;
    if (location != null) receiptData['location'] = location;
    if (category != null) receiptData['category'] = category;
    if (items != null && items.isNotEmpty) {
      receiptData['items'] = items.map((item) => item.toJson()).toList();
    }
    
    return await BaseApiService.postMultipart(
      ApiConfig.receiptsEndpoint,
      fields: {
        'receipt_data': json.encode(receiptData),
      },
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

  // Add receipt item to existing receipt
  static Future<Map<String, dynamic>> addReceiptItem(
    String receiptId, {
    required String name,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? category,
    String? description,
  }) async {
    final body = {
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
    
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    
    return await BaseApiService.post(
      '${ApiConfig.receiptsEndpoint}/$receiptId/items',
      body: body,
    );
  }

  // Update receipt item
  static Future<Map<String, dynamic>> updateReceiptItem(
    String receiptId,
    String itemId, {
    String? name,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? category,
    String? description,
  }) async {
    final body = <String, dynamic>{};
    
    if (name != null) body['name'] = name;
    if (quantity != null) body['quantity'] = quantity;
    if (unitPrice != null) body['unit_price'] = unitPrice;
    if (totalPrice != null) body['total_price'] = totalPrice;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    
    return await BaseApiService.put(
      '${ApiConfig.receiptsEndpoint}/$receiptId/items/$itemId',
      body: body,
    );
  }

  // Delete receipt item
  static Future<Map<String, dynamic>> deleteReceiptItem(
    String receiptId,
    String itemId,
  ) async {
    return await BaseApiService.delete(
      '${ApiConfig.receiptsEndpoint}/$receiptId/items/$itemId',
    );
  }
}

// Receipt Item model class
class ReceiptItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? category;
  final String? description;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.category,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
    
    if (category != null) json['category'] = category!;
    if (description != null) json['description'] = description!;
    
    return json;
  }

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: double.parse(json['unit_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      category: json['category'],
      description: json['description'],
    );
  }
}