import 'package:todo_list/database/database_helper.dart';
import 'package:todo_list/models/category_model.dart';

class CategoryRepository {
  final DatabaseHelper dbHelper;
  CategoryRepository(this.dbHelper);

  Future<List<CategoryModel>> fetchCategories() => dbHelper.getCategories();
  Future<int> addCategory(CategoryModel category) =>
      dbHelper.insertCategory(category);
  Future<bool> updateCategory(CategoryModel category) =>
      dbHelper.updateCategory(category);
  Future<(bool, String)> deleteCategory(int id) => dbHelper.deleteCategory(id);
}
