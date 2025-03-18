import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/screens/category/category_screen.dart';
import 'package:todo_list/screens/todo_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const TodoScreen()),
      GoRoute(path: '/profile', builder: (context, state) => Container()),
      GoRoute(path: '/category', builder: (context, state) => CategoryScreen()),
    ],
  );
});
//context.go('/todos');
