import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/utils/utils.dart';

Future<CategoryModel?> getCategoryFromModal(
  BuildContext context,
  CategoryModel item,
  GlobalKey<FormState> fomrKey,
) async {
  return await showModalBottomSheet<CategoryModel>(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BottomSheetCategory(item: item, formKey: fomrKey);
    },
  );
}

class BottomSheetCategory extends StatelessWidget {
  CategoryModel item;
  GlobalKey<FormState> formKey;
  BottomSheetCategory({super.key, required this.item, required this.formKey});

  @override
  Widget build(BuildContext context) {
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
              key: formKey,
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
                                      formNotifier.setColor(colorToHex(temp));
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

                          width: 150,
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
                            if (formKey.currentState!.validate()) {
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
  }
}
