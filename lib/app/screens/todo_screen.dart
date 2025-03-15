import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/app/providers/todo_provider.dart';
import 'package:todo_list/app/screens/calendar/calendar_screen.dart';
import 'package:todo_list/app/screens/daily/dailyScreen.dart';
import 'package:todo_list/app/screens/search/search_screen.dart';
import 'package:todo_list/app/widgets/myDrawer.dart';
import 'package:todo_list/app/widgets/scrollDateWidget.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

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

      floatingActionButton:
          index != 2
              ? FloatingActionButton(onPressed: () {}, child: Icon(Icons.add))
              : Container(),
    );
  }
}
