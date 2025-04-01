import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/dialogYesNo.dart';
import 'package:todo_list/widgets/myDrawer.dart';

class CategoryScreen extends ConsumerWidget {
  CategoryScreen({super.key});

  Future<CategoryModel?> getCategoryFromModal(
    BuildContext context,
    CategoryModel item,
  ) async {
    final _formKey = GlobalKey<FormState>();

    return await showModalBottomSheet<CategoryModel>(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Consumer(
            builder: (ctx, ref, _) {
              final formState = ref.watch(categoryProvider(item));
              final formNotifier = ref.read(categoryProvider(item).notifier);
              return SizedBox(
                height: 350,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 30, 30, 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: <Widget>[
                        TextFormField(
                          onChanged: (value) {
                            formNotifier.setTitle(value);
                          },
                          maxLength: 50,
                          initialValue: item.title,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 1 ||
                                value.trim().length > 50) {
                              return 'Il nome deve essere compreso tra 1 e 50 caratteri';
                            }
                            return null;
                          },

                          decoration: const InputDecoration(
                            label: Text('Descrizione'),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Icon(Icons.color_lens_outlined),
                          title: Text("Colore"),
                          trailing: GestureDetector(
                            onTap: () async {
                              Color temp = hexToColor(formState.colorHex!);
                              await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(18.0),
                                    title: Text("Titolo"),
                                    content: MaterialColorPicker(
                                      onColorChange: (Color color) {
                                        // Handle color changes
                                        temp = color;
                                      },
                                      selectedColor: hexToColor(
                                        formState.colorHex!,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: Navigator.of(context).pop,
                                        child: const Text('Annulla'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          formNotifier.setColor(
                                            colorToHex(temp),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Conferma'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: hexToColor(formState.colorHex!),
                              ),

                              width: 200,
                              height: 50,
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            ElevatedButton(
                              child: const Text('Annulla'),
                              onPressed: () => Navigator.pop(context, null),
                            ),
                            ElevatedButton(
                              child: const Text('Salva'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context, formState);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorie = ref.watch(categoryListProvider);
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
              child:
                  categorie.isEmpty
                      ? Container()
                      : ListView.builder(
                        itemCount: categorie.length,
                        itemBuilder: (context, index) {
                          final category = categorie[index];
                          return Dismissible(
                            confirmDismiss: (direction) async {
                              bool check = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogYesNo(
                                    title: "Vuoi eliminare la categoria?",
                                  );
                                },
                              );
                              if (check) {
                                (bool, String) res = await ref
                                    .read(categoryListProvider.notifier)
                                    .deleteCategory(category.id!);
                                if (res.$1) {
                                  return true;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(res.$2)),
                                  );
                                  return false;
                                }
                              }
                            },
                            background: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.redAccent,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            key: ValueKey<int>(category.id!),
                            child: GestureDetector(
                              onTap: () async {
                                var res = await getCategoryFromModal(
                                  context,
                                  category,
                                );
                                if (res != null) {
                                  await ref
                                      .read(categoryListProvider.notifier)
                                      .updateCategory(res);
                                }
                              },
                              child: ListTile(
                                leading: const Icon(Icons.category),
                                title: Text(category.title!),
                                trailing: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: hexToColor(category.colorHex!),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await getCategoryFromModal(context, CategoryModel());
          if (res != null) {
            await ref.read(categoryListProvider.notifier).addCategory(res);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
