// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(
    _$AchievementTypeEnumMap,
    json['type'],
    unknownValue: AchievementType.special,
  ),
  tier: $enumDecode(
    _$AchievementTierEnumMap,
    json['tier'],
    unknownValue: AchievementTier.locked,
  ),
  iconPath: json['iconPath'] as String,
  badgePath: json['badgePath'] as String,
  requirement: json['requirement'] as String,
  threshold: (json['threshold'] as num).toInt(),
  category: json['category'] as String?,
  isUnlocked: json['isUnlocked'] as bool? ?? false,
  unlockedAt: json['unlockedAt'] == null
      ? null
      : DateTime.parse(json['unlockedAt'] as String),
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  points: (json['points'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'tier': _$AchievementTierEnumMap[instance.tier]!,
      'iconPath': instance.iconPath,
      'badgePath': instance.badgePath,
      'requirement': instance.requirement,
      'threshold': instance.threshold,
      'category': instance.category,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'progress': instance.progress,
      'points': instance.points,
    };

const _$AchievementTypeEnumMap = {
  AchievementType.streak: 'streak',
  AchievementType.accuracy: 'accuracy',
  AchievementType.topicMastery: 'topicMastery',
  AchievementType.speed: 'speed',
  AchievementType.exam: 'exam',
  AchievementType.special: 'special',
};

const _$AchievementTierEnumMap = {
  AchievementTier.locked: 'locked',
  AchievementTier.bronze: 'bronze',
  AchievementTier.silver: 'silver',
  AchievementTier.gold: 'gold',
};
