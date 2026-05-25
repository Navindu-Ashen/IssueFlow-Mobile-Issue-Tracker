import 'package:flutter/material.dart';
import '../data/models/issue_model.dart';

class StatusBadge extends StatelessWidget {
  final IssueStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    String label = status.toString().split('.').last.replaceAll('In', 'In ');

    switch (status) {
      case IssueStatus.Open:
        baseColor = const Color(0xFFEF4444); // Red 500
        break;
      case IssueStatus.InProgress:
        baseColor = const Color(0xFF3B82F6); // Blue 500
        break;
      case IssueStatus.Resolved:
        baseColor = const Color(0xFF10B981); // Emerald 500
        break;
      case IssueStatus.Closed:
        baseColor = const Color(0xFF71717A); // Zinc 500
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: baseColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PriorityBadge extends StatelessWidget {
  final IssuePriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    String label = priority.toString().split('.').last;

    switch (priority) {
      case IssuePriority.High:
        baseColor = const Color(0xFFF97316); // Orange 500
        break;
      case IssuePriority.Medium:
        baseColor = const Color(0xFFF59E0B); // Amber 500
        break;
      case IssuePriority.Low:
        baseColor = const Color(0xFF84CC16); // Lime 500
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: baseColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SyncBadge extends StatelessWidget {
  final SyncStatus status;

  const SyncBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.Synced) return const SizedBox.shrink();

    return const Tooltip(
      message: 'Pending Sync',
      child: Icon(
        Icons.cloud_upload_outlined,
        color: Color(0xFFF59E0B),
        size: 16,
      ),
    );
  }
}
