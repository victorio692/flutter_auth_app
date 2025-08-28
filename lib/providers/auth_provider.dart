import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = true; // Changed to true initially for auth check
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;

  AuthProvider() {
    initializeAuthState();
  }

  // Initialize auth state - check if user is already logged in
  Future<void> initializeAuthState() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await AuthService.getToken();
      
      if (token != null) {
        // Try to get user profile if token exists
        final result = await AuthService.getUserProfile();
        
        if (result['success'] == true) {
          _user = User.fromJson(result['data']);
          _isAuthenticated = true;
        } else {
          // Token might be expired, clear it
          await AuthService.removeToken();
          _isAuthenticated = false;
        }
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing auth state: $e');
      }
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await AuthService.login(email, password);

      if (result['success'] == true) {
        _user = User.fromJson(result['data']['user']);
        _isAuthenticated = true;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['error'] is Map 
            ? result['error']['message'] ?? 'Login failed'
            : result['error'].toString();
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login error: $e';
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<bool> register(String name, String email, String password, String passwordConfirmation) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await AuthService.register(name, email, password, passwordConfirmation);

      if (result['success'] == true) {
        _user = User.fromJson(result['data']['user']);
        _isAuthenticated = true;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['error'] is Map 
            ? result['error']['message'] ?? result['error']['errors']?.toString() ?? 'Registration failed'
            : result['error'].toString();
        _isAuthenticated = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration error: $e';
      _isAuthenticated = false;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.logout();
      
      _user = null;
      _isAuthenticated = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
      // Even if logout API fails, clear local data
      _user = null;
      _isAuthenticated = false;
      _error = null;
      notifyListeners();
    } finally {
      _isLoading = false;
    }
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh user data
  Future<void> refreshUserProfile() async {
    try {
      final result = await AuthService.getUserProfile();
      if (result['success'] == true) {
        _user = User.fromJson(result['data']);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing user profile: $e');
      }
    }
  }
}