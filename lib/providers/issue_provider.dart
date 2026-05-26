import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../data/models/issue_model.dart';
import '../data/models/activity_model.dart';
import '../data/repositories/issue_repository.dart';
import '../data/datasources/local_storage_service.dart';

class IssueProvider extends ChangeNotifier {
  final IssueRepository _repository;
  final LocalStorageService _localStorage;

  List<Issue> _issues = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filter states
  String _searchQuery = '';
  IssueStatus? _statusFilter;
  IssuePriority? _priorityFilter;

  IssueProvider(this._repository, this._localStorage) {
    _localStorage.seedSampleActivities();
    loadIssues();
  }

  List<Issue> get issues {
    return _issues.where((issue) {
      // Don't show deleted items
      if (issue.syncStatus == SyncStatus.PendingDelete) return false;

      final matchesSearch = issue.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == null || issue.status == _statusFilter;
      final matchesPriority = _priorityFilter == null || issue.priority == _priorityFilter;
      
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort newest first
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get openCount => _issues.where((i) => i.status == IssueStatus.Open && i.syncStatus != SyncStatus.PendingDelete).length;
  int get inProgressCount => _issues.where((i) => i.status == IssueStatus.InProgress && i.syncStatus != SyncStatus.PendingDelete).length;
  int get resolvedCount => _issues.where((i) => i.status == IssueStatus.Resolved && i.syncStatus != SyncStatus.PendingDelete).length;

  // Activity getters
  List<Activity> get activities => _localStorage.getActivities();

  // Filter getters
  IssueStatus? get statusFilter => _statusFilter;
  IssuePriority? get priorityFilter => _priorityFilter;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(IssueStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(IssuePriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  Future<void> loadIssues({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (forceRefresh) {
        await _repository.syncPendingIssues();
      }

      await for (final issueList in _repository.getIssues()) {
        _issues = issueList;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addIssue(Issue issue) async {
    // Optimistic UI update
    _issues.add(issue);
    notifyListeners();
    
    await _repository.addIssue(issue);

    // Log activity
    await _logActivity(
      type: ActivityType.Created,
      issueTitle: issue.title,
      description: 'Created issue "${issue.title}" with ${issue.priority.name} priority.',
    );

    await loadIssues(); // Reload to get actual sync status
  }

  Future<void> updateIssue(Issue issue) async {
    final index = _issues.indexWhere((i) => i.id == issue.id);
    IssueStatus? oldStatus;
    if (index != -1) {
      oldStatus = _issues[index].status;
      _issues[index] = issue;
      notifyListeners();
    }

    await _repository.updateIssue(issue);

    // Determine activity type based on what changed
    if (oldStatus != null && oldStatus != issue.status) {
      ActivityType activityType;
      String description;

      if (issue.status == IssueStatus.Resolved) {
        activityType = ActivityType.Resolved;
        description = 'Marked issue "${issue.title}" as resolved.';
      } else if (issue.status == IssueStatus.Closed) {
        activityType = ActivityType.Closed;
        description = 'Closed issue "${issue.title}".';
      } else {
        activityType = ActivityType.StatusChanged;
        description = 'Changed status of "${issue.title}" from ${oldStatus.name} to ${issue.status.name}.';
      }

      await _logActivity(
        type: activityType,
        issueTitle: issue.title,
        description: description,
      );
    } else {
      await _logActivity(
        type: ActivityType.Updated,
        issueTitle: issue.title,
        description: 'Updated issue "${issue.title}".',
      );
    }

    await loadIssues();
  }

  Future<void> deleteIssue(String id) async {
    final index = _issues.indexWhere((i) => i.id == id);
    String issueTitle = 'Unknown';
    if (index != -1) {
      final issue = _issues[index];
      issueTitle = issue.title;
      _issues[index] = issue.copyWith(syncStatus: SyncStatus.PendingDelete);
      notifyListeners();
    }

    await _repository.deleteIssue(id);

    // Log activity
    await _logActivity(
      type: ActivityType.Deleted,
      issueTitle: issueTitle,
      description: 'Deleted issue "$issueTitle".',
    );

    await loadIssues();
  }

  // Private helper to log activities
  Future<void> _logActivity({
    required ActivityType type,
    required String issueTitle,
    required String description,
  }) async {
    final activity = Activity(
      id: const Uuid().v4(),
      type: type,
      issueTitle: issueTitle,
      description: description,
      timestamp: DateTime.now(),
    );
    await _localStorage.addActivity(activity);
    notifyListeners();
  }
}
