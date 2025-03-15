import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
              context.go('/');
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: const Text('Categorie'),
            onTap: () {
              context.go('/category');
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
