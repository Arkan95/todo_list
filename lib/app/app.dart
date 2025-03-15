import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/app/providers/todo_provider.dart';
import 'package:todo_list/app/routes/app_routes.dart';
import 'package:todo_list/app/screens/todo_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final databaseInitialization = ref.watch(todoDaoProvider);

    return databaseInitialization.when(
      loading:
          () => const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          ),
      error:
          (error, stack) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Errore durante l\'inizializzazione del database: $error',
                ),
              ),
            ),
          ),
      data:
          (_) => MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
          ),
    );
  }
}
