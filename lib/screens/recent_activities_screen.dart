import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'profile_screen.dart';

class RecentActivitiesScreen extends StatelessWidget {
  const RecentActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    // Mock data for recent activities
    final activities = [
      {'title': 'Issue #101 created', 'subtitle': 'You created a new issue regarding login failure.', 'time': '2 hours ago', 'icon': Icons.add_circle_outline},
      {'title': 'Issue #98 resolved', 'subtitle': 'Admin marked the issue as resolved.', 'time': '5 hours ago', 'icon': Icons.check_circle_outline},
      {'title': 'Comment added', 'subtitle': 'Jane Smith commented on Issue #100.', 'time': '1 day ago', 'icon': Icons.comment},
      {'title': 'Status updated', 'subtitle': 'Issue #95 changed to In Progress.', 'time': '2 days ago', 'icon': Icons.update},
      {'title': 'Issue assigned', 'subtitle': 'You were assigned to Issue #102.', 'time': '3 days ago', 'icon': Icons.person_add_alt_1},
    ];

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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
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
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(activity['icon'] as IconData, color: Theme.of(context).colorScheme.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    activity['title'] as String,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    activity['time'] as String,
                                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activity['subtitle'] as String,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
