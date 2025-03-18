import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/widgets/myDrawer.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  Future<CategoryModel?> getCategoryFromModal(BuildContext context) async {
    return showModalBottomSheet<CategoryModel>(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                spacing: 10,
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) {},
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Descrizione'),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            ElevatedButton(
                              child: const Text('Annulla'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: const Text('Salva'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorie = ref.read(categoryListProvider);
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
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Categorie",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categorie.length,
                itemBuilder:
                    (context, index) => Container(
                      color: Colors.amber,
                      height: 80,
                      child: Text(categorie[index].title ?? ""),
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          CategoryModel? res = await getCategoryFromModal(context);
          if (res != null) print(res);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
