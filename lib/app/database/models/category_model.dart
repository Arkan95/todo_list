class CategoryModel {
  int? id;
  String? title;

  CategoryModel({this.id, this.title});

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }

  factory CategoryModel.fromJson(Map<String, dynamic> data) {
    return CategoryModel(id: data['id'], title: data['title']);
  }

  factory CategoryModel.copyWith(CategoryModel old) {
    return CategoryModel(id: old.id, title: old.title);
  }
}
