import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/screens/category/category_screen.dart';
import 'package:todo_list/screens/todo_screen.dart';
import 'package:todo_list/widgets/editTodo.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: '/', builder: (context, state) => TodoScreen()),
      GoRoute(path: '/profile', builder: (context, state) => Container()),
      GoRoute(
        path: '/category',
        pageBuilder:
            (context, state) => pageAnimation(CategoryScreen(), state.pageKey),
      ),
      GoRoute(
        path: '/editTodo',

        pageBuilder:
            (context, state) => pageAnimation(
              EditTodo(todo: state.extra as Todo),
              state.pageKey,
              isDy: true,
            ),
      ),
    ],
  );
});
//context.go('/todos');

CustomTransitionPage pageAnimation(
  Widget screen,
  ValueKey<String> key, {
  bool? isDy,
}) {
  return CustomTransitionPage(
    child: screen,
    transitionDuration: Duration(milliseconds: 500),
    key: key,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = (isDy ?? false) ? Offset(0.0, 1.0) : Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    // Rimuovi transitionDuration!
  );
}
