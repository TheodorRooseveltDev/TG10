import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_progress.dart';
import 'database_provider.dart';
import 'achievements_provider.dart';
import 'statistics_provider.dart';

part 'user_progress_provider.g.dart';

@riverpod
class UserProgressNotifier extends _$UserProgressNotifier {
  @override
  Future<List<UserProgress>> build() async {
    final db = ref.watch(databaseHelperProvider);
    return await db.getAllUserProgress();
  }

  Future<void> recordAnswer({
    required int questionId,
    required bool isCorrect,
    required int timeTaken,
  }) async {
    final db = ref.read(databaseHelperProvider);
    
    final progress = UserProgress(
      id: 0, // Will be auto-generated
      questionId: questionId,
      answeredCorrectly: isCorrect,
      timestamp: DateTime.now(),
      timeTaken: timeTaken,
    );
    
    await db.insertUserProgress(progress);
    ref.invalidateSelf();
    
    // Refresh statistics
    ref.invalidate(statisticsProvider);
    
    // Update accuracy achievements
    final accuracy = await db.getOverallAccuracy();
    final achievementsNotifier = ref.read(achievementsProvider.notifier);
    
    if (accuracy >= 80) {
      await achievementsNotifier.updateProgress('accuracy_80', accuracy.round());
    }
    if (accuracy >= 90) {
      await achievementsNotifier.updateProgress('accuracy_90', accuracy.round());
    }
    if (accuracy >= 100) {
      await achievementsNotifier.updateProgress('accuracy_100', accuracy.round());
    }
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<UserProgress>> incorrectAnswers(IncorrectAnswersRef ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getIncorrectAnswers();
}

@riverpod
Future<List<UserProgress>> progressByQuestion(ProgressByQuestionRef ref, int questionId) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getProgressByQuestionId(questionId);
}
