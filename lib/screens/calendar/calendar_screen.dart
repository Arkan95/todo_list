import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/categoryTasksProgress.dart';
import 'package:todo_list/widgets/scrollDateWidget.dart';
import 'package:todo_list/widgets/single_todo_item.dart';

GlobalKey<AnimatedListState> animatedKey = GlobalKey();

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  Widget buildCategories(List<Todo> todos) {
    return SizedBox(
      height: 130,
      child: Consumer(
        builder: (context, WidgetRef ref, child) {
          var listCategories = ref.watch(categoriesFutureProvider);
          return listCategories.when(
            loading: () => Center(child: const CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
            data: (categories) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 5),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryTasksProgress(
                    todos:
                        todos
                            .where(
                              (element) =>
                                  element.categoryId == categories[index].id,
                            )
                            .toList(),
                    category: categories[index],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildTaskList(List<Todo> todos, DateTime selectedDate) {
    return todos.isEmpty
        ? Container(child: Text("Nessun Task da fare"))
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
                  index: index,
                  time: selectedDate,
                  deleting: (values, index) async {
                    animatedKey.currentState!.removeItem(
                      index,
                      (context, animation) => SingleTodoItem(
                        index: values[0] as int,
                        todo: values[1] as Todo,
                        animation: animation,
                        time: selectedDate,
                      ),
                    );
                    // Mostra SnackBar nel contesto principale (valido)
                    showUndoSnackbar(
                      context,
                      values[1] as Todo,
                      selectedDate,
                      index,
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
            .fade(duration: 750.ms, curve: Curves.fastOutSlowIn);
  }

  void showUndoSnackbar(
    BuildContext context,
    Todo todo,
    DateTime time,
    int index,
  ) async {
    final container = ProviderScope.containerOf(context);
    _scaffoldMessenger?.clearSnackBars();
    _scaffoldMessenger?.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: hexToColor('#F4F6FA')),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Task eliminato',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await container
                      .read(todoListProvider(time).notifier)
                      .addTodo(todo, isUndo: index);
                  animatedKey.currentState?.insertItem(index);
                  _scaffoldMessenger?.hideCurrentSnackBar();
                },
                child: const Text('Annulla'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = ref.watch(selectedDateProvider);
    final todos = ref.watch(todoListProvider(dateProvider));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SizedBox(height: 130, child: ScrollDateWidget()),
          buildCategories(todos),

          Expanded(child: buildTaskList(todos, dateProvider)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await context.push('/editTodo', extra: Todo());
          if (res != null) {
            final added = await ref
                .read(todoListProvider(dateProvider).notifier)
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
