import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/app_config.dart';
import 'token_service.dart';

class ApiService {
  // Get base URL from environment variables or app config
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? AppConfig.apiBaseUrl;
  }

  // Headers for API requests
  static Future<Map<String, String>> get _headers async {
    final token = await TokenService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Create pending account (signup)
  static Future<Map<String, dynamic>> createPendingAccount(
    Map<String, dynamic> userData,
  ) async {
    try {
      final url = '$baseUrl/users/mobile/signup';
      print('Making API request to: $url');
      print('Request body: ${jsonEncode(userData)}');

      final headers = await _headers;
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(userData))
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
      final headers = await _headers;
      final response = await http.get(
        Uri.parse('$baseUrl/users/pending?page=$page&limit=$limit'),
        headers: headers,
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

      final headers = await _headers;
      final response = await http.get(uri, headers: headers);
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

      final headers = await _headers;
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(requestBody))
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
      final headers = await _headers;
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: headers,
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

  // Get training programs
  static Future<Map<String, dynamic>> getTrainingPrograms() async {
    try {
      final headers = await _headers;
      final response = await http.get(
        Uri.parse('$baseUrl/training-programs/mobile/all'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch training programs',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get available training programs (mobile)
  static Future<Map<String, dynamic>> getAvailableTrainingPrograms({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final headers = await _headers;
      final uri = Uri.parse(
        '$baseUrl/training-programs/mobile/available?page=$page&limit=$limit',
      );
      final response = await http.get(uri, headers: headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch available programs',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get my training programs (schedule)
  static Future<Map<String, dynamic>> getMyTrainingPrograms({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final headers = await _headers;
      final uri = Uri.parse(
        '$baseUrl/training-programs/mobile/my-programs?page=$page&limit=$limit',
      );
      final response = await http.get(uri, headers: headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch my programs',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get training statistics for home view
  static Future<Map<String, dynamic>> getTrainingStatistics() async {
    try {
      final headers = await _headers;
      final response = await http.get(
        Uri.parse('$baseUrl/training-programs/mobile/my-programs'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Handle different response formats - ensure programs is always a List
        List<dynamic> programs = [];
        final responseData = data['data'];

        if (responseData is List) {
          programs = responseData;
        } else if (responseData is Map) {
          // Check if it has a 'programs' key (nested structure)
          if (responseData.containsKey('programs')) {
            programs = responseData['programs'] as List? ?? [];
          } else {
            // If it's a single object, wrap it in a list
            programs = [responseData];
          }
        } else if (responseData == null) {
          programs = [];
        }

        // Calculate statistics from the programs
        int completed = 0;
        int ongoing = 0;
        int scheduled = 0;
        int certificates = 0;

        for (var program in programs) {
          final status =
              (program['calculatedStatus'] ?? program['status'] ?? '')
                  .toString()
                  .toLowerCase();

          switch (status) {
            case 'completed':
              completed++;
              certificates++; // Completed programs count as certificates
              break;
            case 'in progress':
              ongoing++;
              break;
            case 'upcoming':
            case 'available':
              scheduled++;
              break;
          }
        }

        return {
          'success': true,
          'data': {
            'completed': completed,
            'ongoing': ongoing,
            'scheduled': scheduled,
            'certificates': certificates,
          },
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch training statistics',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Enroll in training program
  static Future<Map<String, dynamic>> enrollInTrainingProgram(
    String programId,
  ) async {
    try {
      final headers = await _headers;
      final response = await http.post(
        Uri.parse('$baseUrl/training-programs/$programId/enroll'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': data['data'],
          'message':
              data['message'] ?? 'Successfully enrolled in training program',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to enroll in training program',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get current user profile
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final headers = await _headers;
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch user profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final headers = await _headers;
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
        body: jsonEncode(userData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'] ?? 'Profile updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
