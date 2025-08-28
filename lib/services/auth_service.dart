// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000/api';

  // Simpan token
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  // Ambil token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Hapus token (logout)
  static Future<void> removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('Error removing token: $e');
    }
  }

  // Login method
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 10));

      print('Login Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'error': 'Token not received'};
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false, 
          'error': errorData['message'] ?? 'Login failed',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('Login Error: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Register method
  static Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(Duration(seconds: 10));

      print('Register Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'error': 'Token not received'};
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false, 
          'error': errorData['message'] ?? errorData['errors']?.toString() ?? 'Registration failed',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('Register Error: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Logout method
  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'error': 'No token found'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      print('Logout Response: ${response.statusCode} - ${response.body}');

      await removeToken();
      
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Logout failed'};
      }
    } catch (e) {
      print('Logout Error: $e');
      await removeToken(); // Tetap hapus token meskipun error
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'error': 'No token found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      print('Profile Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false, 
          'error': 'Failed to get user profile',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('Profile Error: $e');
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }

  // Test connection to API
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'error': 'HTTP ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection error: $e'};
    }
  }
}