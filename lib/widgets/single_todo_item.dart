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
  void Function(List<dynamic>,int index)? deleting;
  SingleTodoItem({
    super.key,
    required this.todo,
    required this.animation,
    required this.index,
    required this.time,
    this.deleting,
  });

  @override
  ConsumerState<SingleTodoItem> createState() => _SingleTodoItemState();
}

class _SingleTodoItemState extends ConsumerState<SingleTodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_controller);
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late ProviderContainer container;



  Widget buildDelete(WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        List<dynamic> deletingTodo = await ref
            .read(todoListProvider(widget.time).notifier)
            .deleteTodo(widget.todo.id!);
        if (deletingTodo.isNotEmpty) {
          widget.deleting!(deletingTodo,widget.index);
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
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () async {
          widget.todo.isCompleted = !(widget.todo.isCompleted!);

          await ref
              .read(todoListProvider(widget.time).notifier)
              .updateTodo(widget.todo);
          _onTap();
        },
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
              parent: widget.animation,
              curve: Curves.fastOutSlowIn,
            ),
            axis: Axis.vertical,
            child: SizedBox(
              height: 70,
              child: GestureDetector(
                onLongPress: () async {
                  var res = await context.push(
                    '/editTodo',
                    extra: ref.watch(todoProvider(widget.todo)),
                  );
                  if (res != null) {
                    final added = await ref
                        .read(todoListProvider(widget.time).notifier)
                        .updateTodo(res as Todo);
                  }
                },
                child: Center(
                  child: ListTile(
                    leading: buildLeading(ref),
                    title: buildTitle(ref, widget.todo),
                    
                    trailing: Row(
                      spacing: 15,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(formatterTime.format(widget.todo.date!),style: TextStyle(fontSize: 14),),
                        buildDelete(ref),
                      ],
                    ),
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
