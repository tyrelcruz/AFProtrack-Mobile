class AppConfig {
  // API Configuration
  // static const String apiBaseUrl = 'http://10.0.2.2:5001/api';

  // For iOS Simulator and local development
  // static const String apiBaseUrl = 'http://localhost:5001/api';

  // For Physical Device (uncomment the line below and comment the line above)
  // Replace 192.168.1.100 with your computer's actual IP address
  // static const String apiBaseUrl = 'http://192.168.1.100:5001/api';

  // Production Vercel Backend
  static const String apiBaseUrl = 'https://afprotrack-backend.vercel.app/api';

  // Environment
  static const String environment = 'development';

  // API Endpoints
  static const String healthEndpoint = '/health';
  static const String usersEndpoint = '/users';
  static const String loginEndpoint = '/users/login';
  static const String pendingAccountsEndpoint = '/users/pending';
  static const String activeUsersEndpoint = '/users/active';
  static const String createPendingAccountEndpoint = '/users/mobile/signup';
}
