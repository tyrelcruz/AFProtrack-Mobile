import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/app_config.dart';

class ApiService {
  // Get base URL from environment variables or app config
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? AppConfig.apiBaseUrl;
  }

  // Headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Create pending account (signup)
  static Future<Map<String, dynamic>> createPendingAccount(
    Map<String, dynamic> userData,
  ) async {
    try {
      final url = '$baseUrl/users/mobile/signup';
      print('Making API request to: $url');
      print('Request body: ${jsonEncode(userData)}');

      final response = await http
          .post(Uri.parse(url), headers: _headers, body: jsonEncode(userData))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Request timed out. Please check your connection and try again.',
              );
            },
          );

      print('Signup response status: ${response.statusCode}');
      print('Signup response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create account',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get pending accounts
  static Future<Map<String, dynamic>> getPendingAccounts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/pending?page=$page&limit=$limit'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch pending accounts',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get active users
  static Future<Map<String, dynamic>> getActiveUsers({
    int page = 1,
    int limit = 10,
    String? search,
    String? role,
    String? unit,
    String? branchOfService,
    String? accountType,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null) queryParams['search'] = search;
      if (role != null) queryParams['role'] = role;
      if (unit != null) queryParams['unit'] = unit;
      if (branchOfService != null)
        queryParams['branchOfService'] = branchOfService;
      if (accountType != null) queryParams['accountType'] = accountType;
      if (isActive != null) queryParams['isActive'] = isActive.toString();

      final uri = Uri.parse(
        '$baseUrl/users/active',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch active users',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Login user with email or service ID
  static Future<Map<String, dynamic>> login(
    String emailOrServiceId,
    String password,
  ) async {
    try {
      final url = '$baseUrl/users/login';
      print('Making login request to: $url');

      // For now, always send as serviceId since backend only supports serviceId
      // TODO: Update backend to support email login
      final requestBody = {
        'serviceId': emailOrServiceId.toUpperCase().trim(),
        'password': password,
      };

      print('Login with serviceId: ${emailOrServiceId.toUpperCase().trim()}');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception(
                'Login request timed out. Please check your connection and try again.',
              );
            },
          );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Health check
  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Server is not responding'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
