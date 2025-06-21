# Receipt Tracker API Documentation

This document provides comprehensive information about all available API endpoints in the Receipt Tracker application.

## Base Configuration

### Base URLs
- **Development**: `http://192.168.10.123:3000/api` (for physical devices)
- **Production**: `https://your-production-api.com/api`

### Common Headers
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json",
  "Accept-Encoding": "gzip, deflate, br",
  "Cache-Control": "no-cache",
  "Connection": "keep-alive",
  "Authorization": "Bearer {access_token}" // For authenticated endpoints
}
```

### Response Format
All API responses follow this standard format:

**Success Response:**
```json
{
  "success": true,
  "data": {}, // Response data
  "statusCode": 200
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Error description",
  "statusCode": 400,
  "error": "error_code"
}
```

---

## Authentication Endpoints

### 1. User Signup
**Endpoint:** `POST /auth/signup`  
**Authentication:** Not required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| username | string | Yes | Unique username |
| email | string | Yes | User email address |
| password | string | Yes | User password |
| first_name | string | Yes | User's first name |
| last_name | string | Yes | User's last name |

**Sample Request:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securePassword123",
  "first_name": "John",
  "last_name": "Doe"
}
```

**Sample Success Response:**
```json
{
  "success": true,
  "message": "Account created successfully",
  "statusCode": 201
}
```

**Sample Error Response:**
```json
{
  "success": false,
  "message": "Email already exists",
  "statusCode": 400,
  "error": "email_exists"
}
```

### 2. User Login
**Endpoint:** `POST /auth/login`  
**Authentication:** Not required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| identifier | string | Yes | Username or email |
| password | string | Yes | User password |

**Sample Request:**
```json
{
  "identifier": "john@example.com",
  "password": "securePassword123"
}
```

