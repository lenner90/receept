# Add Receipt Functionality

This document explains how to use the new add receipt functionality in the Flutter app.

## Features Added

### 1. Enhanced Receipt Service

The `ReceiptService` class has been updated with:

- **createReceipt()**: Creates a new receipt with items using multipart form data
- **addReceiptItem()**: Adds individual items to existing receipts
- **updateReceiptItem()**: Updates existing receipt items
- **deleteReceiptItem()**: Deletes receipt items

### 2. ReceiptItem Model Class

A new `ReceiptItem` class has been added to handle receipt items:

```dart
class ReceiptItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? category;
  final String? description;
}
```

### 3. Add Receipt Page

A complete UI for adding receipts with the following features:

- Merchant name input
- Total amount input
- Date picker
- Currency selection (MYR, USD, EUR, SGD, GBP)
- Description, tax amount, location, and category fields
- Dynamic item management (add/remove items)
- Form validation
- Loading states and error handling

### 4. Enhanced Base API Service

Added `postMultipart()` method to handle multipart form data requests required by the receipt creation API.

## Usage Examples

### Creating a Receipt with Items

```dart
// Create receipt items
final items = [
  ReceiptItem(
    name: 'LACK Side Table',
    quantity: 2,
    unitPrice: 25.00,
    totalPrice: 50.00,
    category: 'Furniture',
  ),
  ReceiptItem(
    name: 'FEJKA Artificial Plant',
    quantity: 1,
    unitPrice: 19.90,
    totalPrice: 19.90,
    category: 'Decoration',
  ),
];

// Create the receipt
final result = await ReceiptService.createReceipt(
  merchantName: 'IKEA Damansara',
  amount: 127.50,
  receiptDate: DateTime.now().toIso8601String(),
  currency: 'MYR',
  description: 'Home furniture shopping',
  taxAmount: 7.65,
  location: 'IKEA Damansara, PJ',
  category: 'Home & Garden',
  items: items,
);
```

### Adding Items to Existing Receipt

```dart
final result = await ReceiptService.addReceiptItem(
  '123', // receipt ID
  name: 'New Item',
  quantity: 1,
  unitPrice: 29.99,
  totalPrice: 29.99,
  category: 'Electronics',
);
```

## API Integration

The implementation follows the provided API specification:

- **Endpoint**: `POST /api/receipts`
- **Content-Type**: `multipart/form-data`
- **Field**: `receipt_data` (JSON string containing receipt and items data)
- **Authentication**: Bearer token in Authorization header

### Sample API Request Data

```json
{
  "merchant_name": "IKEA Damansara",
  "amount": 127.50,
  "receipt_date": "2024-01-20T10:30:00Z",
  "currency": "MYR",
  "description": "Home furniture shopping",
  "tax_amount": 7.65,
  "location": "IKEA Damansara, PJ",
  "category": "Home & Garden",
  "items": [
    {
      "name": "LACK Side Table",
      "quantity": 2,
      "unit_price": 25.00,
      "total_price": 50.00,
      "category": "Furniture"
    }
  ]
}
```

## Navigation

The home tab now includes a floating action button that navigates to the add receipt page. After successfully creating a receipt, the user is returned to the home tab and the receipt list is refreshed.

## Error Handling

The implementation includes comprehensive error handling:

- Form validation for required fields
- Network error handling
- API error response handling
- User-friendly error messages via SnackBar
- Loading states during API calls

## Files Modified/Created

1. **Modified**: `lib/services/base_api_service.dart` - Added multipart form data support
2. **Modified**: `lib/services/receipt_service.dart` - Updated createReceipt method and added item management
3. **Modified**: `lib/tabs/home_tab.dart` - Added floating action button and navigation
4. **Created**: `lib/screens/add_receipt_page.dart` - Complete add receipt UI
5. **Created**: `ADD_RECEIPT_USAGE.md` - This documentation file

## Testing

To test the functionality:

1. Run the Flutter app
2. Navigate to the home tab
3. Tap the floating action button (+)
4. Fill in the receipt details
5. Add items using the "Add Item" button
6. Tap "Save" to create the receipt
7. Verify the receipt appears in the home tab list

Make sure your backend API is running on the configured endpoint and accepts the multipart form data format as specified.