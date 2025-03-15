import 'package:sqflite/sqflite.dart';
import 'package:todo_list/app/database/models/todo_model.dart';
import 'package:todo_list/app/utils/utils.dart';

class TodoDao {
  Database db;
  TodoDao(this.db);

  Future<void> insertTodo(Todo todo) async {
    await db.insert(
      'todos',
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getTodos(DateTime time) async {
    String data = formatterSql.format(time);
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'DATE(dateTodo) = ?',
      whereArgs: [data],
    );
    return List.generate(maps.length, (i) {
      return Todo.fromJson(maps[i]);
    });
  }

  Future<void> updateTodo(Todo todo) async {
    await db.update(
      'todos',
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
