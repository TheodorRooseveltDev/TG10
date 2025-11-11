import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_provider.dart';

part 'settings_provider.g.dart';

class UserSettings {
  final bool isFirstLaunch;
  final int? userAge;
  final String preferredDifficulty;
  final bool timerEnabled;
  final int questionsPerSession;
  final bool hapticFeedbackEnabled;
  final bool notificationsEnabled;

  const UserSettings({
    required this.isFirstLaunch,
    this.userAge,
    required this.preferredDifficulty,
    required this.timerEnabled,
    required this.questionsPerSession,
    required this.hapticFeedbackEnabled,
    required this.notificationsEnabled,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      isFirstLaunch: map['isFirstLaunch'] == 1,
      userAge: map['userAge'],
      preferredDifficulty: map['preferredDifficulty'] ?? 'medium',
      timerEnabled: map['timerEnabled'] == 1,
      questionsPerSession: map['questionsPerSession'] ?? 20,
      hapticFeedbackEnabled: map['hapticFeedbackEnabled'] == 1,
      notificationsEnabled: map['notificationsEnabled'] == 1,
    );
  }

  UserSettings copyWith({
    bool? isFirstLaunch,
    int? userAge,
    String? preferredDifficulty,
    bool? timerEnabled,
    int? questionsPerSession,
    bool? hapticFeedbackEnabled,
    bool? notificationsEnabled,
  }) {
    return UserSettings(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      userAge: userAge ?? this.userAge,
      preferredDifficulty: preferredDifficulty ?? this.preferredDifficulty,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      questionsPerSession: questionsPerSession ?? this.questionsPerSession,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

@riverpod
class Settings extends _$Settings {
  @override
  Future<UserSettings> build() async {
    // Use SharedPreferences for onboarding status (persists across hot restarts)
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    
    print('🔥 CHECKING ONBOARDING STATUS: isFirstLaunch = $isFirstLaunch');
    
    // Get other settings from database
    final db = ref.watch(databaseHelperProvider);
    final settingsMap = await db.getUserSettings();
    
    return UserSettings.fromMap({
      ...settingsMap,
      'isFirstLaunch': isFirstLaunch ? 1 : 0,
    });
  }

  Future<void> updateSettings(Map<String, dynamic> updates) async {
    final db = ref.read(databaseHelperProvider);
    await db.updateUserSettings(updates);
    ref.invalidateSelf();
  }

  Future<void> completeOnboarding(int age, String difficulty) async {
    // Save to SharedPreferences (persists across hot restarts)
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool('isFirstLaunch', false);
    print('🔥 ONBOARDING COMPLETED - SharedPreferences saved: $saved');
    print('🔥 isFirstLaunch value: ${prefs.getBool('isFirstLaunch')}');
    
    // Also save to database
    final db = ref.read(databaseHelperProvider);
    await db.completeOnboarding(age, difficulty);
    
    ref.invalidateSelf();
  }

  Future<void> setQuestionsPerSession(int count) async {
    await updateSettings({'questionsPerSession': count});
  }

  Future<void> toggleHapticFeedback() async {
    final settings = await future;
    await updateSettings({'hapticFeedbackEnabled': settings.hapticFeedbackEnabled ? 0 : 1});
  }

  Future<void> toggleNotifications() async {
    final settings = await future;
    await updateSettings({'notificationsEnabled': settings.notificationsEnabled ? 0 : 1});
  }
}

// SharedPreferences provider for quick access
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}
