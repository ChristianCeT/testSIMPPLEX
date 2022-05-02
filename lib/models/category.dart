import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String? id;
  String? nombre;
  String? descripcion;
  List<Category> toList = [];

  Category({
    this.id,
    this.nombre,
    this.descripcion,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
      );

//transformar la data que viene en json en un arreglo list
  Category.fromJsonList(List<dynamic> jsonList) {
    for (var element in jsonList) {
      Category category = Category.fromJson(element);
      toList.add(category);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "descripcion": descripcion,
      };
}
