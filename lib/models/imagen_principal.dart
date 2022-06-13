import 'dart:convert';

ImagenPrincipal imagePFromJson(String str) =>
    ImagenPrincipal.fromJson(json.decode(str));

String imagePToJson(ImagenPrincipal data) => json.encode(data.toJson());

class ImagenPrincipal {
  ImagenPrincipal({
    this.posicion,
    this.path,
    this.color,
    this.colorName,
  });

  String? color;
  String? path;
  int? posicion;
  String? colorName;

  factory ImagenPrincipal.fromJson(Map<String, dynamic> json) =>
      ImagenPrincipal(
        posicion: json["posicion"],
        path: json["path"],
        color: json["color"],
        colorName: json["colorName"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "posicion": posicion,
        "color": color,
        "colorName": colorName,
      };
}
