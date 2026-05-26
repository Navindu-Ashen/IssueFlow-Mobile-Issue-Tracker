import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/issue_model.dart';
import '../providers/issue_provider.dart';
import '../widgets/issue_card.dart';
import '../widgets/app_drawer.dart';
import '../core/services/export_service.dart';
import 'issue_form_screen.dart';
import 'profile_screen.dart';

class AllIssuesScreen extends StatelessWidget {
  const AllIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      drawer: const AppDrawer(currentRoute: 'All Issues'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildHeader(context, textColor),
            ),
            _buildSearchBar(context),
            const SizedBox(height: 12),
            _buildFilterSection(context),
            const SizedBox(height: 12),
            Expanded(
              child: _buildIssueList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IssueFormScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
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
              'All Issues',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.file_upload_outlined, color: textColor),
              tooltip: 'Export Issues',
              onPressed: () => _showExportDialog(context),
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
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    final provider = context.read<IssueProvider>();
    final issues = provider.issues;

    if (issues.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No issues to export.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Export Issues',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${issues.length} issue${issues.length == 1 ? '' : 's'} will be exported',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 20),
                _ExportOptionTile(
                  icon: Icons.code,
                  title: 'Export as JSON',
                  subtitle: 'Structured data format',
                  onTap: () {
                    Navigator.pop(ctx);
                    ExportService.exportAsJson(issues);
                  },
                ),
                const SizedBox(height: 10),
                _ExportOptionTile(
                  icon: Icons.table_chart_outlined,
                  title: 'Export as CSV',
                  subtitle: 'Spreadsheet compatible',
                  onTap: () {
                    Navigator.pop(ctx);
                    ExportService.exportAsCsv(issues);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search issues...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
          ),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        onChanged: (value) {
          context.read<IssueProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Consumer<IssueProvider>(
      builder: (context, provider, _) {
        final primaryColor = Theme.of(context).colorScheme.primary;
        final borderColor = Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF27272A)
            : const Color(0xFFE4E4E7);
        final textColor = Theme.of(context).colorScheme.onSurface;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All Status',
                      isSelected: provider.statusFilter == null,
                      primaryColor: primaryColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      onTap: () => provider.setStatusFilter(null),
                    ),
                    ...IssueStatus.values.map((status) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: _statusLabel(status),
                        isSelected: provider.statusFilter == status,
                        primaryColor: primaryColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        onTap: () => provider.setStatusFilter(status),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Priority filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All Priority',
                      isSelected: provider.priorityFilter == null,
                      primaryColor: primaryColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      onTap: () => provider.setPriorityFilter(null),
                    ),
                    ...IssuePriority.values.map((priority) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: priority.name,
                        isSelected: provider.priorityFilter == priority,
                        primaryColor: primaryColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        onTap: () => provider.setPriorityFilter(priority),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusLabel(IssueStatus status) {
    switch (status) {
      case IssueStatus.Open:
        return 'Open';
      case IssueStatus.InProgress:
        return 'In Progress';
      case IssueStatus.Resolved:
        return 'Resolved';
      case IssueStatus.Closed:
        return 'Closed';
    }
  }

  Widget _buildIssueList(BuildContext context) {
    return Consumer<IssueProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.issues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.issues.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(height: 16),
                Text(
                  'No issues found.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 16,
                  ),
                ),
                if (provider.statusFilter != null || provider.priorityFilter != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: () {
                        provider.setStatusFilter(null);
                        provider.setPriorityFilter(null);
                      },
                      child: Text(
                        'Clear filters',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadIssues(forceRefresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: provider.issues.length,
            itemBuilder: (context, index) {
              final issue = provider.issues[index];
              return IssueCard(issue: issue);
            },
          ),
        );
      },
    );
  }
}

// ── Reusable Filter Chip ──────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }
}

// ── Export Option Tile ─────────────────────────────────────────────────────
class _ExportOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
