import 'package:flutter/material.dart';
import 'package:todo_list/widgets/scrollDateWidget.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SizedBox(height: 130, child: Scrolldatewidget()),
          Container(color: Colors.green, height: 100),
          SizedBox(height: 5),
          Expanded(
            child: ListView.separated(
              itemBuilder:
                  (context, int) => Container(height: 80, color: Colors.blue),
              separatorBuilder:
                  (context, int) =>
                      const Divider(color: Colors.transparent, height: 5),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
