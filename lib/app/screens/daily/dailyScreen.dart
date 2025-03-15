import 'package:flutter/material.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
