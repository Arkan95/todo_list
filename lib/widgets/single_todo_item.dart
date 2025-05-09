import 'package:animated_line_through/animated_line_through.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/providers/other_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/screens/daily/dailyScreen.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/bottomSheet.dart';
import 'package:todo_list/widgets/dialogYesNo.dart';

class SingleTodoItem extends ConsumerStatefulWidget {
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

  Widget buildTitle(WidgetRef ref, Todo todoState) {
    return AnimatedLineThrough(
      duration: const Duration(milliseconds: 250),
      isCrossed: todoState.isCompleted ?? false,
      curve: Curves.easeInOut,
      strokeWidth: 1.5,
      child: Text(todoState.title!, style: TextStyle(fontSize: 21)),
    );
  }

  Widget buildLeading(WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        todo.isCompleted = !(todo.isCompleted!);
        ref.watch(bounceButtonProvider.notifier).toggleBounce();

        await ref.read(todoListProvider(time).notifier).updateTodo(todo);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBouncing = ref.watch(bounceButtonProvider);
    return SafeArea(
      child: AnimatedScale(
        scale: isBouncing ? 1.2 : 1.0,
        duration: Duration(milliseconds: 150),
        curve: Curves.elasticOut, // Effetto elastico per il rimbalzo
        child: Container(
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
                  var res = await context.push(
                    '/editTodo',
                    extra: ref.watch(todoProvider(todo)),
                  );
                  if (res != null) {
                    final added = await ref
                        .read(todoListProvider(time).notifier)
                        .updateTodo(res as Todo);
                  }
                },
                child: Center(
                  child: ListTile(
                    leading: buildLeading(ref),
                    title: buildTitle(ref, todo),
                    trailing: buildDelete(ref),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
