import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/issue_model.dart';

class LocalStorageService {
  late Box<String> authBox;
  late Box<Issue> issueBox;
  late Box<bool> settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(IssueStatusAdapter());
    Hive.registerAdapter(IssuePriorityAdapter());
    Hive.registerAdapter(SyncStatusAdapter());
    Hive.registerAdapter(IssueAdapter());

    // Open Boxes
    authBox = await Hive.openBox<String>(AppConstants.authBox);
    issueBox = await Hive.openBox<Issue>(AppConstants.issueBox);
    settingsBox = await Hive.openBox<bool>(AppConstants.settingsBox);
  }

  // Auth Operations
  String? getToken() => authBox.get(AppConstants.tokenKey);
  Future<void> saveToken(String token) => authBox.put(AppConstants.tokenKey, token);
  Future<void> deleteToken() => authBox.delete(AppConstants.tokenKey);
  
  String? getUser() => authBox.get(AppConstants.userKey);
  Future<void> saveUser(String userJson) => authBox.put(AppConstants.userKey, userJson);
  Future<void> deleteUser() => authBox.delete(AppConstants.userKey);

  // Issue Operations
  List<Issue> getIssues() => issueBox.values.toList();
  
  Future<void> saveIssues(List<Issue> issues) async {
    await issueBox.clear();
    final Map<String, Issue> issueMap = {for (var issue in issues) issue.id: issue};
    await issueBox.putAll(issueMap);
  }

  Future<void> saveIssue(Issue issue) async {
    await issueBox.put(issue.id, issue);
  }

  Future<void> deleteIssue(String id) async {
    await issueBox.delete(id);
  }

  // Settings Operations
  bool getIsDarkMode() => settingsBox.get(AppConstants.themeKey) ?? false;
  Future<void> saveIsDarkMode(bool isDark) => settingsBox.put(AppConstants.themeKey, isDark);
}
