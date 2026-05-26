import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/network/mock_api_service.dart';
import 'data/datasources/local_storage_service.dart';
import 'data/repositories/issue_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/issue_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Local Storage
  final localStorageService = LocalStorageService();
  await localStorageService.init();

  // Initialize Network Service
  final mockApiService = MockApiService();

  // Initialize Repository
  final issueRepository = IssueRepository(mockApiService, localStorageService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(localStorageService, mockApiService),
        ),
        ChangeNotifierProvider(
          create: (_) => IssueProvider(issueRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(localStorageService),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IssueFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const SplashScreen(),
    );
  }
}
