import 'package:todo_list/models/category_model.dart';

class Todo {
  final int? id;
  final String? title;
  final String? description;
  final bool? isCompleted;
  final DateTime? date;
  final int? categoryId;

  Todo({
    this.id,
    this.title,
    this.description,
    this.isCompleted,
    this.categoryId,
    this.date,
  });

  Todo copyWith(Todo old) {
    return Todo(
      id: old.id,
      title: old.title,
      description: old.description,
      isCompleted: old.isCompleted,
      date: old.date,
      categoryId: old.categoryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'categoryId': categoryId,
      'date': date,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> data) {
    return Todo(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      isCompleted: data['isCompleted'],
      categoryId: data['categoryId'],
      date: data['date'],
    );
  }
}
