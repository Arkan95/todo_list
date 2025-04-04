import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/bottomSheet.dart';
import 'package:todo_list/widgets/dialogYesNo.dart';

class SingleCategoryItem extends ConsumerWidget {
  CategoryModel category;
  Animation<double> animation;
  int index;
  SingleCategoryItem({
    super.key,
    required this.category,
    required this.animation,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
            axis: Axis.vertical,
            child: SizedBox(
              height: 70,
              /* decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ), */
              child: GestureDetector(
                onTap: () async {
                  GlobalKey<FormState> formKey = GlobalKey<FormState>();
                  var res = await getCategoryFromModal(
                    context,
                    category,
                    formKey,
                  );
                  if (res != null) {
                    await ref
                        .read(categoryListProvider.notifier)
                        .updateCategory(res);
                  }
                },
                child: Center(
                  child: ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: hexToColor(category.colorHex!),
                          width: 3,
                        ),
                      ),
                    ),
                    title: Text(category.title!),
                    trailing: GestureDetector(
                      onTap: () async {
                        bool check = await showDialog(
                          barrierDismissible: false,
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
                            //return true;
                          } else {
                            /* ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(res.$2)));
            return false; */
                          }
                        }
                      },
                      child: const Icon(Icons.close, color: Colors.redAccent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .animate() // flutter_animate
        .slideY(
          begin: index * 0.3,
          end: 0,
          duration: 750.ms,
          curve: Curves.fastOutSlowIn,
        )
        .fade(duration: 750.ms, curve: Curves.fastOutSlowIn);
  }
}
