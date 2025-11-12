import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/statistics_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/utils/responsive_utils.dart';
import '../quiz/topic_selection_screen.dart';
import '../quiz/exam_mode_screen.dart';
import '../settings/settings_screen.dart';
import '../achievements/achievements_screen.dart';
import '../analytics/analytics_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsProvider);
    final streakAsync = ref.watch(currentStreakProvider);

    return ResponsiveScaffold(
      backgroundColor: AppColors.primaryDark,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/backgrounds/road_background_subtle.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.primaryDark),
              ),
            ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildChickyGreeting(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildStatsCards(context, statsAsync, streakAsync),
                      const SizedBox(height: AppSpacing.xl),
                      _buildQuickActions(context),
                      const SizedBox(height: AppSpacing.xl),
                      _buildMotivationalSection(context, statsAsync),
                      const SizedBox(height: AppSpacing.xxl),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      centerTitle: false,
      title: Text(
        'ChickRoad',
        style: AppTypography.h2.copyWith(color: AppColors.secondaryYellow),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.emoji_events, color: AppColors.secondaryYellow),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.textSecondary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChickyGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = '🌅 Good morning!';
    } else if (hour < 17) {
      greeting = '☀️ Good afternoon!';
    } else {
      greeting = '🌙 Good evening!';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondaryYellow.withOpacity(0.3), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryYellow.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/mascot/chicky_happy.png',
            width: 60,
            height: 60,
            errorBuilder: (_, __, ___) => const Icon(Icons.emoji_emotions, size: 60, color: AppColors.secondaryYellow),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTypography.h3.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  'Ready to master road safety today?',
                  style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, AsyncValue statsAsync, AsyncValue streakAsync) {
    return statsAsync.when(
      data: (stats) => streakAsync.when(
        data: (streakCount) {
          final accuracyPercent = stats.accuracy.round();
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard('Accuracy', '$accuracyPercent%', Icons.track_changes, AppColors.secondaryYellow)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _buildStatCard('Streak', '$streakCount days', Icons.local_fire_department, AppColors.secondaryYellow)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: _buildStatCard('Answered', '${stats.totalAnswered}', Icons.quiz, AppColors.secondaryYellow),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Analytics button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                    );
                  },
                  icon: const Icon(Icons.bar_chart, size: 18),
                  label: const Text('View Detailed Analytics'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
                    side: BorderSide(color: AppColors.info.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.h3.copyWith(color: AppColors.textPrimary, fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/mascot/chicky_driving.png',
              width: 50,
              height: 50,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Quick Actions', style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Practice Quiz',
                Icons.quiz,
                AppColors.secondaryYellow,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopicSelectionScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                'Exam Mode',
                Icons.timer,
                AppColors.secondaryYellow,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamModeScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.secondaryYellow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondaryYellow.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: AppTypography.buttonMedium.copyWith(color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalSection(BuildContext context, AsyncValue statsAsync) {
    return statsAsync.when(
      data: (stats) {
        // Determine which mascot and message based on progress
        String mascotImage;
        String title;
        String message;
        
        if (stats.totalAnswered == 0) {
          mascotImage = 'assets/images/mascot/chicky_thinking.png';
          title = '🎯 Start Your Journey!';
          message = 'Take your first quiz and begin mastering road safety. Every expert started somewhere!';
        } else if (stats.accuracy >= 80) {
          mascotImage = 'assets/images/mascot/chicky_celebrate.png';
          title = '🌟 You\'re Crushing It!';
          message = 'Amazing work! Your ${stats.accuracy.round()}% accuracy shows you\'re ready for the road!';
        } else if (stats.accuracy >= 60) {
          mascotImage = 'assets/images/mascot/chicky_happy.png';
          title = '💪 Keep Going Strong!';
          message = 'You\'re making great progress! Practice more to boost that accuracy even higher.';
        } else {
          mascotImage = 'assets/images/mascot/chicky_thinking.png';
          title = '📚 Practice Makes Perfect';
          message = 'Don\'t give up! Every question helps you learn. Take it slow and you\'ll improve!';
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondaryYellow.withOpacity(0.3), AppColors.surface],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondaryYellow.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Image.asset(
                mascotImage,
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) => const Icon(Icons.emoji_emotions, size: 80, color: AppColors.secondaryYellow),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
