import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/database_providers.dart';
import 'package:todo_list/repositories/todo_repository.dart';

// Classe che estende StateNotifier per gestire la lista di Todo come stato.
// Questo notifier si occupa di caricare, aggiungere (e in futuro aggiornare/eliminare) i Todo.
class TodoListNotifier extends StateNotifier<List<Todo>> {
  final TodoRepository repository;
  DateTime time;

  // Costruttore che accetta il repository e inizializza lo stato con una lista vuota.
  // Viene invocato loadTodos() per caricare i Todo appena il notifier viene creato.
  TodoListNotifier(this.repository, this.time) : super([]) {
    loadTodos();
  }

  // Metodo asincrono per caricare i Todo dal repository.
  // Una volta ottenuti i Todo, lo stato viene aggiornato con la lista recuperata.
  Future<void> loadTodos() async {
    state = await repository.fetchTodos(time);
  }

  Future<List<Todo>> getTodos() async {
    await loadTodos();
    return state;
  }

  // Metodo asincrono per aggiungere un nuovo Todo.
  // Dopo aver aggiunto il Todo al repository, si richiama loadTodos() per aggiornare lo stato.
  Future<bool> addTodo(Todo todo, {int? isUndo}) async {
    try {
      int res = await repository.addTodo(todo);
      if (res != 0) {
        todo.id = res;
        if (isUndo != null) {
          var todos = [...state];
          todos.insert(isUndo, todo);
          state = todos;
        } else {
          //updateTodos.sort((a,b)=>a.date!.compareTo(b.date!));
          final updateTodos = [...state, todo];
          state = updateTodos;
        }

        return true;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // I metodi per l'aggiornamento (update) e la cancellazione (delete) dei Todo
  Future<bool> updateTodo(Todo todo) async {
    if (await repository.updateTodo(todo)) {
      state = await getTodos();
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> deleteTodo(int id) async {
    int index = state.indexWhere((element) => element.id == id);
    Todo deletingCategory = state.firstWhere((element) => element.id == id);
    bool res = await repository.deleteTodo(id);
    if (res) {
      loadTodos();

      return [index, deletingCategory];
    } else {
      return [];
    }
  }

  // dovrebbero essere implementati seguendo una logica simile: modificare il repository
  // e poi aggiornare lo stato ricaricando la lista.
}

class TodoNotifier extends StateNotifier<Todo> {
  TodoNotifier(Todo todo) : super(todo);

  void setTitle(String title) {
    var temp = state.copyWith(title: title);
    state = temp;
  }

  void setIsCompleted(bool iscompleted) {
    var temp = state.copyWith(isCompleted: iscompleted);
    state = temp;
  }

  void setDate(DateTime date) {
    var temp = state.copyWith(date: date);
    state = temp;
  }

  void setCategory(int category) {
    var temp = state.copyWith(categoryId: category);
    state = temp;
  }
}

final bounceTriggerProvider = StateProvider<bool>((ref) => false);

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return TodoRepository(dbHelper);
});

final todoProvider = StateNotifierProvider.autoDispose
    .family<TodoNotifier, Todo, Todo>((ref, model) => TodoNotifier(model));

// Provider che collega il TodoListNotifier allo stato (una lista di Todo).
// Questo provider permette all'intera applicazione di accedere e gestire la lista dei Todo.
final todoListProvider =
    StateNotifierProvider.family<TodoListNotifier, List<Todo>, DateTime>((
      ref,
      time,
    ) {
      final repository = ref.read(todoRepositoryProvider);
      return TodoListNotifier(repository, time);
    });

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
