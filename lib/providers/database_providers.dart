import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/database/database_helper.dart';

final indexprovider = StateProvider<int>((ref) => 0);

final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});
