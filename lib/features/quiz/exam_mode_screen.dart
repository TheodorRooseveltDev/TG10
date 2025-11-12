import 'dart:async';
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
import '../../core/constants/app_constants.dart';
import '../../core/services/haptics_service.dart';
import '../../core/utils/responsive_utils.dart';
import 'exam_results_screen.dart';

class ExamModeScreen extends ConsumerStatefulWidget {
  const ExamModeScreen({super.key});

  @override
  ConsumerState<ExamModeScreen> createState() => _ExamModeScreenState();
}

class _ExamModeScreenState extends ConsumerState<ExamModeScreen> {
  List<Question> _questions = [];
  List<int?> _userAnswers = [];
  int _currentQuestionIndex = 0;
  int _timeRemainingSeconds = AppConstants.examModeTimeMinutes * 60;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExamQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadExamQuestions() async {
    final db = ref.read(databaseHelperProvider);
    final allQuestions = await db.getAllQuestions();
    
    allQuestions.shuffle();
    final selectedQuestions = allQuestions.take(AppConstants.examModeQuestions).toList();
    
    setState(() {
      _questions = selectedQuestions;
      _userAnswers = List.filled(selectedQuestions.length, null);
      _isLoading = false;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemainingSeconds > 0) {
        setState(() {
          _timeRemainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitExam();
      }
    });
  }

  void _selectAnswer(int answerIndex) {
    HapticsService.instance.light();
    setState(() {
      _userAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
    Navigator.pop(context);
  }

  void _submitExam() async {
    _timer?.cancel();
    
    final db = ref.read(databaseHelperProvider);
    int correctCount = 0;
    List<int> wrongQuestionIds = [];
    
    // Calculate results and save each answer to database
    for (int i = 0; i < _questions.length; i++) {
      final isCorrect = _userAnswers[i] == _questions[i].correctIndex;
      
      if (isCorrect) {
        correctCount++;
      } else {
        wrongQuestionIds.add(_questions[i].id);
      }
      
      // Save progress for each question
      final progress = UserProgress(
        id: null, // Auto-increment
        questionId: _questions[i].id,
        answeredCorrectly: isCorrect,
        timestamp: DateTime.now(),
        timeTaken: 10, // Average time per question in exam
      );
      
      await db.insertUserProgress(progress);
    }
    
    // Refresh statistics after exam completion
    ref.invalidate(statisticsProvider);
    ref.invalidate(currentStreakProvider);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExamResultsScreen(
          totalQuestions: _questions.length,
          correctAnswers: correctCount,
          wrongAnswers: _questions.length - correctCount,
          timeTaken: (AppConstants.examModeTimeMinutes * 60) - _timeRemainingSeconds,
          wrongQuestionIds: wrongQuestionIds.map((id) => id.toString()).toList(),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ResponsiveScaffold(
        backgroundColor: AppColors.primaryDark,
        child: Scaffold(
          backgroundColor: AppColors.primaryDark,
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final isLowTime = _timeRemainingSeconds < 300; // Less than 5 minutes

    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: ResponsiveScaffold(
        backgroundColor: AppColors.primaryDark,
        child: Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () => _showExitDialog(),
            ),
          title: Text(
            'Exam Mode',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isLowTime ? AppColors.accentRed : AppColors.info,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_timeRemainingSeconds),
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.list, color: AppColors.textPrimary),
              onPressed: () => _showQuestionOverview(),
            ),
          ],
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
                _buildProgressIndicator(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildQuestionNumber(),
                        const SizedBox(height: AppSpacing.sm),
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
                      ],
                    ),
                  ),
                ),
                _buildNavigationBar(),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildProgressIndicator() {
    final answeredCount = _userAnswers.where((a) => a != null).length;
    final progress = answeredCount / _questions.length;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              ),
              Text(
                '$answeredCount answered',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.secondaryYellow),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.secondaryYellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondaryYellow),
      ),
      child: Text(
        'Question ${_currentQuestionIndex + 1}',
        style: AppTypography.h3.copyWith(color: AppColors.secondaryYellow),
        textAlign: TextAlign.center,
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
    final isSelected = _userAnswers[_currentQuestionIndex] == index;
    
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
            color: isSelected ? AppColors.secondaryYellow.withOpacity(0.2) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.secondaryYellow : AppColors.border,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.secondaryYellow : AppColors.textSecondary,
                    width: 2,
                  ),
                  color: isSelected ? AppColors.secondaryYellow : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: AppColors.primaryDark)
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  option,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousQuestion,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.textSecondary),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Previous',
                  style: AppTypography.buttonMedium.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ),
          if (_currentQuestionIndex > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _currentQuestionIndex == _questions.length - 1
                  ? () => _showSubmitDialog()
                  : _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentQuestionIndex == _questions.length - 1
                    ? AppColors.success
                    : AppColors.secondaryYellow,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentQuestionIndex == _questions.length - 1 ? 'Submit Exam' : 'Next',
                style: AppTypography.buttonLarge.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuestionOverview() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question Overview',
              style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final isAnswered = _userAnswers[index] != null;
                  final isCurrent = index == _currentQuestionIndex;
                  
                  return GestureDetector(
                    onTap: () => _goToQuestion(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.secondaryYellow
                            : isAnswered
                                ? AppColors.success.withOpacity(0.3)
                                : AppColors.border,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent ? AppColors.secondaryYellow : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: isCurrent ? AppColors.primaryDark : AppColors.textPrimary,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog() {
    final unanswered = _userAnswers.where((a) => a == null).length;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Submit Exam?', style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
        content: Text(
          unanswered > 0
              ? 'You have $unanswered unanswered question(s). Submit anyway?'
              : 'Are you sure you want to submit your exam?',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Review', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            child: Text('Submit', style: TextStyle(color: AppColors.success)),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Exit Exam?', style: AppTypography.h3.copyWith(color: AppColors.textPrimary)),
        content: Text(
          'Your progress will be lost and the exam will not be scored.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
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
