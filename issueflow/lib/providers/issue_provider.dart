import 'package:flutter/foundation.dart';
import '../data/models/issue_model.dart';
import '../data/repositories/issue_repository.dart';

class IssueProvider extends ChangeNotifier {
  final IssueRepository _repository;

  List<Issue> _issues = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filter states
  String _searchQuery = '';
  IssueStatus? _statusFilter;
  IssuePriority? _priorityFilter;

  IssueProvider(this._repository) {
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
    await loadIssues(); // Reload to get actual sync status
  }

  Future<void> updateIssue(Issue issue) async {
    final index = _issues.indexWhere((i) => i.id == issue.id);
    if (index != -1) {
      _issues[index] = issue;
      notifyListeners();
    }

    await _repository.updateIssue(issue);
    await loadIssues();
  }

  Future<void> deleteIssue(String id) async {
    final index = _issues.indexWhere((i) => i.id == id);
    if (index != -1) {
      final issue = _issues[index];
      _issues[index] = issue.copyWith(syncStatus: SyncStatus.PendingDelete);
      notifyListeners();
    }

    await _repository.deleteIssue(id);
    await loadIssues();
  }
}
