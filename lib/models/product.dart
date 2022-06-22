import 'dart:convert';

import 'package:simpplex_app/models/imagen_principal.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String? id;
  String? nombre;
  String? descripcion;
  String? image1;
  String? image2;
  String? image3;
  String? categoria;
  String? linkRA;
  double? precio;
  int? cantidad;
  int? stock;
  bool? disponible;
  String? colorSelecionado;
  String? imagenPrincipalSeleccionado;
  List<ImagenPrincipal>? imagenPrincipal;
  List<Product> toList = [];

  Product({
    this.id,
    this.nombre,
    this.descripcion,
    this.linkRA,
    this.image1,
    this.image2,
    this.image3,
    this.categoria,
    this.precio,
    this.cantidad,
    this.stock,
    this.disponible,
    this.imagenPrincipal,
    this.colorSelecionado,
    this.imagenPrincipalSeleccionado,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["_id"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      linkRA: json["linkRA"],
      image1: json["image1"],
      image2: json["image2"],
      image3: json["image3"],
      categoria: json["categoria"],
      precio: json["precio"] is String
          ? double.parse(json["precio"])
          : isInteger(json["precio"])
              ? json["precio"].toDouble()
              : json["precio"],
      cantidad: json["cantidad"],
      colorSelecionado: json["colorSelecionado"],
      imagenPrincipalSeleccionado: json["imagenPrincipalSeleccionado"],
      stock: json["stock"],
      disponible: json["disponible"],
      imagenPrincipal: json["imagenPrincipal"] == null
          ? []
          : List<ImagenPrincipal>.from(json["imagenPrincipal"]
              .map((model) => ImagenPrincipal.fromJson(model))));

  //transformar la data que viene en json en un arreglo list
  Product.fromJsonList(List<dynamic> jsonList) {
    for (var element in jsonList) {
      Product product = Product.fromJson(element);
      toList.add(product);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "categoria": categoria,
        "precio": precio,
        "cantidad": cantidad,
        "linkRA": linkRA,
        "disponible": disponible,
        "stock": stock,
        "imagenPrincipal": imagenPrincipal,
        "colorSelecionado": colorSelecionado,
        "imagenPrincipalSeleccionado": imagenPrincipalSeleccionado
      };

  static bool isInteger(num value) => value is int || value == value;
}