**Sample Success Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": "user123",
    "username": "john_doe",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "statusCode": 200
}
```

### 3. Refresh Token
**Endpoint:** `POST /auth/refresh-token`  
**Authentication:** Not required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| refreshToken | string | Yes | Valid refresh token |

**Sample Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Sample Success Response:**
```json
{
  "success": true,
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "statusCode": 200
}
```

### 4. Forgot Password
**Endpoint:** `POST /auth/forgot-password`  
**Authentication:** Not required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| email | string | Yes | User email address |

**Sample Request:**
```json
{
  "email": "john@example.com"
}
```

### 5. Reset Password
**Endpoint:** `POST /auth/reset-password`  
**Authentication:** Not required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| token | string | Yes | Password reset token |
| newPassword | string | Yes | New password |

**Sample Request:**
```json
{
  "token": "reset_token_here",
  "newPassword": "newSecurePassword123"
}
```

---

## Receipt Endpoints

### 1. Get All Receipts
**Endpoint:** `GET /receipts`  
**Authentication:** Required

**Query Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number for pagination |
| limit | integer | No | 20 | Number of receipts per page |
| category | string | No | - | Filter by category |
| search | string | No | - | Search query |

**Sample Request:**
```
GET /receipts?page=1&limit=10&category=food&search=restaurant
```

**Sample Success Response:**
```json
{
  "success": true,
  "data": {
    "receipts": [
      {
        "id": "receipt123",
        "merchant_name": "Restaurant ABC",
        "amount": 45.50,
        "receipt_date": "2024-01-15",
        "currency": "USD",
        "category": "food",
        "description": "Dinner with friends",
        "location": "New York, NY",
        "created_at": "2024-01-15T18:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_receipts": 48,
      "per_page": 10
    }
  },
  "statusCode": 200
}
```

### 2. Search Receipts
**Endpoint:** `GET /receipts/search`  
**Authentication:** Required

**Query Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| q | string | Yes | - | Search query |
| search_type | string | No | all | Search type (all, merchant, description, amount) |
| page | integer | No | 1 | Page number |
| limit | integer | No | 10 | Results per page |
| sort_by | string | No | - | Sort field (date, amount, merchant) |
| sort_order | string | No | - | Sort order (asc, desc) |

**Sample Request:**
```
GET /receipts/search?q=coffee&search_type=merchant&sort_by=date&sort_order=desc
```

### 3. Get Receipt by ID
**Endpoint:** `GET /receipts/{receiptId}`  
**Authentication:** Required

**Path Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| receiptId | string | Yes | Receipt ID |

**Sample Success Response:**
```json
{
  "success": true,
  "data": {
    "id": "receipt123",
    "merchant_name": "Coffee Shop",
    "amount": 12.50,
    "receipt_date": "2024-01-15",
    "currency": "USD",
    "category": "food",
    "description": "Morning coffee",
    "location": "Downtown",
    "tax_amount": 1.25,
    "items": [
      {
        "id": "item1",
        "name": "Latte",
        "quantity": 1,
        "unit_price": 5.50,
        "total_price": 5.50
      },
      {
        "id": "item2",
        "name": "Croissant",
        "quantity": 1,
        "unit_price": 3.50,
        "total_price": 3.50
      }
    ],
    "created_at": "2024-01-15T08:30:00Z",
    "updated_at": "2024-01-15T08:30:00Z"
  },
  "statusCode": 200
}
```

### 4. Create Receipt
**Endpoint:** `POST /receipts`  
**Authentication:** Required  
**Content-Type:** `multipart/form-data`

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| receipt_data | string (JSON) | Yes | Receipt data as JSON string |

**Receipt Data JSON Structure:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| merchant_name | string | Yes | Merchant/store name |
| amount | number | Yes | Total amount |
| receipt_date | string | Yes | Receipt date (YYYY-MM-DD) |
| currency | string | Yes | Currency code (USD, EUR, etc.) |
| description | string | No | Receipt description |
| tax_amount | number | No | Tax amount |
| location | string | No | Store location |
| category | string | No | Receipt category |
| items | array | No | Array of receipt items |

**Sample Request:**
```json
{
  "receipt_data": "{
    \"merchant_name\": \"Grocery Store\",
    \"amount\": 85.50,
    \"receipt_date\": \"2024-01-15\",
    \"currency\": \"USD\",
    \"description\": \"Weekly groceries\",
    \"tax_amount\": 7.50,
    \"location\": \"Main Street\",
    \"category\": \"groceries\",
    \"items\": [
      {
        \"name\": \"Milk\",
        \"quantity\": 2,
        \"unit_price\": 3.50,
        \"total_price\": 7.00
      }
    ]
  }"
}
```

### 5. Update Receipt
**Endpoint:** `PUT /receipts/{receiptId}`  
**Authentication:** Required

**Path Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| receiptId | string | Yes | Receipt ID |

**Body Parameters (all optional):**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| title | string | No | Receipt title |
| amount | number | No | Total amount |
| date | string | No | Receipt date |
| description | string | No | Description |
| category | string | No | Category |
| imageUrl | string | No | Image URL |
| metadata | object | No | Additional metadata |

### 6. Delete Receipt
**Endpoint:** `DELETE /receipts/{receiptId}`  
**Authentication:** Required

**Path Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| receiptId | string | Yes | Receipt ID |

### 7. Get Receipt Statistics
**Endpoint:** `GET /receipts/stats`  
**Authentication:** Required

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| startDate | string | No | Start date (YYYY-MM-DD) |
| endDate | string | No | End date (YYYY-MM-DD) |
| category | string | No | Filter by category |

**Sample Success Response:**
```json
{
  "success": true,
  "data": {
    "total_receipts": 156,
    "total_amount": 2450.75,
    "average_amount": 15.71,
    "categories": {
      "food": {
        "count": 45,
        "total_amount": 890.50
      },
      "groceries": {
        "count": 32,
        "total_amount": 1200.25
      }
    },
    "monthly_breakdown": [
      {
        "month": "2024-01",
        "count": 25,
        "total_amount": 450.75
      }
    ]
  },
  "statusCode": 200
}
```

---

## Receipt Items Endpoints

### 1. Get Receipt Items
**Endpoint:** `GET /receipts/{receiptId}/items`  
**Authentication:** Required

### 2. Add Receipt Item
**Endpoint:** `POST /receipts/{receiptId}/items`  
**Authentication:** Required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| name | string | Yes | Item name |
| quantity | integer | Yes | Item quantity |
| unit_price | number | Yes | Price per unit |
| total_price | number | Yes | Total price |
| category | string | No | Item category |
| description | string | No | Item description |

### 3. Update Receipt Item
**Endpoint:** `PUT /receipts/{receiptId}/items/{itemId}`  
**Authentication:** Required

### 4. Delete Receipt Item
**Endpoint:** `DELETE /receipts/{receiptId}/items/{itemId}`  
**Authentication:** Required

---

## Category Endpoints

### 1. Get All Categories
**Endpoint:** `GET /categories`  
**Authentication:** Required

**Sample Success Response:**
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "id": "cat1",
        "name": "Food & Dining",
        "description": "Restaurants, cafes, food delivery",
        "color": "#FF6B6B",
        "icon": "restaurant",
        "receipt_count": 45,
        "total_amount": 890.50
      },
      {
        "id": "cat2",
        "name": "Groceries",
        "description": "Supermarket, grocery stores",
        "color": "#4ECDC4",
        "icon": "shopping_cart",
        "receipt_count": 32,
        "total_amount": 1200.25
      }
    ]
  },
  "statusCode": 200
}
```

