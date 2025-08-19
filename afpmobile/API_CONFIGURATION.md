# API Configuration Guide

## Current Configuration

The app is currently configured to use:
- **Backend Port**: 5001 (changed from 5000 to avoid iOS Simulator conflicts)
- **API Base URL**: `http://10.0.2.2:5001/api` (for Android emulator)

## Configuration File

The API configuration is located in: `lib/config/app_config.dart`

## How to Change API URL

### For iOS Simulator
1. Open `lib/config/app_config.dart`
2. Comment out the current line:
   ```dart
   // static const String apiBaseUrl = 'http://10.0.2.2:5001/api';
   ```
3. Uncomment the iOS Simulator line:
   ```dart
   static const String apiBaseUrl = 'http://localhost:5001/api';
   ```

### For Physical Device
1. Open `lib/config/app_config.dart`
2. Comment out the current line:
   ```dart
   // static const String apiBaseUrl = 'http://10.0.2.2:5001/api';
   ```
3. Uncomment and update the physical device line with your computer's IP:
   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:5001/api';
   ```
   **Replace `192.168.1.100` with your computer's actual IP address**

## Finding Your Computer's IP Address

### On macOS/Linux:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### On Windows:
```bash
ipconfig | findstr "IPv4"
```

## Backend Configuration

The backend server is configured to run on port 5001 in `backend/server.js`:
```javascript
const PORT = process.env.PORT || 5001;
```

## Testing the Connection

1. Start your backend server:
   ```bash
   cd backend
   npm run dev
   ```

2. Test the health endpoint:
   ```bash
   curl http://localhost:5001/api/health
   ```

3. Run your Flutter app and test the login/signup functionality.

## Troubleshooting

- **Connection refused**: Make sure your backend server is running on port 5001
- **Timeout**: Check if your firewall is blocking the connection
- **Wrong IP**: Verify your computer's IP address and update the configuration
