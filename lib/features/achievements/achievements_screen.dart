import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/models/achievement.dart';
import '../../core/providers/achievements_provider.dart';
import '../../core/utils/responsive_utils.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return ResponsiveScaffold(
      backgroundColor: AppColors.primaryDark,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Achievements',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
        ),
      body: achievementsAsync.when(
        data: (achievements) {
          final unlockedCount = achievements.where((a) => a.isUnlocked).length;
          final totalCount = achievements.length;

          return CustomScrollView(
            slivers: [
              // Header stats
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondaryYellow.withOpacity(0.3),
                        AppColors.surface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.secondaryYellow.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/mascot/chicky_celebrate.png',
                            width: 60,
                            height: 60,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.emoji_events,
                              size: 60,
                              color: AppColors.secondaryYellow,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Progress',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$unlockedCount / $totalCount',
                                style: AppTypography.h1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      LinearProgressIndicator(
                        value: unlockedCount / totalCount,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.secondaryYellow,
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),

              // Achievements grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = achievements[index];
                      return _buildAchievementCard(achievement);
                    },
                    childCount: achievements.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.secondaryYellow),
          ),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error loading achievements',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isLocked = !achievement.isUnlocked;
    final progress = achievement.targetValue > 0
        ? (achievement.currentValue / achievement.targetValue).clamp(0.0, 1.0)
        : 0.0;

    // Determine badge image
    String badgeImage;
    if (isLocked) {
      badgeImage = 'assets/images/icons/achievement_badge_locked.png';
    } else if (achievement.category == 'streak' && achievement.targetValue >= 100) {
      badgeImage = 'assets/images/icons/achievement_badge_gold.png';
    } else if (achievement.category == 'accuracy' && achievement.targetValue >= 90) {
      badgeImage = 'assets/images/icons/achievement_badge_gold.png';
    } else if (achievement.category == 'exam' || achievement.category == 'completion') {
      badgeImage = 'assets/images/icons/achievement_badge_gold.png';
    } else if (achievement.targetValue >= 30) {
      badgeImage = 'assets/images/icons/achievement_badge_silver.png';
    } else {
      badgeImage = 'assets/images/icons/achievement_badge_bronze.png';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLocked
              ? AppColors.border
              : AppColors.secondaryYellow.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: AppColors.secondaryYellow.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge icon
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                badgeImage,
                width: 60,
                height: 60,
                color: isLocked ? Colors.grey.withOpacity(0.3) : null,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: isLocked
                      ? Colors.grey.withOpacity(0.3)
                      : AppColors.secondaryYellow,
                ),
              ),
              if (isLocked)
                const Icon(
                  Icons.lock,
                  size: 24,
                  color: Colors.grey,
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Title
          Text(
            achievement.title,
            style: AppTypography.bodySmall.copyWith(
              color: isLocked
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Description
          Text(
            achievement.description,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSpacing.xs),

          // Progress bar (only for locked achievements)
          if (isLocked) ...[
            Text(
              '${achievement.currentValue} / ${achievement.targetValue}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 2),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(
                AppColors.secondaryYellow.withOpacity(0.5),
              ),
              minHeight: 3,
              borderRadius: BorderRadius.circular(2),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondaryYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Unlocked! 🎉',
                style: AppTypography.caption.copyWith(
                  color: AppColors.secondaryYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
