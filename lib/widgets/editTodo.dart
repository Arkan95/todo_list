import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/providers/category_providers.dart';
import 'package:todo_list/providers/todo_providers.dart';
import 'package:todo_list/utils/utils.dart';

class EditTodo extends ConsumerWidget {
  EditTodo({super.key, required this.todo});
  GlobalKey<FormState> formKey = GlobalKey();
  Todo todo;
  late TodoNotifier refNotifier;
  late Todo refState;
  late BuildContext ctx;
  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Scrivi qui la tua task',
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
          ),
          onChanged: (value) {
            //formNotifier.setTitle(value);
            refNotifier.setTitle(value);
          },
          maxLength: 50,
          initialValue: todo.title,
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                value.trim().length <= 1 ||
                value.trim().length > 50) {
              return 'Il titolo deve essere compreso tra 1 e 50 caratteri';
            }
            return null;
          },
        ),
        Row(
          spacing: 5,
          children: [
            buildDatePicker(),
            Expanded(child: buildDropDownCategory()),
          ],
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    return GestureDetector(
      child: Container(
        width: 180,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: hexToColor("#F4F6FA"), width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            spacing: 8,
            children: [
              Icon(Icons.calendar_month),
              Text(formatter.format(refState.date!)),
            ],
          ),
        ),
      ),
      onTap: () => _presentDatePicker(),
    );
  }

  Widget buildDropDownCategory() {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        var list = ref.watch(categoryListProvider).map((e) => e.title).toList();
        return CustomDropdown<String?>(
          hintText: 'Select job role',
          decoration: CustomDropdownDecoration(
            closedBorderRadius: BorderRadius.circular(30),
            closedBorder: Border.all(width: 3, color: hexToColor("#F4F6FA")),
          ),
          items: list,
          initialItem: list[0],
          onChanged: (value) {},
        );
      },
    );
  }

  Widget buildExit() {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: hexToColor("#F4F6FA"), width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.close, size: 32),
        ),
      ),
      onTap: () => ctx.pop(),
    );
  }

  void _presentDatePicker() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: ctx,
      initialDate: refState.date,

      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: ctx,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        DateTime res = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        refNotifier.setDate(res);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ctx = context;
    refNotifier = ref.read(todoProvider(todo).notifier);
    refState = ref.watch(todoProvider(todo));
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 80, 30, 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [buildExit()],
                ),
                Expanded(child: buildBody()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Salva")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
