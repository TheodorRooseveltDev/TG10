import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/question.dart';
import 'database_provider.dart';

part 'questions_provider.g.dart';

@riverpod
Future<List<Question>> allQuestions(AllQuestionsRef ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getAllQuestions();
}

@riverpod
Future<List<Question>> questionsByCategory(QuestionsByCategoryRef ref, String category) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getQuestionsByCategory(category);
}

@riverpod
Future<List<Question>> questionsByDifficulty(QuestionsByDifficultyRef ref, String difficulty) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getQuestionsByDifficulty(difficulty);
}

@riverpod
Future<Question?> questionById(QuestionByIdRef ref, int id) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getQuestionById(id);
}
