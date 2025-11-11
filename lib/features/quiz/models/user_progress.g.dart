// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
  id: json['id'] as String,
  questionId: json['questionId'] as String,
  answeredCorrectly: json['answeredCorrectly'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
  timeTaken: (json['timeTaken'] as num).toInt(),
  selectedAnswerIndex: (json['selectedAnswerIndex'] as num).toInt(),
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'answeredCorrectly': instance.answeredCorrectly,
      'timestamp': instance.timestamp.toIso8601String(),
      'timeTaken': instance.timeTaken,
      'selectedAnswerIndex': instance.selectedAnswerIndex,
      'userId': instance.userId,
    };
