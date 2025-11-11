import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/streak.dart';
import 'database_provider.dart';
import 'achievements_provider.dart';

part 'streak_provider.g.dart';

@riverpod
class CurrentStreak extends _$CurrentStreak {
  @override
  Future<int> build() async {
    final db = ref.watch(databaseHelperProvider);
    return await db.getCurrentStreakCount();
  }

  Future<void> markTodayComplete() async {
    final db = ref.read(databaseHelperProvider);
    final today = DateTime.now();
    final dateStr = today.toIso8601String().split('T')[0];
    
    final streak = Streak(
      id: 0, // Will be auto-generated
      date: dateStr,
      completed: true,
    );
    
    await db.insertStreak(streak);
    ref.invalidateSelf();
    
    // Update streak achievements
    final newStreakCount = await db.getCurrentStreakCount();
    final achievementsNotifier = ref.read(achievementsProvider.notifier);
    
    if (newStreakCount >= 7) {
      await achievementsNotifier.updateProgress('streak_7', newStreakCount);
    }
    if (newStreakCount >= 30) {
      await achievementsNotifier.updateProgress('streak_30', newStreakCount);
    }
    if (newStreakCount >= 100) {
      await achievementsNotifier.updateProgress('streak_100', newStreakCount);
    }
  }

  Future<bool> isTodayComplete() async {
    final db = ref.read(databaseHelperProvider);
    final today = DateTime.now();
    final streak = await db.getStreakByDate(today);
    return streak?.completed ?? false;
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<Streak>> allStreaks(AllStreaksRef ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getAllStreaks();
}

@riverpod
Future<Streak?> streakByDate(StreakByDateRef ref, DateTime date) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getStreakByDate(date);
}
