import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/utils/utils.dart';

class CategoryTasksProgress extends ConsumerWidget {
  List<Todo> todos;
  CategoryModel category;
  CategoryTasksProgress({
    super.key,
    required this.todos,
    required this.category,
  });

  double getPercentual() {
    double total = todos.length.toDouble();
    if (total == 0) return 0;
    double completed =
        todos.where((el) => el.isCompleted == true).toList().length.toDouble();
    double result = (completed / total);
    return result;
  }

  String formatDouble(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    } else if ((value * 10).roundToDouble() == value * 10) {
      return value.toStringAsFixed(1);
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 100,
      width: 170,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    category.title!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${todos.length} task",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 7.0,
                  animation: true,
                  percent: getPercentual(),
                  center: Text(
                    "${formatDouble(getPercentual() * 100)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: hexToColor(category.colorHex!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
