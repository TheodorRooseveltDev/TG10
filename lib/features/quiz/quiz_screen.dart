import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/models/question.dart';
import '../../core/models/user_progress.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/statistics_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/services/haptics_service.dart';
import 'quiz_results_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String category;
  final int questionsCount;

  const QuizScreen({
    super.key,
    required this.category,
    this.questionsCount = 10,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  int? _selectedAnswerIndex;
  bool _answerSubmitted = false;
  List<Question> _questions = [];
  List<int> _wrongQuestionIds = [];
  DateTime _questionStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final db = ref.read(databaseHelperProvider);
    final allQuestions = await db.getQuestionsByCategory(widget.category);
    if (mounted) {
      setState(() {
        _questions = allQuestions.take(widget.questionsCount).toList();
      });
    }
  }

  void _selectAnswer(int index) {
    if (!_answerSubmitted) {
      HapticsService.instance.light();
      setState(() {
        _selectedAnswerIndex = index;
      });
    }
  }

  void _submitAnswer() async {
    if (_selectedAnswerIndex == null || _answerSubmitted) return;

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswerIndex == currentQuestion.correctIndex;

    // Haptic feedback
    if (isCorrect) {
      await HapticsService.instance.success();
    } else {
      await HapticsService.instance.error();
    }

    // Save progress to database
    final db = ref.read(databaseHelperProvider);
    final timeTaken = DateTime.now().difference(_questionStartTime).inSeconds;
    
    final progress = UserProgress(
      id: null, // Auto-increment
      questionId: currentQuestion.id,
      answeredCorrectly: isCorrect,
      timestamp: DateTime.now(),
      timeTaken: timeTaken,
    );
    
    await db.insertUserProgress(progress);

    setState(() {
      _answerSubmitted = true;
      if (isCorrect) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
        _wrongQuestionIds.add(currentQuestion.id);
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _answerSubmitted = false;
        _questionStartTime = DateTime.now(); // Reset timer for next question
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    // Refresh statistics after quiz completion
    ref.invalidate(statisticsProvider);
    ref.invalidate(currentStreakProvider);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          totalQuestions: _questions.length,
          correctAnswers: _correctAnswers,
          wrongAnswers: _wrongAnswers,
          category: widget.category,
          wrongQuestionIds: _wrongQuestionIds.map((id) => id.toString()).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = _answerSubmitted && _selectedAnswerIndex == currentQuestion.correctIndex;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => _showExitDialog(),
        ),
        title: Text(
          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/road_background_subtle.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.primaryDark),
            ),
          ),
          Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (currentQuestion.imagePath != null) ...[
                        _buildQuestionImage(currentQuestion.imagePath!),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      _buildQuestionCard(currentQuestion.questionText),
                      const SizedBox(height: AppSpacing.md),
                      ...List.generate(
                        currentQuestion.options.length,
                        (index) => _buildOptionButton(index, currentQuestion),
                      ),
                      if (_answerSubmitted) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildFeedback(isCorrect, currentQuestion),
                      ],
                    ],
                  ),
                ),
              ),
              if (!_answerSubmitted && _selectedAnswerIndex != null)
                _buildSubmitButton()
              else if (_answerSubmitted)
                _buildNextButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentQuestionIndex + 1) / _questions.length;
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppColors.border,
        valueColor: const AlwaysStoppedAnimation(AppColors.secondaryYellow),
      ),
    );
  }

  Widget _buildQuestionImage(String imageUrl) {
    return Center(
      child: SizedBox(
        width: 150, // Half the size - compact and clean
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain, // Keep original aspect ratio without cropping
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surface,
              child: const Icon(Icons.image_not_supported, size: 50, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryYellow.withOpacity(0.3)),
      ),
      child: Text(
        question,
        style: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionButton(int index, Question question) {
    final option = question.options[index];
    final isSelected = _selectedAnswerIndex == index;
    final isCorrectOption = index == question.correctIndex;
    
    Color backgroundColor;
    Color borderColor;
    
    if (_answerSubmitted) {
      if (isCorrectOption) {
        backgroundColor = AppColors.success.withOpacity(0.2);
        borderColor = AppColors.success;
      } else if (isSelected) {
        backgroundColor = AppColors.accentRed.withOpacity(0.2);
        borderColor = AppColors.accentRed;
      } else {
        backgroundColor = AppColors.surface;
        borderColor = AppColors.border;
      }
    } else {
      backgroundColor = isSelected ? AppColors.secondaryYellow.withOpacity(0.2) : AppColors.surface;
      borderColor = isSelected ? AppColors.secondaryYellow : AppColors.border;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (_answerSubmitted && isCorrectOption)
                const Icon(Icons.check_circle, color: AppColors.success, size: 28),
              if (_answerSubmitted && isSelected && !isCorrectOption)
                const Icon(Icons.cancel, color: AppColors.accentRed, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(bool isCorrect, Question question) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.success.withOpacity(0.15) : AppColors.accentRed.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.accentRed,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.celebration : Icons.info_outline,
                color: isCorrect ? AppColors.success : AppColors.accentRed,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isCorrect ? 'Excellent!' : 'Not quite!',
                style: AppTypography.h3.copyWith(
                  color: isCorrect ? AppColors.success : AppColors.accentRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            question.explanation,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ElevatedButton(
        onPressed: _submitAnswer,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryYellow,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          'Submit Answer',
          style: AppTypography.buttonLarge.copyWith(color: AppColors.primaryDark),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryYellow,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          _currentQuestionIndex == _questions.length - 1 ? 'See Results' : 'Next Question',
          style: AppTypography.buttonLarge.copyWith(color: AppColors.primaryDark),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Exit Quiz?', style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
        content: Text(
          'Your progress will be lost.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Exit', style: TextStyle(color: AppColors.accentRed)),
          ),
        ],
      ),
    );
  }
}
