import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'exam_mode_screen.dart';

class ExamResultsScreen extends ConsumerWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int timeTaken;
  final List<String> wrongQuestionIds;

  const ExamResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeTaken,
    required this.wrongQuestionIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accuracyPercent = (correctAnswers / totalQuestions * 100).round();
    final isPassed = accuracyPercent >= AppConstants.examPassThresholdPercent;

    return Scaffold(
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
                        _buildResultBadge(isPassed),
                        const SizedBox(height: AppSpacing.xl),
                        _buildChickyFeedback(isPassed, accuracyPercent),
                        const SizedBox(height: AppSpacing.xl),
                        _buildScoreCard(accuracyPercent, isPassed),
                        const SizedBox(height: AppSpacing.xl),
                        _buildStatsGrid(timeTaken),
                        const SizedBox(height: AppSpacing.xl),
                        if (isPassed) _buildCertificate(accuracyPercent),
                        if (!isPassed && wrongAnswers > 0) _buildEncouragementCard(),
                      ],
                    ),
                  ),
                ),
                _buildActionButtons(context, isPassed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultBadge(bool isPassed) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isPassed
              ? [AppColors.success, AppColors.success.withOpacity(0.7)]
              : [AppColors.accentRed, AppColors.accentRed.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isPassed ? AppColors.success : AppColors.accentRed).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        isPassed ? Icons.check_circle : Icons.cancel,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildChickyFeedback(bool isPassed, int accuracyPercent) {
    String chickyImage;
    String title;
    String message;

    if (isPassed) {
      if (accuracyPercent == 100) {
        chickyImage = 'assets/images/mascot/chicky_celebrate.png';
        title = 'Perfect Score!';
        message = 'Absolutely incredible! You\'re a road safety champion!';
      } else if (accuracyPercent >= 90) {
        chickyImage = 'assets/images/mascot/chicky_celebrate.png';
        title = 'Outstanding!';
        message = 'You passed with flying colors!';
      } else {
        chickyImage = 'assets/images/mascot/chicky_happy.png';
        title = 'You Passed!';
        message = 'Great work! You\'re ready for the road!';
      }
    } else {
      chickyImage = 'assets/images/mascot/chicky_concerned.png';
      title = 'Keep Learning!';
      message = 'You need ${AppConstants.examPassThresholdPercent}% to pass. Review and try again!';
    }

    return Column(
      children: [
        Image.asset(
          chickyImage,
          width: 120,
          height: 120,
          errorBuilder: (_, __, ___) => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.secondaryYellow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPassed ? Icons.celebration : Icons.school,
              size: 60,
              color: AppColors.primaryDark,
            ),
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
              : [AppColors.accentRed.withOpacity(0.3), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPassed ? AppColors.success : AppColors.accentRed,
          width: 3,
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
              color: isPassed ? AppColors.success : AppColors.accentRed,
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$correctAnswers/$totalQuestions correct',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isPassed ? AppColors.success.withOpacity(0.2) : AppColors.accentRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPassed ? 'PASSED' : 'NOT PASSED',
              style: AppTypography.buttonMedium.copyWith(
                color: isPassed ? AppColors.success : AppColors.accentRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(int timeTaken) {
    final minutes = timeTaken ~/ 60;
    final seconds = timeTaken % 60;
    final timeStr = '${minutes}m ${seconds}s';

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
            '⏱️',
            timeStr,
            'Time',
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
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificate(int accuracyPercent) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
        border: Border.all(color: AppColors.secondaryYellow, width: 2),
      ),
      child: Column(
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.secondaryYellow, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            '🎓 Certificate of Completion',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You have successfully demonstrated knowledge of road safety rules with a score of $accuracyPercent%!',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            DateTime.now().toString().split(' ')[0],
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragementCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.secondaryYellow, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tips for Next Time',
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '• Review the topics you got wrong\n'
            '• Practice with topic-specific quizzes\n'
            '• Take your time to read each question carefully\n'
            '• You need ${AppConstants.examPassThresholdPercent}% to pass',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isPassed) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryYellow,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isPassed ? 'Celebrate! 🎉' : 'Back to Home',
                style: AppTypography.buttonLarge.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ),
          if (!isPassed) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ExamModeScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.info),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Try Again',
                  style: AppTypography.buttonLarge.copyWith(color: AppColors.info),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
