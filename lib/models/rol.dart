import 'dart:convert';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  Rol(
      {required this.id,
      required this.nombre,
      required this.route,
      required this.imagen,
      required this.active,});

  String id;
  String nombre;
  String imagen;
  String route;
  bool active;

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        id: json["_id"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        route: json["route"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "imagen": imagen,
        "route": route,
        "active": active
      };
}
