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
  GlobalKey<AnimatedListState> animatedKey = GlobalKey();

  // Costruttore che accetta il repository e inizializza lo stato con una lista vuota.
  // Viene invocato loadTodos() per caricare i Todo appena il notifier viene creato.
  TodoListNotifier(this.repository, this.time) : super([]) {
    loadTodos();
  }

  // Metodo asincrono per caricare i Todo dal repository.
  // Una volta ottenuti i Todo, lo stato viene aggiornato con la lista recuperata.
  Future<void> loadTodos() async {
    final todos = await repository.fetchTodos(time);
    state = todos;
  }

  // Metodo asincrono per aggiungere un nuovo Todo.
  // Dopo aver aggiunto il Todo al repository, si richiama loadTodos() per aggiornare lo stato.
  Future<bool> addTodo(Todo todo) async {
    int res = await repository.addTodo(todo);
    if (res != 0) {
      todo.id = res;
      final updateTodos = [...state, todo];
      state = updateTodos;
      int newIndex = state.length - 1;
      animatedKey.currentState!.insertItem(
        newIndex,
        duration: Duration(milliseconds: 500),
      );
      return true;
    }
    await loadTodos();
    return true;
  }

  // I metodi per l'aggiornamento (update) e la cancellazione (delete) dei Todo
  // dovrebbero essere implementati seguendo una logica simile: modificare il repository
  // e poi aggiornare lo stato ricaricando la lista.
}

class TodoNotifier extends StateNotifier<Todo> {
  TodoNotifier(Todo todo) : super(todo);

  void setDescription(String desc) {
    var temp = state.copyWith(description: desc);
    state = temp;
  }

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

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return TodoRepository(dbHelper);
});

final todoProvider = StateNotifierProvider.autoDispose
    .family<TodoNotifier, Todo, Todo>((ref, model) => TodoNotifier(model));

// Provider che collega il TodoListNotifier allo stato (una lista di Todo).
// Questo provider permette all'intera applicazione di accedere e gestire la lista dei Todo.
final todoListProvider = StateNotifierProvider.autoDispose
    .family<TodoListNotifier, List<Todo>, DateTime>((ref, time) {
      final repository = ref.read(todoRepositoryProvider);
      return TodoListNotifier(repository, time);
    });
