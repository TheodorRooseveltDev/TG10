import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../database/database_helper.dart';

part 'database_provider.g.dart';

@riverpod
DatabaseHelper databaseHelper(DatabaseHelperRef ref) {
  return DatabaseHelper.instance;
}
