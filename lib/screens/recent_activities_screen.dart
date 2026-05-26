import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/activity_model.dart';
import '../providers/issue_provider.dart';
import '../widgets/app_drawer.dart';
import 'profile_screen.dart';

class RecentActivitiesScreen extends StatelessWidget {
  const RecentActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      drawer: const AppDrawer(currentRoute: 'Recent Activities'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildHeader(context, textColor),
            ),
            Expanded(
              child: Consumer<IssueProvider>(
                builder: (context, provider, _) {
                  final activities = provider.activities;

                  if (activities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recent activities',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Activities will appear here as you create,\nedit, or resolve issues.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return _ActivityTile(activity: activity);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: textColor),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }
            ),
            const SizedBox(width: 8),
            Text(
              'Recent Activities',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(Icons.person, size: 20, color: textColor),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }
}

// ── Activity Tile Widget ──────────────────────────────────────────────────
class _ActivityTile extends StatelessWidget {
  final Activity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon(activity.type);
    final iconColor = _getIconColor(activity.type, context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.issueTitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimeAgo(activity.timestamp),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.Created:
        return Icons.add_circle_outline;
      case ActivityType.Updated:
        return Icons.edit_outlined;
      case ActivityType.Deleted:
        return Icons.delete_outline;
      case ActivityType.StatusChanged:
        return Icons.swap_horiz;
      case ActivityType.Resolved:
        return Icons.check_circle_outline;
      case ActivityType.Closed:
        return Icons.archive_outlined;
    }
  }

  Color _getIconColor(ActivityType type, BuildContext context) {
    switch (type) {
      case ActivityType.Created:
        return Theme.of(context).colorScheme.primary;
      case ActivityType.Updated:
        return const Color(0xFF3B82F6); // Blue 500
      case ActivityType.Deleted:
        return const Color(0xFFEF4444); // Red 500
      case ActivityType.StatusChanged:
        return const Color(0xFFF59E0B); // Amber 500
      case ActivityType.Resolved:
        return const Color(0xFF10B981); // Emerald 500
      case ActivityType.Closed:
        return const Color(0xFF6B7280); // Gray 500
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
