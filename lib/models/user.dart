import 'dart:convert';
import 'package:simpplex_app/models/rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? nombre;
  String? apellido;
  String? correo;
  String? telefono;
  String? password;
  String? image;
  String? sessionToken;
  String? refreshToken;
  List<Rol>? roles = [];
  List<User> toList = [];

  User({
    this.id,
    this.nombre,
    this.apellido,
    this.correo,
    this.telefono,
    this.password,
    this.image,
    this.sessionToken,
    this.refreshToken,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"],
      nombre: json["nombre"],
      apellido: json["apellido"],
      correo: json["correo"],
      telefono: json["telefono"],
      password: json["password"],
      image: json["image"],
      sessionToken: json["sessionToken"],
      refreshToken: json["refreshToken"] != null ? json["sessionToken"] : null,
      roles: json["roles"] == null
          ? []
          : List<Rol>.from(json["roles"].map((model) => Rol.fromJson(model))));

  //transformar la data que viene en json en un arreglo list
  User.fromJsonList(List<dynamic> jsonList) {
    for (var element in jsonList) {
      User user = User.fromJson(element);
      toList.add(user);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "telefono": telefono,
        "password": password,
        "image": image,
        "sessionToken": sessionToken,
        "refreshToken": refreshToken,
        "roles": roles
      };
}
