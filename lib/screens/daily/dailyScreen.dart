import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/widgets/single_todo_item.dart';

final selectedDate = DateTime.now();
GlobalKey<AnimatedListState> animatedKey = GlobalKey();

class DailyScreen extends ConsumerWidget {
  DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider(selectedDate));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            "Cosa devi fare oggi?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          Text(
            "Categorie",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Container(color: Colors.green, height: 130),
          Text(
            "Task da fare",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          Expanded(
            child:
                todos.isEmpty
                    ? Container()
                    : AnimatedList.separated(
                          separatorBuilder:
                              (context, index, animation) =>
                                  SizedBox(height: 5),
                          removedSeparatorBuilder:
                              (context, index, animation) =>
                                  SizedBox(height: 5),
                          key: animatedKey,
                          initialItemCount: todos.length,
                          itemBuilder: (context, index, animation) {
                            return SingleTodoItem(
                              todo: todos[index],
                              animation: animation,
                              index: index,
                              time: selectedDate,
                              deleting: (values) {
                                animatedKey.currentState!.removeItem(
                                  index,
                                  (context, animation) => SingleTodoItem(
                                    index: values[0] as int,
                                    todo: values[1] as Todo,
                                    animation: animation,
                                    time: selectedDate,
                                  ),
                                );
                              },
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
                        .fade(duration: 750.ms, curve: Curves.fastOutSlowIn),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await context.push('/editTodo', extra: Todo());
          if (res != null) {
            final added = await ref
                .read(todoListProvider(selectedDate).notifier)
                .addTodo(res as Todo);
            if (added) {
              animatedKey.currentState?.insertItem(todos.length - 1);
            }
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
