import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/providers/app_routes.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var route = ref.read(appRouterProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: Icon(Icons.menu),
            title: const Text('Menu principale'),
            onTap: () {
              route.go('/');
              /* if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              } */

              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: const Text('Categorie'),
            onTap: () {
              route.push('/category');
              //context.go('/category');
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Impostazioni'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
