import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../models/issue_model.dart';
import '../models/activity_model.dart';

class LocalStorageService {
  late Box<String> authBox;
  late Box<Issue> issueBox;
  late Box<bool> settingsBox;
  late Box<Activity> activityBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(IssueStatusAdapter());
    Hive.registerAdapter(IssuePriorityAdapter());
    Hive.registerAdapter(SyncStatusAdapter());
    Hive.registerAdapter(IssueAdapter());
    Hive.registerAdapter(ActivityTypeAdapter());
    Hive.registerAdapter(ActivityAdapter());

    // Open Boxes
    authBox = await Hive.openBox<String>(AppConstants.authBox);
    issueBox = await Hive.openBox<Issue>(AppConstants.issueBox);
    settingsBox = await Hive.openBox<bool>(AppConstants.settingsBox);
    activityBox = await Hive.openBox<Activity>(AppConstants.activityBox);
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

  // Activity Operations
  Future<void> addActivity(Activity activity) async {
    await activityBox.put(activity.id, activity);
  }

  List<Activity> getActivities() {
    final activities = activityBox.values.toList();
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }

  /// Seeds sample activities when the box is empty (first launch / fresh install).
  Future<void> seedSampleActivities() async {
    if (activityBox.isNotEmpty) return;

    const uuid = Uuid();
    final now = DateTime.now();

    final samples = [
      Activity(
        id: uuid.v4(),
        type: ActivityType.Created,
        issueTitle: 'Fix login bug',
        description: 'Created issue "Fix login bug" with High priority.',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
      Activity(
        id: uuid.v4(),
        type: ActivityType.StatusChanged,
        issueTitle: 'Implement Dark Mode',
        description: 'Changed status of "Implement Dark Mode" from Open to InProgress.',
        timestamp: now.subtract(const Duration(hours: 3)),
      ),
      Activity(
        id: uuid.v4(),
        type: ActivityType.Updated,
        issueTitle: 'Update dependencies',
        description: 'Updated issue "Update dependencies".',
        timestamp: now.subtract(const Duration(hours: 6)),
      ),
      Activity(
        id: uuid.v4(),
        type: ActivityType.Resolved,
        issueTitle: 'UI layout broken on tablet',
        description: 'Marked issue "UI layout broken on tablet" as resolved.',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      Activity(
        id: uuid.v4(),
        type: ActivityType.Created,
        issueTitle: 'Add CSV export feature',
        description: 'Created issue "Add CSV export feature" with Medium priority.',
        timestamp: now.subtract(const Duration(days: 2)),
      ),
      Activity(
        id: uuid.v4(),
        type: ActivityType.Deleted,
        issueTitle: 'Duplicate: App crash on startup',
        description: 'Deleted issue "Duplicate: App crash on startup".',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
    ];

    for (final activity in samples) {
      await activityBox.put(activity.id, activity);
    }
  }

  Future<void> clearActivities() async {
    await activityBox.clear();
  }

  // Settings Operations
  bool? getIsDarkMode() => settingsBox.get(AppConstants.themeKey);
  Future<void> saveIsDarkMode(bool isDark) => settingsBox.put(AppConstants.themeKey, isDark);
}
