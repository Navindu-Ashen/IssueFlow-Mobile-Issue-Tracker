import 'package:flutter/foundation.dart';
import '../data/datasources/local_storage_service.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _localStorage;
  
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  AuthProvider(this._localStorage) {
    _checkAuthStatus();
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  void _checkAuthStatus() {
    final token = _localStorage.getToken();
    final userJson = _localStorage.getUser();
    _isAuthenticated = token != null;
    if (_isAuthenticated && userJson != null) {
      _currentUser = User.fromJson(userJson);
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Basic validation
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(email)) {
        throw Exception('Invalid email format');
      }
      if (password.length < 6) {
         throw Exception('Password must be at least 6 characters');
      }

      // Simulate network request
      await Future.delayed(const Duration(seconds: 1));

      User? user;
      if (email == 'admin@test.com' && password == 'password123') {
        user = User(
          id: 'admin_1',
          userName: 'Admin User',
          email: 'admin@test.com',
          contactNumber: '+1234567890',
          role: 'Admin',
          password: password,
        );
      } else if (email == 'user@test.com' && password == 'password123') {
        user = User(
          id: 'user_1',
          userName: 'Normal User',
          email: 'user@test.com',
          contactNumber: '+0987654321',
          role: 'User',
          password: password,
        );
      } else {
        throw Exception('Invalid credentials. Use admin@test.com or user@test.com with password123');
      }

      // Save mock token and user
      await _localStorage.saveToken('mock_jwt_token_12345');
      await _localStorage.saveUser(user.toJson());
      
      _currentUser = user;
      _isAuthenticated = true;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _localStorage.deleteToken();
    await _localStorage.deleteUser();
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }
}
