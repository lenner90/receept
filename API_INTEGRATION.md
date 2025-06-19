# API Integration Documentation

## Login API Implementation

This Flutter app now includes API integration for user authentication using the backend login endpoint.

### API Endpoint
- **URL**: `http://localhost:3000/api/auth/login`
- **Method**: POST
- **Content-Type**: application/json

### Request Format
```json
{
  "identifier": "username_or_email",
  "password": "user_password"
}
```

### Response Format
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "waichoon",
    "email": "lenner90@hotmail.com",
    "first_name": "Wai Choon",
    "last_name": "Lim",
    "country": "MY",
    "timezone": "Asia/Kuala_Lumpur",
    "plan": "enterprise",
    "credits": 10000,
    "credits_used": 0
  },
  "accessToken": "jwt_access_token",
  "refreshToken": "jwt_refresh_token"
}
```

## Implementation Details

### Files Modified/Created

1. **`lib/services/auth_service.dart`** (New)
   - Handles API communication
   - Manages token storage using SharedPreferences
   - Provides methods for login, logout, and token management

2. **`lib/screens/login_page.dart`** (Modified)
   - Integrated API call in login handler
   - Added proper error handling and user feedback
   - Shows success/error messages via SnackBar

3. **`lib/tabs/settings_tab.dart`** (Modified)
   - Displays actual user data from API response
   - Shows user initials, name, email, and plan
   - Implements proper logout with confirmation dialog
   - Clears stored data on logout

4. **`pubspec.yaml`** (Modified)
   - Added `http: ^1.1.0` for API calls
   - Added `shared_preferences: ^2.2.2` for local storage

### Features Implemented

#### Authentication
- ✅ API-based login validation
- ✅ Token storage (access & refresh tokens)
- ✅ User data persistence
- ✅ Proper error handling
- ✅ Loading states

#### User Interface
- ✅ Success/error feedback messages
- ✅ Dynamic user profile display
- ✅ Logout confirmation dialog
- ✅ Loading indicators

#### Data Management
- ✅ Secure token storage
- ✅ User data caching
- ✅ Complete data cleanup on logout

### Usage Instructions

1. **Start the Backend Server**
   - Ensure your backend server is running on `http://localhost:3000`
   - The `/api/auth/login` endpoint should be accessible

2. **Run the Flutter App**
   ```bash
   flutter run
   ```

3. **Login Process**
   - Enter username/email and password
   - Tap "Login" button
   - App will make API call to validate credentials
   - On success: Navigate to home page with user data stored
   - On failure: Display error message

4. **View User Profile**
   - Navigate to Settings tab
   - User information from API response is displayed
   - Shows name, email, and subscription plan

5. **Logout**
   - Go to Settings tab
   - Tap "Logout" button
   - Confirm logout in dialog
   - All stored data is cleared and app returns to login

### Security Considerations

- Tokens are stored securely using SharedPreferences
- Passwords are not stored locally
- Proper error handling prevents information leakage
- Network requests include appropriate headers

### Future Enhancements

- Token refresh mechanism
- Biometric authentication
- Remember me functionality
- Offline mode support
- API error code handling