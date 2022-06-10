import 'dart:convert';

ImagenPrincipal rolFromJson(String str) =>
    ImagenPrincipal.fromJson(json.decode(str));

String rolToJson(ImagenPrincipal data) => json.encode(data.toJson());

class ImagenPrincipal {
  ImagenPrincipal({
    required this.url,
    required this.color,
    required this.posicion,
  });
  String url;
  String color;
  int posicion;

  factory ImagenPrincipal.fromJson(Map<String, dynamic> json) =>
      ImagenPrincipal(
        url: json["url"],
        color: json["color"],
        posicion: json["posicion"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "color": color,
        "posicion": posicion,
      };
}
