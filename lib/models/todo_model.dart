import 'package:todo_list/models/category_model.dart';

class Todo {
  int? id;
  String? title;

  bool? isCompleted;
  DateTime? date;
  int? categoryId;

  Todo({this.id, this.title, this.isCompleted, this.categoryId, this.date}) {
    id = id;
    title = title ?? "";

    isCompleted = isCompleted ?? false;
    categoryId = categoryId ?? 0;
    date = date ?? DateTime.now();
  }

  Todo copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    int? categoryId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    data['categoryId'] = categoryId;
    data['dateTodo'] = date!.toIso8601String();
    return data;
  }

  factory Todo.fromJson(Map<String, dynamic> data) {
    Todo temp = Todo();
    temp.id = data['id'];
    temp.title = data['title'];
    temp.isCompleted = data['isCompleted'] == 1 ? true : false;
    temp.categoryId = data['categoryId'];
    temp.date = DateTime.parse(data['dateTodo']);
    return temp;
  }
}
