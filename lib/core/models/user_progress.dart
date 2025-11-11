import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_progress.freezed.dart';
part 'user_progress.g.dart';

@freezed
@JsonSerializable()
class UserProgress with _$UserProgress {
  const factory UserProgress({
    int? id,
    required int questionId,
    required bool answeredCorrectly,
    required DateTime timestamp,
    required int timeTaken, // in seconds
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    // Handle boolean field - can be int (from DB) or bool (from JSON)
    if (json['answeredCorrectly'] is int) {
      json = Map<String, dynamic>.from(json);
      json['answeredCorrectly'] = json['answeredCorrectly'] == 1;
    }
    return _$UserProgressFromJson(json);
  }
}

// Extension for database operations
extension UserProgressDbExtension on UserProgress {
  static Map<String, dynamic> toJsonForDb(UserProgress progress) {
    final json = _$UserProgressToJson(progress);
    json['answeredCorrectly'] = progress.answeredCorrectly ? 1 : 0;
    return json;
  }
}
