import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/providers/app_routes.dart';
import 'package:todo_list/screens/todo_screen.dart';

final DateTime now = DateTime.now();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider);
    initNotifications();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      // Controlla e notifica i task ogni minuto
      checkAndNotifyTasks(ref);
    });
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

// 1. Inizializza le notifiche
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

// 2. Mostra una notifica
void showNotification(String title) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'todo_channel',
    'ToDo Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails generalNotificationDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    "Hai una cosa da fare",
    title,
    generalNotificationDetails,
  );
}

void checkAndNotifyTasks(WidgetRef ref) async {
  // Recupera i task dal DB (presupponendo che tu abbia un metodo già pronto)

  final todos = ref.watch(todoListProvider(now));

  for (var task in todos) {
    // Se la scadenza è entro sk.title1 minuto, mostra notifica
    showNotification(task.title!);
    if (task.date != null &&
        task.date!.isAfter(now) &&
        task.date!.isBefore(now.add(Duration(minutes: 5)))) {
      print("Suca");
      showNotification(task.title!);
    }
  }
}
