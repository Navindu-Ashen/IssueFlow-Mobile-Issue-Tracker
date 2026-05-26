import 'package:flutter/foundation.dart';
import '../core/network/mock_api_service.dart';
import '../data/datasources/local_storage_service.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _localStorage;
  final MockApiService _apiService;
  
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  AuthProvider(this._localStorage, this._apiService) {
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

      // Call mock API login endpoint
      final response = await _apiService.login(email, password);

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Login failed');
      }

      final responseData = response.data as Map<String, dynamic>;
      final token = responseData['token'] as String;
      final userData = responseData['user'] as Map<String, dynamic>;

      final user = User.fromMap(userData);

      // Save token and user
      await _localStorage.saveToken(token);
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
