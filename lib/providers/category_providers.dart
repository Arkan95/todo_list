import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/database_providers.dart';
import 'package:todo_list/repositories/category_repository.dart';

class CategoriesListNotifier extends StateNotifier<List<CategoryModel>> {
  final CategoryRepository repository;

  CategoriesListNotifier(this.repository) : super([]) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    
    final categories = await repository.fetchCategories();
    state = categories;
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      await repository.addCategory(category);
      
      return true;
    } catch (_) {
      return false;
    }
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return CategoryRepository(dbHelper);
});

final categoryListProvider =
    StateNotifierProvider<CategoriesListNotifier, List<CategoryModel>>((ref) {
      final repository = ref.read(categoryRepositoryProvider);
      return CategoriesListNotifier(repository);
    });

//***************/

class CategoryNotifier extends StateNotifier<CategoryModel> {
  CategoryNotifier(CategoryModel model) : super(model);

  void setTitle(String title) {
    var temp = state.copyWith(title: title);
    state = temp;
  }

  void setColor(String colorhex) {
    var temp = state.copyWith(colorHex: colorhex);
    state = temp;
  }
}

final categoryProvider = StateNotifierProvider.autoDispose
    .family<CategoryNotifier, CategoryModel, CategoryModel>(
      (ref, model) => CategoryNotifier(model),
    );

/* final categoryFormProvider = StateNotifierProvider
    .autoDispose //autoDispose serve a eliminare automaticamente il provider quando non utilizzato
    .family // Consente di passare un modello iniziale, fondamentale per l'editing di una categoria già esistente
    <CategoryNotifier, CategoryModel, CategoryModel>((ref, initialCategory) {
      final notifier = CategoryNotifier(initialCategory);
      ref.keepAlive;
      return notifier;
    }); */
