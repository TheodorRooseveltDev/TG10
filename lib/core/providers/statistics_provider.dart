import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'database_provider.dart';

part 'statistics_provider.g.dart';

class AppStatistics {
  final int totalQuestions;
  final int totalAnswered;
  final int correctAnswers;
  final double accuracy;
  final int currentStreak;
  final int unlockedAchievements;

  const AppStatistics({
    required this.totalQuestions,
    required this.totalAnswered,
    required this.correctAnswers,
    required this.accuracy,
    required this.currentStreak,
    required this.unlockedAchievements,
  });

  factory AppStatistics.fromMap(Map<String, dynamic> map) {
    return AppStatistics(
      totalQuestions: map['totalQuestions'] ?? 0,
      totalAnswered: map['totalAnswered'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      accuracy: map['accuracy']?.toDouble() ?? 0.0,
      currentStreak: map['currentStreak'] ?? 0,
      unlockedAchievements: map['unlockedAchievements'] ?? 0,
    );
  }
}

@riverpod
class Statistics extends _$Statistics {
  @override
  Future<AppStatistics> build() async {
    final db = ref.watch(databaseHelperProvider);
    final statsMap = await db.getStatistics();
    return AppStatistics.fromMap(statsMap);
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

@riverpod
Future<Map<String, double>> categoryAccuracy(CategoryAccuracyRef ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getAccuracyByCategory();
}

@riverpod
Future<double> overallAccuracy(OverallAccuracyRef ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getOverallAccuracy();
}
