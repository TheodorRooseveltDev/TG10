// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: (json['id'] as num).toInt(),
  category: json['category'] as String,
  questionText: json['questionText'] as String,
  imagePath: json['imagePath'] as String?,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIndex: (json['correctIndex'] as num).toInt(),
  explanation: json['explanation'] as String,
  difficulty: json['difficulty'] as String,
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'questionText': instance.questionText,
  'imagePath': instance.imagePath,
  'options': instance.options,
  'correctIndex': instance.correctIndex,
  'explanation': instance.explanation,
  'difficulty': instance.difficulty,
};
