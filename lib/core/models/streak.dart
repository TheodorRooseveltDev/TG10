import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'streak.freezed.dart';
part 'streak.g.dart';

@freezed
@JsonSerializable()
class Streak with _$Streak {
  const factory Streak({
    required int id,
    required String date, // ISO 8601 date string (YYYY-MM-DD)
    required bool completed,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) {
    // Handle boolean field - can be int (from DB) or bool (from JSON)
    if (json['completed'] is int) {
      json = Map<String, dynamic>.from(json);
      json['completed'] = json['completed'] == 1;
    }
    return _$StreakFromJson(json);
  }
}

// Extension for database operations
extension StreakDbExtension on Streak {
  static Map<String, dynamic> toJsonForDb(Streak streak) {
    final json = _$StreakToJson(streak);
    json['completed'] = streak.completed ? 1 : 0;
    return json;
  }
}
