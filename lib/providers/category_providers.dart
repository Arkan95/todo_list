import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/database_providers.dart';
import 'package:todo_list/repositories/category_repository.dart';
import 'package:todo_list/screens/category/single_category_item.dart';

class CategoriesListNotifier extends StateNotifier<List<CategoryModel>> {
  final CategoryRepository repository;
  GlobalKey<AnimatedListState> animatedKey = GlobalKey();
  CategoriesListNotifier(this.repository) : super([]) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = await repository.fetchCategories();
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      int res = await repository.addCategory(category);
      if (res != 0) {
        category.id = res;
        final updatedCategories = [...state, category]; // nuova lista
        state = updatedCategories; // aggiorna lo stato
        int newIndex = state.length - 1;
        animatedKey.currentState!.insertItem(
          newIndex,
          duration: Duration(milliseconds: 500),
        );

        return true;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCategory(CategoryModel category) async {
    if (await repository.updateCategory(category)) {
      loadCategories();
      return true;
    } else {
      return false;
    }
  }

  Future<(bool, String)> deleteCategory(int id) async {
    int index = state.indexWhere((element) => element.id == id);
    CategoryModel deletingCategory = state.firstWhere(
      (element) => element.id == id,
    );
    (bool, String) res = await repository.deleteCategory(id);
    if (res.$1) {
      loadCategories();
      animatedKey.currentState!.removeItem(
        index,
        (context, animation) => SingleCategoryItem(
          index: index,
          category: deletingCategory,
          animation: animation,
        ),
      );
      return res;
    } else {
      return res;
    }
  }
}

/* class KeyAnimatedListNotifier
    extends StateNotifier<GlobalKey<AnimatedListState>> {
  GlobalKey<AnimatedListState> animatedKey;

  KeyAnimatedListNotifier(this.animatedKey)
    : super(GlobalKey<AnimatedListState>());

  void setKey(GlobalKey<AnimatedListState> newKey) {
    animatedKey = newKey;
  }

  void newElement(int index) {
    animatedKey.currentState!.insertItem(index - 1);
  }

  void deleteElement(
    int index,
    CategoryModel category,
    Animation<double> animation,
  ) {
    animatedKey.currentState!.removeItem(
      index,
      (context, animation) =>
          SingleCategoryItem(category: category, animation: animation),
    );
  }
} */

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
