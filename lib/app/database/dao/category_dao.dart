import 'package:sqflite/sqflite.dart';
import 'package:todo_list/app/database/models/category_model.dart';

class CategoryDao {
  Database db;
  CategoryDao(this.db);

  Future<void> insertCategory(CategoryModel category) async {
    await db.insert(
      'category',
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CategoryModel>> getCategories() async {
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return CategoryModel.fromJson(maps[i]);
    });
  }

  Future<void> updateCategory(CategoryModel category) async {
    await db.update(
      'category',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    await db.delete('todos', where: 'id = ?');
  }
}
