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
    String? description,
    bool? isCompleted,
    DateTime? date,
    int? categoryId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? "",

      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,

      'isCompleted': isCompleted,
      'categoryId': categoryId,
      'date': date,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> data) {
    return Todo(
      id: data['id'],
      title: data['title'],

      isCompleted: data['isCompleted'],
      categoryId: data['categoryId'],
      date: data['date'],
    );
  }
}
