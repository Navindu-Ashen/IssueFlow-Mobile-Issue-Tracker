import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/issue_provider.dart';
import '../widgets/issue_card.dart';
import '../widgets/app_drawer.dart';
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
            _buildFilters(context),
            const SizedBox(height: 16),
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

  Widget _buildFilters(BuildContext context) {
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

  Widget _buildIssueList(BuildContext context) {
    return Consumer<IssueProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.issues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.issues.isEmpty) {
          return Center(child: Text('No issues found.', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)));
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
