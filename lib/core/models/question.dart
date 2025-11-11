import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
@JsonSerializable()
class Question with _$Question {
  const factory Question({
    required int id,
    required String category,
    required String questionText,
    String? imagePath,
    required List<String> options,
    required int correctIndex,
    required String explanation,
    required String difficulty,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) {
    // Handle options field - can be either String (from DB) or List (from JSON)
    if (json['options'] is String) {
      json = Map<String, dynamic>.from(json);
      json['options'] = jsonDecode(json['options'] as String);
    }
    return _$QuestionFromJson(json);
  }
}

// Extension for database operations
extension QuestionDbExtension on Question {
  static Map<String, dynamic> toJsonForDb(Question question) {
    final json = _$QuestionToJson(question);
    // Convert options list to JSON string for SQLite storage
    json['options'] = jsonEncode(question.options);
    return json;
  }
}
