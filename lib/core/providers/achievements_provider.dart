import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/achievement.dart';
import 'database_provider.dart';

part 'achievements_provider.g.dart';

@riverpod
class Achievements extends _$Achievements {
  @override
  Future<List<Achievement>> build() async {
    final db = ref.watch(databaseHelperProvider);
    return await db.getAllAchievements();
  }

  Future<void> updateProgress(String achievementId, int currentValue) async {
    final db = ref.read(databaseHelperProvider);
    await db.updateAchievementProgress(achievementId, currentValue);
    
    // Check if achievement should be unlocked
    final achievement = await db.getAchievementById(achievementId);
    if (achievement != null && !achievement.isUnlocked && currentValue >= achievement.targetValue) {
      await db.unlockAchievement(achievementId);
    }
    
    ref.invalidateSelf();
  }

  Future<void> unlockAchievement(String achievementId) async {
    final db = ref.read(databaseHelperProvider);
    await db.unlockAchievement(achievementId);
    ref.invalidateSelf();
  }

  void refresh() {
    ref.invalidateSelf();
  }
}

@riverpod
Future<Achievement?> achievementById(AchievementByIdRef ref, String id) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getAchievementById(id);
}
