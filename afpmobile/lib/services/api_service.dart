import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android emulator or your computer's IP for physical device
  static const String baseUrl = 'http://10.0.2.2:5000/api';

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
      final response = await http.post(
        Uri.parse('$baseUrl/users/pending/create'),
        headers: _headers,
        body: jsonEncode(userData),
      );

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

  // Login user
  static Future<Map<String, dynamic>> login(
    String serviceId,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: _headers,
        body: jsonEncode({
          'serviceId': serviceId.toUpperCase(),
          'password': password,
        }),
      );

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
