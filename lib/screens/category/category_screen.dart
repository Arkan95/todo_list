import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/screens/category/single_category_item.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/bottomSheet.dart';
import 'package:todo_list/widgets/dialogYesNo.dart';
import 'package:todo_list/widgets/myDrawer.dart';

class CategoryScreen extends ConsumerWidget {
  CategoryScreen({super.key});

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
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
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
                      : AnimatedList.separated(
                            separatorBuilder:
                                (context, index, animation) =>
                                    SizedBox(height: 5),
                            removedSeparatorBuilder:
                                (context, index, animation) =>
                                    SizedBox(height: 5),
                            key:
                                ref
                                    .watch(categoryListProvider.notifier)
                                    .animatedKey,
                            initialItemCount: categorie.length,
                            itemBuilder: (context, index, animation) {
                              return SingleCategoryItem(
                                category: categorie[index],
                                animation: animation,
                                index: index,
                              );
                            },
                          )
                          .animate() // flutter_animate
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 750.ms,
                            curve: Curves.fastOutSlowIn,
                          )
                          .fade(duration: 750.ms, curve: Curves.fastOutSlowIn),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          var res = await getCategoryFromModal(
            context,
            CategoryModel(),
            formKey,
          );
          if (res != null) {
            await ref.read(categoryListProvider.notifier).addCategory(res);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