### 2. Get Category by ID
**Endpoint:** `GET /categories/{categoryId}`  
**Authentication:** Required

### 3. Create Category
**Endpoint:** `POST /categories`  
**Authentication:** Required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| name | string | Yes | Category name |
| description | string | No | Category description |
| color | string | No | Hex color code |
| icon | string | No | Icon identifier |

### 4. Update Category
**Endpoint:** `PUT /categories/{categoryId}`  
**Authentication:** Required

### 5. Delete Category
**Endpoint:** `DELETE /categories/{categoryId}`  
**Authentication:** Required

### 6. Get Category Statistics
**Endpoint:** `GET /categories/{categoryId}/stats`  
**Authentication:** Required

### 7. Get Receipts by Category
**Endpoint:** `GET /categories/{categoryId}/receipts`  
**Authentication:** Required

---

## User Endpoints

### 1. Get Current User Profile
**Endpoint:** `GET /users/profile`  
**Authentication:** Required

**Sample Success Response:**
```json
{
  "success": true,
  "data": {
    "id": "user123",
    "username": "john_doe",
    "email": "john@example.com",
    "name": "John Doe",
    "phone": "+1234567890",
    "avatar": "https://example.com/avatar.jpg",
    "preferences": {
      "currency": "USD",
      "date_format": "MM/DD/YYYY",
      "notifications": true
    },
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  },
  "statusCode": 200
}
```

### 2. Update User Profile
**Endpoint:** `PUT /users/profile`  
**Authentication:** Required

**Parameters (all optional):**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| name | string | No | Full name |
| email | string | No | Email address |
| phone | string | No | Phone number |
| avatar | string | No | Avatar URL |
| preferences | object | No | User preferences |

### 3. Change Password
**Endpoint:** `POST /users/change-password`  
**Authentication:** Required

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| currentPassword | string | Yes | Current password |
| newPassword | string | Yes | New password |

### 4. Get User Preferences
**Endpoint:** `GET /users/preferences`  
**Authentication:** Required

### 5. Update User Preferences
**Endpoint:** `PUT /users/preferences`  
**Authentication:** Required

### 6. Get User Statistics
**Endpoint:** `GET /users/stats`  
**Authentication:** Required

**Sample Success Response:**
```json
{
  "success": true,
  "data": {
    "total_receipts": 156,
    "total_spent": 2450.75,
    "average_per_receipt": 15.71,
    "most_used_category": "food",
    "receipts_this_month": 12,
    "spent_this_month": 245.50,
    "top_merchants": [
      {
        "name": "Coffee Shop",
        "count": 15,
        "total_amount": 187.50
      }
    ]
  },
  "statusCode": 200
}
```

### 7. Upload Avatar
**Endpoint:** `POST /users/avatar`  
**Authentication:** Required  
**Content-Type:** `multipart/form-data`

### 8. Delete Account
**Endpoint:** `DELETE /users/account`  
**Authentication:** Required

---

## Error Codes

| Error Code | HTTP Status | Description |
|------------|-------------|-------------|
| `validation_error` | 400 | Invalid request parameters |
| `unauthorized` | 401 | Invalid or missing authentication |
| `token_expired` | 401 | Access token has expired |
| `forbidden` | 403 | Insufficient permissions |
| `not_found` | 404 | Resource not found |
| `email_exists` | 400 | Email already registered |
| `username_exists` | 400 | Username already taken |
| `invalid_credentials` | 401 | Invalid login credentials |
| `network_error` | 500 | Network connectivity issue |
| `server_error` | 500 | Internal server error |

---

## Rate Limiting

- **Authentication endpoints**: 5 requests per minute per IP
- **General API endpoints**: 100 requests per minute per user
- **File upload endpoints**: 10 requests per minute per user

---

## Notes

1. All dates should be in ISO 8601 format (YYYY-MM-DDTHH:mm:ssZ)
2. All monetary amounts are represented as decimal numbers
3. File uploads support common image formats (JPEG, PNG, PDF)
4. Maximum file size for uploads: 10MB
5. API responses are cached for 5 minutes for GET requests
6. Pagination is 1-indexed (first page is page=1)
7. All endpoints support CORS for web applications

---

*Last updated: January 2024*