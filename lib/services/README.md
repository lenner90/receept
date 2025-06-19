# API Services Architecture

This document outlines the API service architecture for the Receipt App, providing a scalable and maintainable approach to handle API communications.

## Architecture Overview

The API service layer is organized into the following components:

### 1. Configuration Layer (`/lib/config/`)
- **`api_config.dart`**: Centralized configuration for API endpoints, base URLs, timeouts, and headers

### 2. Base Service Layer (`/lib/services/`)
- **`base_api_service.dart`**: Core HTTP client with common functionality

### 3. Feature-Specific Services (`/lib/services/`)
- **`auth_service.dart`**: Authentication and authorization
- **`receipt_service.dart`**: Receipt management operations
- **`category_service.dart`**: Category management operations
- **`user_service.dart`**: User profile and account management

## Key Benefits

### ✅ Centralized Configuration
- Single source of truth for API base URLs
- Easy environment switching (dev/staging/prod)
- Consistent headers and timeouts across all requests

### ✅ Consistent Error Handling
- Standardized error response format
- Network error detection and handling
- Automatic token management

### ✅ Modular Architecture
- Each feature has its own service file
- Easy to maintain and test
- Clear separation of concerns

### ✅ Authentication Management
- Automatic token injection for authenticated requests
- Centralized token storage and retrieval
- Support for both authenticated and public endpoints

## Usage Examples

### Authentication
```dart
// Login
final result = await AuthService.login('user@example.com', 'password');
if (result['success']) {
  // Handle successful login
  final user = result['user'];
  final token = result['accessToken'];
}

// Check if user is logged in
final isLoggedIn = await AuthService.isLoggedIn();

// Logout
await AuthService.logout();
```

### Receipt Management
```dart
// Get receipts with pagination and filtering
final receipts = await ReceiptService.getReceipts(
  page: 1,
  limit: 20,
  category: 'food',
  searchQuery: 'restaurant',
);

// Create a new receipt
final result = await ReceiptService.createReceipt(
  title: 'Lunch at Restaurant',
  amount: 25.50,
  date: '2024-01-15',
  category: 'food',
  description: 'Business lunch meeting',
);

// Update existing receipt
final updateResult = await ReceiptService.updateReceipt(
  'receipt_id',
  title: 'Updated Title',
  amount: 30.00,
);
```

### Category Management
```dart
// Get all categories
final categories = await CategoryService.getCategories();

// Create new category
final result = await CategoryService.createCategory(
  name: 'Transportation',
  description: 'Travel and commute expenses',
  color: '#FF5722',
  icon: 'directions_car',
);
```

### User Profile
```dart
// Get current user profile
final profile = await UserService.getCurrentUser();

// Update profile
final result = await UserService.updateProfile(
  name: 'John Doe',
  email: 'john.doe@example.com',
);

// Change password
final passwordResult = await UserService.changePassword(
  currentPassword: 'oldPassword',
  newPassword: 'newPassword',
);
```

## Configuration Management

### Environment Setup
Update `api_config.dart` to switch between environments:

```dart
// Development
static const bool _isDevelopment = true;

// Production
static const bool _isDevelopment = false;
```

### Adding New Endpoints
To add new API endpoints:

1. Add the endpoint constant to `ApiConfig`:
```dart
static const String newFeatureEndpoint = '/new-feature';
```

2. Create a new service file:
```dart
// lib/services/new_feature_service.dart
import 'base_api_service.dart';
import '../config/api_config.dart';

class NewFeatureService {
  static Future<Map<String, dynamic>> getData() async {
    return await BaseApiService.get(ApiConfig.newFeatureEndpoint);
  }
}
```

## Error Handling

All API responses follow a consistent format:

### Success Response
```dart
{
  'success': true,
  'data': { /* API response data */ },
  'statusCode': 200
}
```

### Error Response
```dart
{
  'success': false,
  'message': 'Error description',
  'statusCode': 400,
  'error': 'error_code' // Optional
}
```

### Common Error Types
- `network_error`: No internet connection
- `http_error`: HTTP-related errors
- `unknown_error`: Unexpected errors

## Best Practices

### 1. Always Check Success Status
```dart
final result = await SomeService.someMethod();
if (result['success']) {
  // Handle success
  final data = result['data'];
} else {
  // Handle error
  final errorMessage = result['message'];
}
```

### 2. Use Proper Authentication Flags
```dart
// For public endpoints (login, register, forgot password)
BaseApiService.post('/auth/login', includeAuth: false);

// For protected endpoints (default behavior)
BaseApiService.get('/receipts'); // includeAuth defaults to true
```

### 3. Handle Network Errors Gracefully
```dart
final result = await ReceiptService.getReceipts();
if (!result['success']) {
  if (result['error'] == 'network_error') {
    // Show offline message
  } else {
    // Show generic error message
  }
}
```

### 4. Use Query Parameters for Filtering
```dart
// Good: Use query parameters for optional filters
final receipts = await ReceiptService.getReceipts(
  page: 1,
  category: selectedCategory,
  searchQuery: searchText,
);
```

## Testing

For testing API services, you can mock the `BaseApiService` responses:

```dart
// In your test files
class MockBaseApiService {
  static Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams, bool includeAuth = true}) async {
    // Return mock data
    return {
      'success': true,
      'data': {'mock': 'data'},
    };
  }
}
```

## Migration Guide

If you have existing API calls using direct HTTP requests:

### Before (Old Approach)
```dart
final response = await http.post(
  Uri.parse('$baseUrl/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({'email': email, 'password': password}),
);
final data = json.decode(response.body);
```

### After (New Approach)
```dart
final result = await AuthService.login(email, password);
if (result['success']) {
  final data = result['data'];
}
```

## Future Enhancements

- **Token Refresh**: Automatic token refresh when access token expires
- **Request Caching**: Cache GET requests for better performance
- **Request Retry**: Automatic retry for failed requests
- **Request Logging**: Detailed logging for debugging
- **File Upload**: Proper multipart/form-data support for file uploads