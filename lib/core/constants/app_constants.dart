class AppConstants {
  static const String appName = 'IssueFlow';
  
  // Hive Boxes
  static const String authBox = 'authBox';
  static const String issueBox = 'issueBox';
  static const String settingsBox = 'settingsBox';
  
  // Keys
  static const String tokenKey = 'authToken';
  static const String userKey = 'currentUser';
  static const String themeKey = 'isDarkMode';
  
  // Sample Assignees — each entry is { 'role': ..., 'name': ... }
  // 'name' is the value stored in the Issue model.
  static const List<Map<String, String>> assigneeDetails = [
    {
      'name': 'Unassigned',
      'role': 'Unassigned',
      'subtitle': 'Leave this issue unassigned.',
    },
    {
      'name': 'John Doe',
      'role': 'Software Engineer',
      'subtitle': 'John Doe',
    },
    {
      'name': 'Jane Smith',
      'role': 'Network Engineer',
      'subtitle': 'Jane Smith',
    },
    {
      'name': 'Alice Johnson',
      'role': 'IT Support Engineer',
      'subtitle': 'Alice Johnson',
    },
    {
      'name': 'Bob Williams',
      'role': 'QA Engineer',
      'subtitle': 'Bob Williams',
    },
  ];

  // Keep the flat list for backward compat (e.g. validation, dropdowns elsewhere)
  static const List<String> assignees = [
    'John Doe',
    'Jane Smith',
    'Alice Johnson',
    'Bob Williams',
    'Unassigned',
  ];
}
