// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Streak _$StreakFromJson(Map<String, dynamic> json) => Streak(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  completed: json['completed'] as bool,
  questionsAnswered: (json['questionsAnswered'] as num?)?.toInt() ?? 0,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$StreakToJson(Streak instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'completed': instance.completed,
  'questionsAnswered': instance.questionsAnswered,
  'userId': instance.userId,
};
