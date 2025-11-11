import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'streak.g.dart';

/// Daily streak record
@JsonSerializable()
class Streak extends Equatable {
  /// Unique identifier
  final String id;

  /// Date of the streak
  final DateTime date;

  /// Whether the day's quiz was completed
  final bool completed;

  /// Number of questions answered that day
  final int questionsAnswered;

  /// User ID (for future multi-user support)
  final String? userId;

  const Streak({
    required this.id,
    required this.date,
    required this.completed,
    this.questionsAnswered = 0,
    this.userId,
  });

  factory Streak.fromJson(Map<String, dynamic> json) =>
      _$StreakFromJson(json);

  Map<String, dynamic> toJson() => _$StreakToJson(this);

  /// Convert to database map
  Map<String, dynamic> toDatabase() => {
        'id': id,
        'date': _dateOnly(date).toIso8601String(),
        'completed': completed ? 1 : 0,
        'questions_answered': questionsAnswered,
        'user_id': userId,
      };

  /// Create from database map
  factory Streak.fromDatabase(Map<String, dynamic> map) {
    return Streak(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      completed: (map['completed'] as int) == 1,
      questionsAnswered: map['questions_answered'] as int? ?? 0,
      userId: map['user_id'] as String?,
    );
  }

  /// Helper to get date without time component
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get date without time
  DateTime get dateOnly => _dateOnly(date);

  @override
  List<Object?> get props => [id, dateOnly, completed, questionsAnswered, userId];

  Streak copyWith({
    String? id,
    DateTime? date,
    bool? completed,
    int? questionsAnswered,
    String? userId,
  }) {
    return Streak(
      id: id ?? this.id,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      userId: userId ?? this.userId,
    );
  }
}

/// Streak summary information
class StreakSummary extends Equatable {
  /// Current active streak count
  final int currentStreak;

  /// Longest streak ever achieved
  final int longestStreak;

  /// Total days with activity
  final int totalActiveDays;

  /// Last active date
  final DateTime? lastActiveDate;

  /// Whether today's streak is maintained
  final bool isTodayComplete;

  /// Whether the streak is at risk (no activity today)
  final bool isAtRisk;

  const StreakSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalActiveDays,
    this.lastActiveDate,
    required this.isTodayComplete,
    required this.isAtRisk,
  });

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        totalActiveDays,
        lastActiveDate,
        isTodayComplete,
        isAtRisk,
      ];
}
