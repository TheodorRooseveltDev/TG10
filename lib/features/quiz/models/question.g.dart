// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: json['id'] as String,
  category: json['category'] as String,
  questionText: json['questionText'] as String,
  imageUrl: json['imageUrl'] as String?,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIndex: (json['correctIndex'] as num).toInt(),
  explanation: json['explanation'] as String,
  difficulty: json['difficulty'] as String,
  translations:
      (json['translations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          QuestionTranslation.fromJson(e as Map<String, dynamic>),
        ),
      ) ??
      const {},
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'questionText': instance.questionText,
  'imageUrl': instance.imageUrl,
  'options': instance.options,
  'correctIndex': instance.correctIndex,
  'explanation': instance.explanation,
  'difficulty': instance.difficulty,
  'translations': instance.translations,
};

QuestionTranslation _$QuestionTranslationFromJson(Map<String, dynamic> json) =>
    QuestionTranslation(
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$QuestionTranslationToJson(
  QuestionTranslation instance,
) => <String, dynamic>{
  'questionText': instance.questionText,
  'options': instance.options,
  'explanation': instance.explanation,
};
