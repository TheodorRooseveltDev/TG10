import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
@JsonSerializable()
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String title,
    required String description,
    required String category,
    required String iconPath,
    required int targetValue,
    @Default(0) int currentValue,
    @Default(false) bool isUnlocked,
    DateTime? unlockedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) {
    // Handle boolean field - can be int (from DB) or bool (from JSON)
    if (json['isUnlocked'] is int) {
      json = Map<String, dynamic>.from(json);
      json['isUnlocked'] = json['isUnlocked'] == 1;
    }
    return _$AchievementFromJson(json);
  }
}

// Extension for database operations
extension AchievementDbExtension on Achievement {
  static Map<String, dynamic> toJsonForDb(Achievement achievement) {
    final json = _$AchievementToJson(achievement);
    json['isUnlocked'] = achievement.isUnlocked ? 1 : 0;
    return json;
  }
}
