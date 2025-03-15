// Definiamo un provider globale
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo_list/app/database/app_database.dart';
import 'package:todo_list/app/database/dao/todo_dao.dart';
import 'package:todo_list/app/database/models/todo_model.dart';

final indexprovider = StateProvider<int>((ref) => 0);
//Provider per il DAO
final todoDaoProvider = FutureProvider<TodoDao>((ref) {
  final db = ref.watch(databaseProvider).database;
  return TodoDao(db as Database); //Da vedere se funziona
});
//Provider per il Database
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

//Provider per lo Stato delle attività
class TodoListNotifier extends StateNotifier<List<Todo>> {
  final TodoDao todoDao;

  TodoListNotifier(this.todoDao) : super([]);

  Future<void> loadTodos(DateTime time) async {
    final todos = await todoDao.getTodos(time);
    state = todos;
  }

  Future<void> addTodo(Todo todo) async {
    await todoDao.insertTodo(todo);
    await loadTodos(todo.date!);
  }

  Future<void> updateTodo(Todo todo) async {
    final updateTodo = todo.copyWith(todo);
    await todoDao.updateTodo(updateTodo);
    await loadTodos(todo.date!);
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((
  ref,
) {
  final todoDao = ref.watch(todoDaoProvider);
  return TodoListNotifier(todoDao as TodoDao);
});
