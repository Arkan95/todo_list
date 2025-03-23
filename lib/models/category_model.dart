class CategoryModel {
  int? id;
  String? title;
  String? colorHex;

  CategoryModel({this.id, this.title, this.colorHex}) {
    id = id;
    title = title ?? "";
    colorHex = colorHex ?? "0000ff";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['color'] = colorHex;
    if (id != null) data['id'] = id;
    return data;
  }

  factory CategoryModel.fromJson(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'],
      title: data['title'],
      colorHex: data['color'],
    );
  }

  CategoryModel copyWith({int? id, String? title, String? colorHex}) {
    CategoryModel temp = CategoryModel();
    temp.id = id ?? this.id;
    temp.title = title ?? this.title;
    temp.colorHex = colorHex ?? this.colorHex;
    return temp;
  }
}
