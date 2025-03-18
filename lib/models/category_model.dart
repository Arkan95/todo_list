class CategoryModel {
  int? id;
  String? title;
  String? colorHex;

  CategoryModel({this.id, this.title, this.colorHex});

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'color': colorHex};
  }

  factory CategoryModel.fromJson(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'],
      title: data['title'],
      colorHex: data['colorHex'],
    );
  }

  factory CategoryModel.copyWith(CategoryModel old) {
    return CategoryModel(id: old.id, title: old.title, colorHex: old.colorHex);
  }
}
