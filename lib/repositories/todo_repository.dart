//Questa repository funge da interfaccia tra il database e il resto dell'applicazione

import 'package:todo_list/database/database_helper.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/todo_model.dart';

class TodoRepository {
  final DatabaseHelper dbHelper;

  TodoRepository(this.dbHelper);

  Future<List<Todo>> fetchTodos(DateTime time) => dbHelper.getTodos(time);
  Future<List<Todo>> fetchTodosFromSearch(String search) =>
      dbHelper.getTodosFromSearch(search);
  Future<int> addTodo(Todo todo) => dbHelper.insertTodo(todo);
  Future<bool> updateTodo(Todo todo) => dbHelper.updateTodo(todo);
  Future<bool> deleteTodo(int id) => dbHelper.deleteTodo(id);
}
