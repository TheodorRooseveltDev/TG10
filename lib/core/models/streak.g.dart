// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Streak _$StreakFromJson(Map<String, dynamic> json) => Streak(
  id: (json['id'] as num).toInt(),
  date: json['date'] as String,
  completed: json['completed'] as bool,
);

Map<String, dynamic> _$StreakToJson(Streak instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'completed': instance.completed,
};
