import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/database_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/screens/calendar/calendar_screen.dart';
import 'package:todo_list/screens/daily/dailyScreen.dart';
import 'package:todo_list/screens/search/search_screen.dart';
import 'package:todo_list/widgets/myDrawer.dart';
import 'package:todo_list/widgets/scrollDateWidget.dart';

class TodoScreen extends ConsumerWidget {
  TodoScreen({super.key});
  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return DailyScreen();
      case 1:
        return CalendarScreen();
      case 2:
        return SearchScreen();
      default:
        return DailyScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexprovider);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int value) {
          ref.read(indexprovider.notifier).state = value;
          ref.invalidate(todoListProvider);
        },
        selectedIndex: index,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.today),
            icon: Icon(Icons.today_outlined),
            label: 'Oggi',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendario',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Cerca',
          ),
        ],
      ),
      appBar: AppBar(
        elevation: 0, // niente ombra
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.amber,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, size: 32), // Cambia l'icona qui
              onPressed: () {
                // Apri il drawer
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        child: getScreen(index),
      ),
    );
  }
}
