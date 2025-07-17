import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/widgets/single_todo_item.dart';

GlobalKey<AnimatedListState> animatedKey = GlobalKey();

class SearchScreen extends ConsumerStatefulWidget {
  SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  initState() {
    super.initState();
    // Scroll animato alla posizione di oggi (indice 60)
    searchController.text = ref.read(searchProvider);
  }

  @override
  dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildSearch() {
    return Consumer(
      builder: (context, ref, child) {
        final search = ref.watch(searchProvider);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              labelText: 'Cerca',

              hintText: 'Cerca un task',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              ref.read(searchProvider.notifier).update((state) => value);
            },
          ),
        );
      },
    );
  }

  Widget buildTaskList(List<Todo> todos) {
    return todos.isEmpty
        ? Container()
        : AnimatedList.separated(
              separatorBuilder:
                  (context, index, animation) => SizedBox(height: 5),
              removedSeparatorBuilder:
                  (context, index, animation) => SizedBox(height: 5),
              key: animatedKey,
              initialItemCount: todos.length,
              itemBuilder: (context, index, animation) {
                return SingleTodoItem(
                  todo: todos[index],
                  animation: animation,
                  searchMode: true,
                  index: index,
                  time: DateTime.now(),
                );
              },
            )
            .animate() // flutter_animate
            .slideY(
              begin: 0.3,
              end: 0,
              duration: 750.ms,
              curve: Curves.fastOutSlowIn,
            )
            .fade(duration: 750.ms, curve: Curves.fastOutSlowIn);
  }

  Widget buildResults() {
    return Consumer(
      builder: (context, ref, child) {
        final todos = ref.watch(
          todoListFutureProvider(ref.watch(searchProvider)),
        );
        return todos.when(
          data: (data) => buildTaskList(data),
          error: (error, stack) => Center(child: Text('Errore: $error')),
          loading: () => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [buildSearch(), Expanded(child: buildResults())]);
    ;
  }
}
