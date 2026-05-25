import 'package:flutter/foundation.dart';
import '../models/issue_model.dart';
import '../datasources/local_storage_service.dart';
import '../../core/network/mock_api_service.dart';

class IssueRepository {
  final MockApiService _apiService;
  final LocalStorageService _localStorage;

  IssueRepository(this._apiService, this._localStorage);

  // Stream allows UI to show local data first, then update with remote
  Stream<List<Issue>> getIssues() async* {
    // 1. Yield local data immediately
    final localIssues = _localStorage.getIssues();
    if (localIssues.isNotEmpty) {
      yield localIssues;
    }

    try {
      // 2. Sync pending issues before fetching new ones
      await syncPendingIssues();

      // 3. Fetch from remote
      final response = await _apiService.getIssues();
      final List<dynamic> data = response.data;
      final remoteIssues = data.map((json) => Issue.fromJson(json)).toList();

      // 4. Save to local storage
      await _localStorage.saveIssues(remoteIssues);

      // 5. Yield remote data
      yield remoteIssues;
    } catch (e) {
      // If remote fails, just keep showing local (already yielded)
      // Only yield if local was empty, to show empty state/error gracefully
      if (localIssues.isEmpty) {
        throw Exception('Failed to load issues and no local cache available: $e');
      }
    }
  }

  Future<void> addIssue(Issue issue) async {
    // Save locally first as pending create
    final pendingIssue = issue.copyWith(syncStatus: SyncStatus.PendingCreate);
    await _localStorage.saveIssue(pendingIssue);

    try {
      // Try to push to remote
      final response = await _apiService.createIssue(pendingIssue.toJson());
      if (response.statusCode == 201) {
        // Success: update local status to synced
        final syncedIssue = pendingIssue.copyWith(syncStatus: SyncStatus.Synced);
        await _localStorage.saveIssue(syncedIssue);
      }
    } catch (e) {
      // Keep as pending if API call fails (offline)
      debugPrint('Added locally, pending sync: $e');
    }
  }

  Future<void> updateIssue(Issue issue) async {
    // Save locally first as pending update
    final pendingIssue = issue.copyWith(syncStatus: SyncStatus.PendingUpdate);
    await _localStorage.saveIssue(pendingIssue);

    try {
      // Try to push to remote
      final response = await _apiService.updateIssue(pendingIssue.id, pendingIssue.toJson());
      if (response.statusCode == 200) {
        // Success: update local status to synced
        final syncedIssue = pendingIssue.copyWith(syncStatus: SyncStatus.Synced);
        await _localStorage.saveIssue(syncedIssue);
      }
    } catch (e) {
      // Keep as pending if API call fails
      debugPrint('Updated locally, pending sync: $e');
    }
  }

  Future<void> deleteIssue(String id) async {
    // To handle offline deletion, we'd normally mark it as PendingDelete.
    // For simplicity, let's remove locally, and if remote fails, it'll come back on next sync.
    // Or better: update status to PendingDelete in local storage.
    
    final existing = _localStorage.issueBox.get(id);
    if (existing != null) {
      final pendingDelete = existing.copyWith(syncStatus: SyncStatus.PendingDelete);
      await _localStorage.saveIssue(pendingDelete);

      try {
        final response = await _apiService.deleteIssue(id);
        if (response.statusCode == 200) {
          await _localStorage.deleteIssue(id);
        }
      } catch (e) {
         debugPrint('Marked deleted locally, pending sync: $e');
      }
    }
  }

  Future<void> syncPendingIssues() async {
    final allIssues = _localStorage.getIssues();
    
    for (final issue in allIssues) {
      try {
        if (issue.syncStatus == SyncStatus.PendingCreate) {
          final response = await _apiService.createIssue(issue.toJson());
          if (response.statusCode == 201) {
            await _localStorage.saveIssue(issue.copyWith(syncStatus: SyncStatus.Synced));
          }
        } else if (issue.syncStatus == SyncStatus.PendingUpdate) {
          final response = await _apiService.updateIssue(issue.id, issue.toJson());
          if (response.statusCode == 200) {
            await _localStorage.saveIssue(issue.copyWith(syncStatus: SyncStatus.Synced));
          }
        } else if (issue.syncStatus == SyncStatus.PendingDelete) {
          final response = await _apiService.deleteIssue(issue.id);
          if (response.statusCode == 200) {
             await _localStorage.deleteIssue(issue.id);
          }
        }
      } catch (e) {
        // If one sync fails, continue to others or break based on preference.
        // We'll continue.
        debugPrint('Sync failed for issue ${issue.id}: $e');
      }
    }
  }
}
