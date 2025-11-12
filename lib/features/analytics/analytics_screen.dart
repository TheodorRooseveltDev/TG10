import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/database_provider.dart';
import '../../core/models/user_progress.dart';
import '../../core/utils/responsive_utils.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String _selectedPeriod = '7 Days';
  final List<String> _periods = ['7 Days', '30 Days', 'All Time'];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      backgroundColor: AppColors.primaryDark,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.primaryDark,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            title: Text(
              'Analytics',
              style: AppTypography.h2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              // Period selector
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  dropdownColor: AppColors.surface,
                  underline: Container(),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.secondaryYellow),
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                  items: _periods.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value!;
                    });
                  },
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Chicky
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.lg),

                  // Progress Over Time Chart
                  _buildProgressChart(),
                  const SizedBox(height: AppSpacing.lg),

                  // Accuracy Trend Chart
                  _buildAccuracyChart(),
                  const SizedBox(height: AppSpacing.lg),

                  // Category Breakdown
                  _buildCategoryBreakdown(),
                  const SizedBox(height: AppSpacing.lg),

                  // Time-Based Stats
                  _buildTimeStats(),
                  const SizedBox(height: AppSpacing.lg),

                  // Recent Activity
                  _buildRecentActivity(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info.withOpacity(0.1),
            AppColors.secondaryYellow.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Chicky thinking
          Image.asset(
            'assets/images/mascot/chicky_thinking.png',
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.analytics,
              size: 80,
              color: AppColors.secondaryYellow,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Track your learning journey',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    return FutureBuilder<List<UserProgress>>(
      future: _getProgressData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final progressData = snapshot.data!;
        final dailyStats = _aggregateByDay(progressData);

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Questions Answered Over Time',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.border,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= dailyStats.length) return const Text('');
                            final date = dailyStats.keys.elementAt(value.toInt());
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.month}/${date.day}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (dailyStats.length - 1).toDouble(),
                    minY: 0,
                    maxY: dailyStats.values.isEmpty
                        ? 10
                        : (dailyStats.values.map((e) => e['total'] ?? 0).reduce((a, b) => a > b ? a : b) + 5).toDouble(),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dailyStats.entries.toList().asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            (entry.value.value['total'] ?? 0).toDouble(),
                          );
                        }).toList(),
                        isCurved: true,
                        color: AppColors.secondaryYellow,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.secondaryYellow,
                              strokeWidth: 2,
                              strokeColor: AppColors.primaryDark,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.secondaryYellow.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccuracyChart() {
    return FutureBuilder<List<UserProgress>>(
      future: _getProgressData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final progressData = snapshot.data!;
        final dailyStats = _aggregateByDay(progressData);

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accuracy Trend',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.border,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= dailyStats.length) return const Text('');
                            final date = dailyStats.keys.elementAt(value.toInt());
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.month}/${date.day}',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (dailyStats.length - 1).toDouble(),
                    minY: 0,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: dailyStats.entries.toList().asMap().entries.map((entry) {
                          final stats = entry.value.value;
                          final accuracy = stats['total'] == 0
                              ? 0.0
                              : (stats['correct']! / stats['total']!) * 100;
                          return FlSpot(entry.key.toDouble(), accuracy);
                        }).toList(),
                        isCurved: true,
                        color: AppColors.info,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.info,
                              strokeWidth: 2,
                              strokeColor: AppColors.primaryDark,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.info.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBreakdown() {
    return FutureBuilder<Map<String, Map<String, int>>>(
      future: _getCategoryStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final categoryStats = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Performance',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...categoryStats.entries.map((entry) {
                final category = entry.key;
                final stats = entry.value;
                final total = stats['total'] ?? 0;
                final correct = stats['correct'] ?? 0;
                final accuracy = total == 0 ? 0.0 : (correct / total) * 100;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${accuracy.toStringAsFixed(1)}% ($correct/$total)',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.secondaryYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: accuracy / 100,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(
                          accuracy >= 80
                              ? Colors.green
                              : accuracy >= 60
                                  ? AppColors.secondaryYellow
                                  : Colors.red,
                        ),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeStats() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getTimeStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final timeStats = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time Statistics',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Avg Time/Question',
                      '${timeStats['avgTime']} sec',
                      Icons.timer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildStatCard(
                      'Fastest Answer',
                      '${timeStats['fastest']} sec',
                      Icons.flash_on,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Time',
                      '${(timeStats['totalTime'] / 60).toStringAsFixed(1)} min',
                      Icons.access_time,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildStatCard(
                      'Questions',
                      '${timeStats['totalQuestions']}',
                      Icons.quiz,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondaryYellow, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return FutureBuilder<List<UserProgress>>(
      future: _getRecentActivity(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final recentActivity = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (recentActivity.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'No recent activity',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...recentActivity.take(10).map((progress) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Icon(
                          progress.answeredCorrectly
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: progress.answeredCorrectly
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Question #${progress.questionId}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${progress.timeTaken}s',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatTime(progress.timestamp),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  // Helper methods
  Future<List<UserProgress>> _getProgressData() async {
    final db = ref.read(databaseHelperProvider);
    final allProgress = await db.getAllUserProgress();

    // Filter by selected period
    final now = DateTime.now();
    DateTime cutoffDate;
    
    switch (_selectedPeriod) {
      case '7 Days':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case '30 Days':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      default:
        cutoffDate = DateTime(2000); // All time
    }

    return allProgress.where((p) => p.timestamp.isAfter(cutoffDate)).toList();
  }

  Map<DateTime, Map<String, int>> _aggregateByDay(List<UserProgress> progressData) {
    final Map<DateTime, Map<String, int>> dailyStats = {};

    for (var progress in progressData) {
      final date = DateTime(
        progress.timestamp.year,
        progress.timestamp.month,
        progress.timestamp.day,
      );

      dailyStats.putIfAbsent(date, () => {'total': 0, 'correct': 0});
      dailyStats[date]!['total'] = dailyStats[date]!['total']! + 1;
      if (progress.answeredCorrectly) {
        dailyStats[date]!['correct'] = dailyStats[date]!['correct']! + 1;
      }
    }

    // Sort by date
    final sortedEntries = dailyStats.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Map.fromEntries(sortedEntries);
  }

  Future<Map<String, Map<String, int>>> _getCategoryStats() async {
    final db = ref.read(databaseHelperProvider);
    final allProgress = await _getProgressData();
    final allQuestions = await db.getAllQuestions();

    final Map<String, Map<String, int>> categoryStats = {};

    for (var progress in allProgress) {
      final question = allQuestions.firstWhere(
        (q) => q.id == progress.questionId,
        orElse: () => allQuestions.first,
      );

      categoryStats.putIfAbsent(
        question.category,
        () => {'total': 0, 'correct': 0},
      );

      categoryStats[question.category]!['total'] =
          categoryStats[question.category]!['total']! + 1;

      if (progress.answeredCorrectly) {
        categoryStats[question.category]!['correct'] =
            categoryStats[question.category]!['correct']! + 1;
      }
    }

    return categoryStats;
  }

  Future<Map<String, dynamic>> _getTimeStats() async {
    final progressData = await _getProgressData();

    if (progressData.isEmpty) {
      return {
        'avgTime': 0,
        'fastest': 0,
        'totalTime': 0,
        'totalQuestions': 0,
      };
    }

    final totalTime = progressData.fold<int>(0, (sum, p) => sum + p.timeTaken);
    final fastest = progressData.map((p) => p.timeTaken).reduce((a, b) => a < b ? a : b);

    return {
      'avgTime': (totalTime / progressData.length).toStringAsFixed(1),
      'fastest': fastest,
      'totalTime': totalTime,
      'totalQuestions': progressData.length,
    };
  }

  Future<List<UserProgress>> _getRecentActivity() async {
    final progressData = await _getProgressData();
    progressData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return progressData;
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
