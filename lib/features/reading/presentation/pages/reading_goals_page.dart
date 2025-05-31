import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reading_goal.dart';

class ReadingGoalsPage extends StatefulWidget {
  const ReadingGoalsPage({super.key});

  @override
  State<ReadingGoalsPage> createState() => _ReadingGoalsPageState();
}

class _ReadingGoalsPageState extends State<ReadingGoalsPage> {
  final List<ReadingGoal> _goals = [
    ReadingGoal(
      id: '1',
      title: 'Weekly Reading Challenge',
      description: 'Read 100 pages this week',
      targetPages: 100,
      currentPages: 45,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 5)),
    ),
    ReadingGoal(
      id: '2',
      title: 'Monthly Goal',
      description: 'Complete 3 books this month',
      targetPages: 500,
      currentPages: 320,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 15)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddGoalDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressOverview(),
            const SizedBox(height: 24),
            _buildGoalsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    final totalProgress = _goals.fold<double>(
          0,
          (sum, goal) => sum + goal.progress,
        ) /
        _goals.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Progress',
              style: GoogleFonts.lora(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        value: totalProgress,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '${(totalProgress * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _goals.map((goal) {
                final daysLeft = goal.endDate.difference(DateTime.now()).inDays;
                final progress = goal.progress;
                return FlSpot(daysLeft.toDouble(), progress);
              }).toList(),
              isCurved: true,
              color: Theme.of(context).primaryColor,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Goals',
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _goals.length,
          itemBuilder: (context, index) {
            final goal = _goals[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            goal.title,
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${goal.remainingDays} days left',
                          style: TextStyle(
                            color:
                                goal.isOverdue ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      goal.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: goal.progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${goal.currentPages} / ${goal.targetPages} pages',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Goal'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., Weekly Reading Challenge',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Read 100 pages this week',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Target Pages',
                hintText: 'Enter number of pages',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add new goal logic here
              Navigator.pop(context);
            },
            child: const Text('Add Goal'),
          ),
        ],
      ),
    );
  }
}
