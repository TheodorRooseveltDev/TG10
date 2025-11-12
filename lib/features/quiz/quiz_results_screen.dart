import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive_utils.dart';

class QuizResultsScreen extends ConsumerWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final String category;
  final List<String> wrongQuestionIds;

  const QuizResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.category,
    required this.wrongQuestionIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accuracyPercent = (correctAnswers / totalQuestions * 100).round();
    final isPassed = accuracyPercent >= 70;

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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        _buildChickyFeedback(isPassed),
                        const SizedBox(height: AppSpacing.xl),
                        _buildScoreCard(accuracyPercent, isPassed),
                        const SizedBox(height: AppSpacing.xl),
                        _buildStatsGrid(),
                        const SizedBox(height: AppSpacing.xl),
                        if (wrongAnswers > 0) _buildMistakesCard(),
                      ],
                    ),
                  ),
                ),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildChickyFeedback(bool isPassed) {
    final chickyImage = isPassed 
        ? 'assets/images/mascot/chicky_happy.png'
        : 'assets/images/mascot/chicky_thinking.png';
    final title = isPassed ? 'Great Job!' : 'Keep Practicing!';
    final message = isPassed
        ? 'You\'re mastering road safety!'
        : 'Every mistake is a learning opportunity!';

    return Column(
      children: [
        Image.asset(
          chickyImage,
          width: 100,
          height: 100,
          errorBuilder: (_, __, ___) => Text(
            isPassed ? '🎉' : '💪',
            style: const TextStyle(fontSize: 80),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(title, style: AppTypography.h1.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          message,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScoreCard(int accuracyPercent, bool isPassed) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPassed
              ? [AppColors.success.withOpacity(0.3), AppColors.surface]
              : [AppColors.warning.withOpacity(0.3), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPassed ? AppColors.success : AppColors.warning,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$accuracyPercent%',
            style: AppTypography.h1.copyWith(
              color: isPassed ? AppColors.success : AppColors.warning,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$correctAnswers/$totalQuestions correct',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            '✅',
            '$correctAnswers',
            'Correct',
            AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatItem(
            '❌',
            '$wrongAnswers',
            'Wrong',
            AppColors.accentRed,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatItem(
            '📊',
            '$totalQuestions',
            'Total',
            AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String emoji, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakesCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.secondaryYellow, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Review Mistakes',
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You got $wrongAnswers question${wrongAnswers == 1 ? '' : 's'} wrong. Review them to improve!',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryYellow,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Back to Topics',
                style: AppTypography.buttonLarge.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.textSecondary),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Home',
                style: AppTypography.buttonLarge.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
