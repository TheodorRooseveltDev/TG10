import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

/// User progress for a specific question
@JsonSerializable()
class UserProgress extends Equatable {
  /// Unique identifier
  final String id;

  /// Question ID this progress refers to
  final String questionId;

  /// Whether the question was answered correctly
  final bool answeredCorrectly;

  /// Timestamp when the question was answered
  final DateTime timestamp;

  /// Time taken to answer the question (in seconds)
  final int timeTaken;

  /// Selected answer index
  final int selectedAnswerIndex;

  /// User ID (for future multi-user support)
  final String? userId;

  const UserProgress({
    required this.id,
    required this.questionId,
    required this.answeredCorrectly,
    required this.timestamp,
    required this.timeTaken,
    required this.selectedAnswerIndex,
    this.userId,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  /// Convert to database map
  Map<String, dynamic> toDatabase() => {
        'id': id,
        'question_id': questionId,
        'answered_correctly': answeredCorrectly ? 1 : 0,
        'timestamp': timestamp.toIso8601String(),
        'time_taken': timeTaken,
        'selected_answer_index': selectedAnswerIndex,
        'user_id': userId,
      };

  /// Create from database map
  factory UserProgress.fromDatabase(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'] as String,
      questionId: map['question_id'] as String,
      answeredCorrectly: (map['answered_correctly'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
      timeTaken: map['time_taken'] as int,
      selectedAnswerIndex: map['selected_answer_index'] as int,
      userId: map['user_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        questionId,
        answeredCorrectly,
        timestamp,
        timeTaken,
        selectedAnswerIndex,
        userId,
      ];

  UserProgress copyWith({
    String? id,
    String? questionId,
    bool? answeredCorrectly,
    DateTime? timestamp,
    int? timeTaken,
    int? selectedAnswerIndex,
    String? userId,
  }) {
    return UserProgress(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      answeredCorrectly: answeredCorrectly ?? this.answeredCorrectly,
      timestamp: timestamp ?? this.timestamp,
      timeTaken: timeTaken ?? this.timeTaken,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
      userId: userId ?? this.userId,
    );
  }
}

/// Statistics for a user's overall progress
class UserStatistics extends Equatable {
  /// Total number of questions attempted
  final int totalQuestions;

  /// Number of correct answers
  final int correctAnswers;

  /// Number of incorrect answers
  final int incorrectAnswers;

  /// Accuracy percentage
  final double accuracy;

  /// Total time spent (in seconds)
  final int totalTime;

  /// Average time per question (in seconds)
  final double averageTime;

  /// Progress by category
  final Map<String, CategoryProgress> categoryProgress;

  /// Current streak
  final int currentStreak;

  /// Best streak
  final int bestStreak;

  /// Total exams taken
  final int totalExams;

  /// Exams passed
  final int examsPassed;

  const UserStatistics({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.accuracy,
    required this.totalTime,
    required this.averageTime,
    required this.categoryProgress,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalExams,
    required this.examsPassed,
  });

  @override
  List<Object?> get props => [
        totalQuestions,
        correctAnswers,
        incorrectAnswers,
        accuracy,
        totalTime,
        averageTime,
        categoryProgress,
        currentStreak,
        bestStreak,
        totalExams,
        examsPassed,
      ];
}

/// Progress for a specific category
class CategoryProgress extends Equatable {
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;
  final bool isMastered; // 90%+ accuracy

  const CategoryProgress({
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
    required this.isMastered,
  });

  @override
  List<Object?> get props =>
      [category, totalQuestions, correctAnswers, accuracy, isMastered];
}
