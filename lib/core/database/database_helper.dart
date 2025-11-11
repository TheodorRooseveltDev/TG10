import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/question.dart';
import '../models/user_progress.dart';
import '../models/streak.dart';
import '../models/achievement.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chick_road.db');
    
    // Check if questions need to be loaded
    await _ensureQuestionsLoaded();
    
    return _database!;
  }

  Future<void> _ensureQuestionsLoaded() async {
    if (_database == null) return;
    
    final count = await _database!.rawQuery('SELECT COUNT(*) as count FROM questions');
    final questionCount = count.first['count'] as int;
    
    if (questionCount == 0) {
      await _loadQuestionsFromJson(_database!);
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    // Questions table
    await db.execute('''
      CREATE TABLE questions (
        id $idType,
        category $textType,
        questionText $textType,
        imagePath TEXT,
        options $textType,
        correctIndex $integerType,
        explanation $textType,
        difficulty $textType
      )
    ''');

    // User progress table
    await db.execute('''
      CREATE TABLE user_progress (
        id $idType,
        questionId $integerType,
        answeredCorrectly $boolType,
        timestamp $textType,
        timeTaken $integerType,
        FOREIGN KEY (questionId) REFERENCES questions (id)
      )
    ''');

    // Streaks table
    await db.execute('''
      CREATE TABLE streaks (
        id $idType,
        date $textType UNIQUE,
        completed $boolType
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        title $textType,
        description $textType,
        category $textType,
        iconPath $textType,
        targetValue $integerType,
        currentValue INTEGER DEFAULT 0,
        isUnlocked INTEGER DEFAULT 0,
        unlockedAt TEXT
      )
    ''');

    // User settings table
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        isFirstLaunch $boolType DEFAULT 1,
        userAge INTEGER,
        preferredDifficulty TEXT DEFAULT 'medium',
        timerEnabled $boolType DEFAULT 1,
        questionsPerSession INTEGER DEFAULT 20,
        hapticFeedbackEnabled $boolType DEFAULT 1,
        notificationsEnabled $boolType DEFAULT 1
      )
    ''');

    // Insert default settings
    await db.insert('user_settings', {
      'id': 1,
      'isFirstLaunch': 1,
      'preferredDifficulty': 'medium',
      'timerEnabled': 1,
      'questionsPerSession': 20,
      'hapticFeedbackEnabled': 1,
      'notificationsEnabled': 1,
    });

    // Populate default achievements
    await _populateAchievements(db);
    
    // Load questions from JSON file
    await _loadQuestionsFromJson(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < 2) {
      // Version 2: Reload questions from the new questions_100.json file
      // Delete all existing questions
      await db.delete('questions');
      // Load new questions
      await _loadQuestionsFromJson(db);
    }
  }

  Future<void> _populateAchievements(Database db) async {
    final achievements = [
      {
        'id': 'streak_7',
        'title': '7-Day Warrior',
        'description': 'Complete 7 days in a row',
        'category': 'streak',
        'iconPath': 'assets/images/achievements/streak_7.png',
        'targetValue': 7,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'streak_30',
        'title': 'Monthly Champion',
        'description': 'Complete 30 days in a row',
        'category': 'streak',
        'iconPath': 'assets/images/achievements/streak_30.png',
        'targetValue': 30,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'streak_100',
        'title': 'Century Master',
        'description': 'Complete 100 days in a row',
        'category': 'streak',
        'iconPath': 'assets/images/achievements/streak_100.png',
        'targetValue': 100,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'accuracy_80',
        'title': 'Skilled Driver',
        'description': 'Achieve 80% overall accuracy',
        'category': 'accuracy',
        'iconPath': 'assets/images/achievements/accuracy_80.png',
        'targetValue': 80,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'accuracy_90',
        'title': 'Expert Navigator',
        'description': 'Achieve 90% overall accuracy',
        'category': 'accuracy',
        'iconPath': 'assets/images/achievements/accuracy_90.png',
        'targetValue': 90,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'accuracy_100',
        'title': 'Perfect Driver',
        'description': 'Achieve 100% on any quiz',
        'category': 'accuracy',
        'iconPath': 'assets/images/achievements/accuracy_100.png',
        'targetValue': 100,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'topic_master',
        'title': 'Topic Master',
        'description': 'Complete all 10 topics',
        'category': 'completion',
        'iconPath': 'assets/images/achievements/topic_master.png',
        'targetValue': 10,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'speed_demon',
        'title': 'Speed Demon',
        'description': 'Complete quiz under 5 minutes',
        'category': 'speed',
        'iconPath': 'assets/images/achievements/speed_demon.png',
        'targetValue': 300,
        'currentValue': 0,
        'isUnlocked': 0,
      },
      {
        'id': 'perfect_exam',
        'title': 'Perfect Exam',
        'description': 'Score 100% on exam mode',
        'category': 'exam',
        'iconPath': 'assets/images/achievements/perfect_exam.png',
        'targetValue': 100,
        'currentValue': 0,
        'isUnlocked': 0,
      },
    ];

    for (final achievement in achievements) {
      await db.insert('achievements', achievement);
    }
  }

  Future<void> _loadQuestionsFromJson(Database db) async {
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/data/questions_100.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      
      // Insert each question into the database
      for (final questionData in jsonData) {
        final question = Question.fromJson(questionData as Map<String, dynamic>);
        await db.insert('questions', QuestionDbExtension.toJsonForDb(question));
      }
    } catch (e) {
      // If the file doesn't exist or there's an error, just continue
      // The app will work without pre-populated questions
      print('Error loading questions from JSON: $e');
    }
  }

  // Question CRUD operations
  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('questions', QuestionDbExtension.toJsonForDb(question));
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    final result = await db.query('questions');
    return result.map((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> getQuestionsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'questions',
      where: 'category = ?',
      whereArgs: [category],
    );
    return result.map((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> getQuestionsByDifficulty(String difficulty) async {
    final db = await database;
    final result = await db.query(
      'questions',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
    );
    return result.map((json) => Question.fromJson(json)).toList();
  }

  Future<Question?> getQuestionById(int id) async {
    final db = await database;
    final result = await db.query(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Question.fromJson(result.first);
  }

  // User Progress CRUD operations
  Future<int> insertUserProgress(UserProgress progress) async {
    final db = await database;
    return await db.insert('user_progress', UserProgressDbExtension.toJsonForDb(progress));
  }

  Future<List<UserProgress>> getAllUserProgress() async {
    final db = await database;
    final result = await db.query('user_progress', orderBy: 'timestamp DESC');
    return result.map((json) => UserProgress.fromJson(json)).toList();
  }

  Future<List<UserProgress>> getProgressByQuestionId(int questionId) async {
    final db = await database;
    final result = await db.query(
      'user_progress',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'timestamp DESC',
    );
    return result.map((json) => UserProgress.fromJson(json)).toList();
  }

  Future<List<UserProgress>> getIncorrectAnswers() async {
    final db = await database;
    final result = await db.query(
      'user_progress',
      where: 'answeredCorrectly = ?',
      whereArgs: [0],
      orderBy: 'timestamp DESC',
    );
    return result.map((json) => UserProgress.fromJson(json)).toList();
  }

  Future<double> getOverallAccuracy() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN answeredCorrectly = 1 THEN 1 ELSE 0 END) as correct
      FROM user_progress
    ''');

    if (result.isEmpty || result.first['total'] == 0) return 0.0;
    final total = result.first['total'] as int;
    final correct = result.first['correct'] as int;
    return (correct / total) * 100;
  }

  Future<Map<String, double>> getAccuracyByCategory() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        q.category,
        COUNT(*) as total,
        SUM(CASE WHEN up.answeredCorrectly = 1 THEN 1 ELSE 0 END) as correct
      FROM user_progress up
      JOIN questions q ON up.questionId = q.id
      GROUP BY q.category
    ''');

    final Map<String, double> categoryAccuracy = {};
    for (final row in result) {
      final category = row['category'] as String;
      final total = row['total'] as int;
      final correct = row['correct'] as int;
      categoryAccuracy[category] = (correct / total) * 100;
    }
    return categoryAccuracy;
  }

  // Streak CRUD operations
  Future<int> insertStreak(Streak streak) async {
    final db = await database;
    return await db.insert(
      'streaks',
      StreakDbExtension.toJsonForDb(streak),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Streak?> getStreakByDate(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result = await db.query(
      'streaks',
      where: 'date = ?',
      whereArgs: [dateStr],
    );
    if (result.isEmpty) return null;
    return Streak.fromJson(result.first);
  }

  Future<int> getCurrentStreakCount() async {
    final db = await database;
    final result = await db.query(
      'streaks',
      where: 'completed = ?',
      whereArgs: [1],
      orderBy: 'date DESC',
    );

    if (result.isEmpty) return 0;

    int streakCount = 0;
    DateTime currentDate = DateTime.now();

    for (final row in result) {
      final streak = Streak.fromJson(row);
      final expectedDate = currentDate.subtract(Duration(days: streakCount));
      final expectedDateStr = expectedDate.toIso8601String().split('T')[0];

      if (streak.date == expectedDateStr) {
        streakCount++;
      } else {
        break;
      }
    }

    return streakCount;
  }

  Future<List<Streak>> getAllStreaks() async {
    final db = await database;
    final result = await db.query('streaks', orderBy: 'date DESC');
    return result.map((json) => Streak.fromJson(json)).toList();
  }

  // Achievement CRUD operations
  Future<List<Achievement>> getAllAchievements() async {
    final db = await database;
    final result = await db.query('achievements', orderBy: 'isUnlocked DESC, targetValue ASC');
    return result.map((json) => Achievement.fromJson(json)).toList();
  }

  Future<Achievement?> getAchievementById(String id) async {
    final db = await database;
    final result = await db.query(
      'achievements',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Achievement.fromJson(result.first);
  }

  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;
    return await db.update(
      'achievements',
      AchievementDbExtension.toJsonForDb(achievement),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  Future<void> unlockAchievement(String id) async {
    final db = await database;
    await db.update(
      'achievements',
      {
        'isUnlocked': 1,
        'unlockedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateAchievementProgress(String id, int currentValue) async {
    final db = await database;
    await db.update(
      'achievements',
      {'currentValue': currentValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User Settings operations
  Future<Map<String, dynamic>> getUserSettings() async {
    final db = await database;
    final result = await db.query('user_settings', where: 'id = 1');
    return result.first;
  }

  Future<int> updateUserSettings(Map<String, dynamic> settings) async {
    final db = await database;
    return await db.update(
      'user_settings',
      settings,
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> completeOnboarding(int age, String difficulty) async {
    final db = await database;
    await db.update(
      'user_settings',
      {
        'isFirstLaunch': 0,
        'userAge': age,
        'preferredDifficulty': difficulty,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // Utility methods
  Future<void> deleteAllProgress() async {
    final db = await database;
    await db.delete('user_progress');
    await db.delete('streaks');
    await db.update(
      'achievements',
      {
        'currentValue': 0,
        'isUnlocked': 0,
        'unlockedAt': null,
      },
    );
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    
    final totalQuestions = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM questions'),
    ) ?? 0;
    
    final totalAnswered = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_progress'),
    ) ?? 0;
    
    final correctAnswers = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user_progress WHERE answeredCorrectly = 1'),
    ) ?? 0;
    
    final currentStreak = await getCurrentStreakCount();
    
    final unlockedAchievements = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM achievements WHERE isUnlocked = 1'),
    ) ?? 0;

    final accuracy = totalAnswered > 0 ? (correctAnswers / totalAnswered) * 100 : 0.0;

    return {
      'totalQuestions': totalQuestions,
      'totalAnswered': totalAnswered,
      'correctAnswers': correctAnswers,
      'accuracy': accuracy,
      'currentStreak': currentStreak,
      'unlockedAchievements': unlockedAchievements,
    };
  }

  // Initialize user account with starting streak
  Future<void> initializeUserAccount() async {
    final db = await database;
    
    // Check if this is a new user (no streaks exist)
    final streakCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM streaks'),
    ) ?? 0;
    
    // If no streaks exist, create the first one for today
    if (streakCount == 0) {
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      await db.insert('streaks', {
        'date': todayString,
        'completed': 1, // Mark as completed to start the streak
      });
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
