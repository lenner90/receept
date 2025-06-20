# Android Connection Guide for Receept App

## Connection Issues

If you're experiencing "No Internet Connection" errors when trying to use the Receept app on your Android device, follow these troubleshooting steps:

## Prerequisites

1. Your Android device and development machine must be on the same WiFi network
2. The backend server must be running on your development machine
3. Your development machine's firewall must allow incoming connections on port 3000

## Configuration Steps

### 1. Verify Server Accessibility

Make sure your server is accessible from other devices on your network:

```bash
# On your development machine, find your IP address
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Try accessing your API from another device on the same network by opening a browser and navigating to:
`http://YOUR_IP_ADDRESS:3000/api` (replace YOUR_IP_ADDRESS with your actual IP)

### 2. Server Configuration

Ensure your server is binding to `0.0.0.0` (all network interfaces) and not just `localhost` or `127.0.0.1`.

### 3. App Configuration

The app is currently configured to use the following development URL:

```dart
static const String _devBaseUrl = 'http://192.168.10.123:3000/api';
```

If your development machine's IP address is different, you'll need to update this in:
`lib/config/api_config.dart`

### 4. Android Permissions

The app has been configured with:

1. Internet permission
2. Network security configuration to allow cleartext (HTTP) traffic

### 5. Rebuild and Install

After making any changes, rebuild and reinstall the app:

```bash
./build_and_install.sh
```

## Common Issues

1. **Firewall Blocking**: Check if your development machine's firewall is blocking incoming connections on port 3000

2. **Wrong IP Address**: If your development machine's IP address changes (e.g., connecting to a different WiFi network), you'll need to update the app configuration

3. **Server Not Running**: Make sure your backend server is actually running on port 3000

4. **HTTP vs HTTPS**: Android 9+ restricts cleartext (HTTP) traffic by default. We've added configuration to allow it, but you might consider using HTTPS for production

## Testing the Connection

You can test if your device can reach the server by using a network diagnostic app or opening a browser on your Android device and navigating to:
`http://192.168.10.123:3000/api`

If this doesn't load, there's a network connectivity issue between your device and the server.