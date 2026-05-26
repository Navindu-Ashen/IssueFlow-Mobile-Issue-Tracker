import 'package:flutter/material.dart';
import '../data/datasources/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _localStorage;
  late bool? _isDarkMode; // null means follow system theme

  ThemeProvider(this._localStorage) {
    _isDarkMode = _localStorage.getIsDarkMode();
  }

  bool get isDarkMode => _isDarkMode ?? false;
  
  ThemeMode get themeMode {
    if (_isDarkMode == null) return ThemeMode.system;
    return _isDarkMode! ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    _isDarkMode = !isDarkMode;
    _localStorage.saveIsDarkMode(_isDarkMode!);
    notifyListeners();
  }
}
