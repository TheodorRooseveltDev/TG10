import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

/// Question model representing a driving test question
@JsonSerializable()
class Question extends Equatable {
  /// Unique identifier for the question
  final String id;

  /// Category/topic of the question
  final String category;

  /// The question text
  final String questionText;

  /// Optional image URL or asset path for the question
  final String? imageUrl;

  /// List of possible answer options
  final List<String> options;

  /// Index of the correct answer in the options list
  final int correctIndex;

  /// Explanation shown after answering
  final String explanation;

  /// Difficulty level: 'easy', 'medium', 'hard'
  final String difficulty;

  /// Translations for the question in different languages
  /// Map of language code to translated question text
  final Map<String, QuestionTranslation> translations;

  const Question({
    required this.id,
    required this.category,
    required this.questionText,
    this.imageUrl,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
    this.translations = const {},
  });

  /// Factory constructor for creating a Question from JSON
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  /// Convert Question to JSON
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  /// Get the correct answer text
  String get correctAnswer => options[correctIndex];

  /// Check if a given answer index is correct
  bool isCorrect(int answerIndex) => answerIndex == correctIndex;

  /// Get translated question text for a specific language
  String getTranslatedQuestion(String languageCode) {
    return translations[languageCode]?.questionText ?? questionText;
  }

  /// Get translated options for a specific language
  List<String> getTranslatedOptions(String languageCode) {
    return translations[languageCode]?.options ?? options;
  }

  /// Get translated explanation for a specific language
  String getTranslatedExplanation(String languageCode) {
    return translations[languageCode]?.explanation ?? explanation;
  }

  @override
  List<Object?> get props => [
        id,
        category,
        questionText,
        imageUrl,
        options,
        correctIndex,
        explanation,
        difficulty,
        translations,
      ];

  Question copyWith({
    String? id,
    String? category,
    String? questionText,
    String? imageUrl,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    String? difficulty,
    Map<String, QuestionTranslation>? translations,
  }) {
    return Question(
      id: id ?? this.id,
      category: category ?? this.category,
      questionText: questionText ?? this.questionText,
      imageUrl: imageUrl ?? this.imageUrl,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      translations: translations ?? this.translations,
    );
  }
}

/// Translation data for a question
@JsonSerializable()
class QuestionTranslation extends Equatable {
  final String questionText;
  final List<String> options;
  final String explanation;

  const QuestionTranslation({
    required this.questionText,
    required this.options,
    required this.explanation,
  });

  factory QuestionTranslation.fromJson(Map<String, dynamic> json) =>
      _$QuestionTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionTranslationToJson(this);

  @override
  List<Object?> get props => [questionText, options, explanation];
}
