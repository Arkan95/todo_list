import 'package:flutter/material.dart';
import 'package:todo_list/app/widgets/scrollDateWidget.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.search, size: 32),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: Drawer(child: Container()),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            /* 
            Text(
              "Camaffabio?",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ), */
            SizedBox(height: 130, child: Scrolldatewidget()),
            Container(color: Colors.green, height: 50),
            SizedBox(height: 5),
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
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
