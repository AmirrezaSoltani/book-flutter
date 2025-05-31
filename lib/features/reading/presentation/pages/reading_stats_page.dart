import 'package:flutter/material.dart';
import '../models/reading_stats.dart';

class ReadingStatsPage extends StatelessWidget {
  final ReadingStats stats;

  const ReadingStatsPage({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(context),
            const SizedBox(height: 16),
            _buildTimeCard(context),
            const SizedBox(height: 16),
            _buildAnnotationsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reading Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: stats.progress,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${(stats.progress * 100).toStringAsFixed(1)}% Complete',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${stats.pagesRead} of ${stats.totalPages} pages read',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${stats.remainingPages} pages remaining',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reading Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Total Reading Time',
              '${stats.totalTimeMinutes} minutes',
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              'Average Time per Page',
              '${stats.averageTimePerPage} minutes',
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              'Last Read',
              _formatDate(stats.lastRead),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnotationsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Annotations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Bookmarks',
              stats.bookmarksCount.toString(),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              'Highlights',
              stats.highlightsCount.toString(),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              'Notes',
              stats.notesCount.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 