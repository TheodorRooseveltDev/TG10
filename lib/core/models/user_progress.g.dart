// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
  id: (json['id'] as num?)?.toInt(),
  questionId: (json['questionId'] as num).toInt(),
  answeredCorrectly: json['answeredCorrectly'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
  timeTaken: (json['timeTaken'] as num).toInt(),
);

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'answeredCorrectly': instance.answeredCorrectly,
      'timestamp': instance.timestamp.toIso8601String(),
      'timeTaken': instance.timeTaken,
    };
