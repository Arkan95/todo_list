import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/providers/todo_providers.dart';

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider(DateTime.now()));
    return Column(
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
                            (context, index, animation) => SizedBox(height: 5),
                        removedSeparatorBuilder:
                            (context, index, animation) => SizedBox(height: 5),
                        key:
                            ref
                                .watch(
                                  todoListProvider(DateTime.now()).notifier,
                                )
                                .animatedKey,
                        initialItemCount: todos.length,
                        itemBuilder: (context, index, animation) {
                          /* return SingleCategoryItem(
                            category: categorie[index],
                            animation: animation,
                            index: index,
                          ); */
                          return Container(height: 70, color: Colors.red);
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
    );
  }
}
