import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/issue_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/issue_card.dart';
import 'all_issues_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IssueProvider>();
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      drawer: const AppDrawer(currentRoute: 'Dashboard'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.loadIssues(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, textColor),
                  const SizedBox(height: 24),
                  _buildTotalBalance(
                    context,
                    provider.issues.length,
                    textColor,
                  ),
                  const SizedBox(height: 24),
                  _buildChart(context),
                  const SizedBox(height: 24),
                  _buildSummaryCards(provider),
                  const SizedBox(height: 16),
                  _buildForecastBanner(context),
                  const SizedBox(height: 32),
                  _buildRecentIssuesHeader(
                    context,
                    provider.issues.length,
                    textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildRecentIssuesList(context, provider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: textColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        Image.asset('assets/icon.png', width: 32, height: 32),
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

  Widget _buildTotalBalance(BuildContext context, int total, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total issues • All time',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$total',
          style: TextStyle(
            color: textColor,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 3),
                FlSpot(3, 7),
                FlSpot(4, 5),
                FlSpot(5, 8),
                FlSpot(6, 6),
              ],
              isCurved: true,
              color: primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.3),
                    primaryColor.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(IssueProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCardWidget(
            title: 'Open',
            count: provider.openCount,
            badgeText: '+${provider.openCount}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCardWidget(
            title: 'In Progress',
            count: provider.inProgressCount,
            badgeText: '~${provider.inProgressCount}',
          ),
        ),
      ],
    );
  }

  Widget _buildForecastBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.insights, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'IssueFlow Insights',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'How quickly can you resolve issues?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllIssuesScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Find out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentIssuesHeader(
    BuildContext context,
    int count,
    Color textColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Issues',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerTheme.color ?? Colors.grey,
            ),
          ),
          child: Text(
            '$count',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentIssuesList(BuildContext context, IssueProvider provider) {
    if (provider.isLoading && provider.issues.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.issues.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No issues found.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final latestIssues = provider.issues.take(5).toList();

    return Column(
      children: [
        ...latestIssues.map((issue) => IssueCard(issue: issue)),

        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllIssuesScreen()),
            );
          },
          child: Text(
            'View All Issues',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}

class _SummaryCardWidget extends StatelessWidget {
  final String title;
  final int count;
  final String badgeText;

  const _SummaryCardWidget({
    required this.title,
    required this.count,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surface, // Dark grey / Light surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? Colors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
