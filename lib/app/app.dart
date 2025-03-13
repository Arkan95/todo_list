import 'package:flutter/material.dart';
import 'package:todo_list/app/screens/todo_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoScreen(),
    );
  }
}
