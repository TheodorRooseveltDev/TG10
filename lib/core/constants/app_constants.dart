/// ChickRoad City App Constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'ChickRoad City';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Learn Road Safety Worldwide';

  // URLs
  static const String privacyPolicyUrl = 'https://chickroadcity.com/privacy/';
  static const String termsOfServiceUrl = 'https://chickroadcity.com/terms/';
  static const String supportEmail = 'support@chickroadcity.com';

  // Quiz Configuration
  static const int practiceQuizDefaultQuestions = 10;
  static const int practiceQuizMaxQuestions = 30;
  static const int examModeQuestions = 30;
  static const int examModeTimeMinutes = 30;
  static const int examPassThresholdPercent = 80;

  // Streak Configuration
  static const int streakMilestone7Days = 7;
  static const int streakMilestone30Days = 30;
  static const int streakMilestone100Days = 100;

  // Achievement Thresholds
  static const int accuracyBronzePercent = 80;
  static const int accuracySilverPercent = 90;
  static const int accuracyGoldPercent = 100;

  // Notification Configuration
  static const String notificationChannelId = 'chick_road_daily_reminder';
  static const String notificationChannelName = 'Daily Reminders';
  static const String notificationChannelDescription = 'Daily streak reminder notifications';
  static const int dailyReminderHour = 20; // 8 PM
  static const int dailyReminderMinute = 0;

  // Database
  static const String databaseName = 'chick_road.db';
  static const int databaseVersion = 1;

  // SharedPreferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserAge = 'user_age';
  static const String keyPreferredDifficulty = 'preferred_difficulty';
  static const String keyTimerEnabled = 'timer_enabled';
  static const String keyQuestionsPerSession = 'questions_per_session';
  static const String keyHapticFeedbackEnabled = 'haptic_feedback_enabled';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLastStreakDate = 'last_streak_date';
  static const String keyCurrentStreakCount = 'current_streak_count';
  static const String keyAppRatingPromptCount = 'app_rating_prompt_count';

  // Default Values
  static const String defaultDifficulty = 'medium';
  static const int defaultQuestionsPerSession = 10;
  static const int minUserAge = 13;
  static const int maxUserAge = 100;

  // Difficulty Levels
  static const List<String> difficultyLevels = ['easy', 'medium', 'hard'];
  static const Map<String, String> difficultyNames = {
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
  };

  // Quiz Categories (Universal Road Safety)
  static const List<String> quizCategories = [
    'international_road_signs',
    'right_of_way_priority',
    'lane_markings',
    'speed_safe_driving',
    'parking',
    'emergency_hazards',
    'pedestrian_bicycle',
    'vehicle_maintenance',
    'weather_conditions',
    'distracted_impaired',
  ];

  static const Map<String, String> categoryNames = {
    'international_road_signs': 'International Road Signs',
    'right_of_way_priority': 'Right of Way & Priority',
    'lane_markings': 'Lane Markings & Road Lines',
    'speed_safe_driving': 'Speed Limits & Safe Driving',
    'parking': 'Parking Regulations',
    'emergency_hazards': 'Emergency Situations',
    'pedestrian_bicycle': 'Pedestrian & Bicycle Safety',
    'vehicle_maintenance': 'Vehicle Maintenance',
    'weather_conditions': 'Weather & Environment',
    'distracted_impaired': 'Distracted & Impaired Driving',
  };
  
  static const Map<String, String> categoryIcons = {
    'international_road_signs': '🚦',
    'right_of_way_priority': '🔄',
    'lane_markings': '🛣️',
    'speed_safe_driving': '🏃',
    'parking': '🅿️',
    'emergency_hazards': '⚠️',
    'pedestrian_bicycle': '🚶',
    'vehicle_maintenance': '🔧',
    'weather_conditions': '🌦️',
    'distracted_impaired': '📵',
  };

  // App Rating
  static const int sessionsBeforeRatingPrompt = 10;

  // Performance
  static const int imageCompressionQuality = 85;
  static const int cacheMaxAge = 7; // days
  static const int maxCachedImages = 100;

  // Animation
  static const int hapticFeedbackDurationMs = 50;
}
