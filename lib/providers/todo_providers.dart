import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/database_providers.dart';
import 'package:todo_list/repositories/todo_repository.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dbHelper = ref.read(databaseProvider);
  return TodoRepository(dbHelper);
});

// Classe che estende StateNotifier per gestire la lista di Todo come stato.
// Questo notifier si occupa di caricare, aggiungere (e in futuro aggiornare/eliminare) i Todo.
class TodoListNotifier extends StateNotifier<List<Todo>> {
  final TodoRepository repository;

  // Costruttore che accetta il repository e inizializza lo stato con una lista vuota.
  // Viene invocato loadTodos() per caricare i Todo appena il notifier viene creato.
  TodoListNotifier(this.repository) : super([]) {
    loadTodos();
  }

  // Metodo asincrono per caricare i Todo dal repository.
  // Una volta ottenuti i Todo, lo stato viene aggiornato con la lista recuperata.
  Future<void> loadTodos({DateTime? time}) async {
    final todos = await repository.fetchTodos(time ?? DateTime.now());
    state = todos;
  }

  // Metodo asincrono per aggiungere un nuovo Todo.
  // Dopo aver aggiunto il Todo al repository, si richiama loadTodos() per aggiornare lo stato.
  Future<void> addTodo(Todo todo) async {
    await repository.addTodo(todo);
    await loadTodos();
  }

  // I metodi per l'aggiornamento (update) e la cancellazione (delete) dei Todo
  // dovrebbero essere implementati seguendo una logica simile: modificare il repository
  // e poi aggiornare lo stato ricaricando la lista.
}

// Provider che collega il TodoListNotifier allo stato (una lista di Todo).
// Questo provider permette all'intera applicazione di accedere e gestire la lista dei Todo.
final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((
  ref,
) {
  final repository = ref.read(todoRepositoryProvider);
  return TodoListNotifier(repository);
});
