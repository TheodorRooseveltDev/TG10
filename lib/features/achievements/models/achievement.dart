import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'achievement.g.dart';

/// Achievement types
enum AchievementType {
  streak,
  accuracy,
  topicMastery,
  speed,
  exam,
  special,
}

/// Achievement tiers
enum AchievementTier {
  locked,
  bronze,
  silver,
  gold,
}

/// Achievement model
@JsonSerializable()
class Achievement extends Equatable {
  /// Unique identifier
  final String id;

  /// Achievement title
  final String title;

  /// Achievement description
  final String description;

  /// Achievement type
  @JsonKey(unknownEnumValue: AchievementType.special)
  final AchievementType type;

  /// Achievement tier/level
  @JsonKey(unknownEnumValue: AchievementTier.locked)
  final AchievementTier tier;

  /// Icon asset path or identifier
  final String iconPath;

  /// Badge asset path
  final String badgePath;

  /// Requirement to unlock (e.g., "7 day streak", "80% accuracy")
  final String requirement;

  /// Numeric threshold for unlocking
  final int threshold;

  /// Category if applicable (for topic mastery achievements)
  final String? category;

  /// Whether this achievement is unlocked
  final bool isUnlocked;

  /// Date when unlocked (null if not unlocked)
  final DateTime? unlockedAt;

  /// Current progress toward unlocking (0-100)
  final int progress;

  /// Points awarded for unlocking
  final int points;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tier,
    required this.iconPath,
    required this.badgePath,
    required this.requirement,
    required this.threshold,
    this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0,
    this.points = 0,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  /// Convert to database map
  Map<String, dynamic> toDatabase() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'tier': tier.name,
        'icon_path': iconPath,
        'badge_path': badgePath,
        'requirement': requirement,
        'threshold': threshold,
        'category': category,
        'is_unlocked': isUnlocked ? 1 : 0,
        'unlocked_at': unlockedAt?.toIso8601String(),
        'progress': progress,
        'points': points,
      };

  /// Create from database map
  factory Achievement.fromDatabase(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AchievementType.special,
      ),
      tier: AchievementTier.values.firstWhere(
        (e) => e.name == map['tier'],
        orElse: () => AchievementTier.locked,
      ),
      iconPath: map['icon_path'] as String,
      badgePath: map['badge_path'] as String,
      requirement: map['requirement'] as String,
      threshold: map['threshold'] as int,
      category: map['category'] as String?,
      isUnlocked: (map['is_unlocked'] as int) == 1,
      unlockedAt: map['unlocked_at'] != null
          ? DateTime.parse(map['unlocked_at'] as String)
          : null,
      progress: map['progress'] as int? ?? 0,
      points: map['points'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        tier,
        iconPath,
        badgePath,
        requirement,
        threshold,
        category,
        isUnlocked,
        unlockedAt,
        progress,
        points,
      ];

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    AchievementTier? tier,
    String? iconPath,
    String? badgePath,
    String? requirement,
    int? threshold,
    String? category,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? progress,
    int? points,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      tier: tier ?? this.tier,
      iconPath: iconPath ?? this.iconPath,
      badgePath: badgePath ?? this.badgePath,
      requirement: requirement ?? this.requirement,
      threshold: threshold ?? this.threshold,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      points: points ?? this.points,
    );
  }
}

/// Predefined achievements
class PredefinedAchievements {
  PredefinedAchievements._();

  static final List<Achievement> all = [
    // Streak Achievements
    Achievement(
      id: 'streak_7',
      title: '7-Day Warrior',
      description: 'Maintain a 7-day streak',
      type: AchievementType.streak,
      tier: AchievementTier.bronze,
      iconPath: 'assets/images/icons/icon_streak_7days.png',
      badgePath: 'assets/images/icons/achievement_badge_bronze.png',
      requirement: '7 day streak',
      threshold: 7,
      points: 100,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Monthly Master',
      description: 'Maintain a 30-day streak',
      type: AchievementType.streak,
      tier: AchievementTier.silver,
      iconPath: 'assets/images/icons/icon_streak_30days.png',
      badgePath: 'assets/images/icons/achievement_badge_silver.png',
      requirement: '30 day streak',
      threshold: 30,
      points: 300,
    ),
    Achievement(
      id: 'streak_100',
      title: 'Century Champion',
      description: 'Maintain a 100-day streak',
      type: AchievementType.streak,
      tier: AchievementTier.gold,
      iconPath: 'assets/images/icons/icon_streak_100days.png',
      badgePath: 'assets/images/icons/achievement_badge_gold.png',
      requirement: '100 day streak',
      threshold: 100,
      points: 1000,
    ),

    // Accuracy Achievements
    Achievement(
      id: 'accuracy_80',
      title: 'Good Student',
      description: 'Achieve 80% overall accuracy',
      type: AchievementType.accuracy,
      tier: AchievementTier.bronze,
      iconPath: 'assets/images/icons/icon_accuracy_80.png',
      badgePath: 'assets/images/icons/achievement_badge_bronze.png',
      requirement: '80% accuracy',
      threshold: 80,
      points: 150,
    ),
    Achievement(
      id: 'accuracy_90',
      title: 'Excellent Driver',
      description: 'Achieve 90% overall accuracy',
      type: AchievementType.accuracy,
      tier: AchievementTier.silver,
      iconPath: 'assets/images/icons/icon_accuracy_90.png',
      badgePath: 'assets/images/icons/achievement_badge_silver.png',
      requirement: '90% accuracy',
      threshold: 90,
      points: 250,
    ),
    Achievement(
      id: 'accuracy_100',
      title: 'Perfect Scholar',
      description: 'Achieve 100% accuracy on any quiz',
      type: AchievementType.accuracy,
      tier: AchievementTier.gold,
      iconPath: 'assets/images/icons/icon_accuracy_100.png',
      badgePath: 'assets/images/icons/achievement_badge_gold.png',
      requirement: '100% accuracy',
      threshold: 100,
      points: 500,
    ),

    // Special Achievements
    Achievement(
      id: 'topic_master',
      title: 'Topic Master',
      description: 'Master all quiz topics',
      type: AchievementType.topicMastery,
      tier: AchievementTier.gold,
      iconPath: 'assets/images/icons/icon_topic_master.png',
      badgePath: 'assets/images/icons/achievement_badge_gold.png',
      requirement: 'Complete all topics',
      threshold: 10,
      points: 750,
    ),
    Achievement(
      id: 'speed_demon',
      title: 'Speed Demon',
      description: 'Complete a quiz in under 5 minutes',
      type: AchievementType.speed,
      tier: AchievementTier.silver,
      iconPath: 'assets/images/icons/icon_speed_demon.png',
      badgePath: 'assets/images/icons/achievement_badge_silver.png',
      requirement: 'Quiz under 5 minutes',
      threshold: 300, // seconds
      points: 200,
    ),
    Achievement(
      id: 'perfect_exam',
      title: 'Perfect Exam',
      description: 'Score 100% on the driving exam',
      type: AchievementType.exam,
      tier: AchievementTier.gold,
      iconPath: 'assets/images/icons/icon_perfect_exam.png',
      badgePath: 'assets/images/icons/achievement_badge_gold.png',
      requirement: '100% on exam',
      threshold: 100,
      points: 1000,
    ),
  ];
}
