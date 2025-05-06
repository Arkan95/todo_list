import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/screens/daily/dailyScreen.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/bottomSheet.dart';
import 'package:todo_list/widgets/dialogYesNo.dart';

class SingleTodoItem extends ConsumerWidget {
  Todo todo;
  Animation<double> animation;
  int index;
  DateTime time;
  void Function(List<dynamic>)? deleting;
  SingleTodoItem({
    super.key,
    required this.todo,
    required this.animation,
    required this.index,
    required this.time,
    this.deleting,
  });

  Widget buildDelete(WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        List<dynamic> deletingTodo = await ref
            .read(todoListProvider(time).notifier)
            .deleteTodo(todo.id!);
        if (deletingTodo.isNotEmpty) {
          deleting!(deletingTodo);
        }
      },
      child: const Icon(Icons.close, color: Colors.redAccent),
    );
  }

  Widget buildTitle(WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      width:
          todo.isCompleted! ? 300 : 0, // modifica la larghezza per il clipping
      child: ClipRect(
        child: Text(
          todo.title!,
          overflow: TextOverflow.clip,
          softWrap: false,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget buildLeading(
    WidgetRef ref,
    Todo todoState,
    TodoNotifier todoNotifier,
  ) {
    return GestureDetector(
      onTap: () async {
        todoNotifier.setIsCompleted(!todoState.isCompleted!);

        await ref.read(todoListProvider(time).notifier).updateTodo(todoState);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todoState = ref.watch(todoProvider(todo));
    var todoNotifier = ref.watch(todoProvider(todo).notifier);
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
        axis: Axis.vertical,
        child: SizedBox(
          height: 70,
          child: GestureDetector(
            onTap: () async {
              var res = await context.push('/editTodo', extra: todoState);
              if (res != null) {
                final added = await ref
                    .read(todoListProvider(time).notifier)
                    .updateTodo(res as Todo);
              }
            },
            child: Center(
              child: ListTile(
                leading: buildLeading(ref, todoState, todoNotifier),
                title: buildTitle(ref),
                trailing: buildDelete(ref),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
