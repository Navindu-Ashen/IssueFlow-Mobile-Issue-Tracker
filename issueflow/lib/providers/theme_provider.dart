import 'package:flutter/material.dart';
import '../data/datasources/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _localStorage;
  late bool _isDarkMode;

  ThemeProvider(this._localStorage) {
    _isDarkMode = _localStorage.getIsDarkMode();
  }

  bool get isDarkMode => _isDarkMode;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _localStorage.saveIsDarkMode(_isDarkMode);
    notifyListeners();
  }
}
