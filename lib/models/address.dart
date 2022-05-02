import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String? id;
  String? direccion;
  String? avenida;
  double? longitud;
  double? latitud;
  String? usuario;
  List<Address> toList = [];

  Address({
    this.id,
    this.direccion,
    this.avenida,
    this.longitud,
    this.latitud,
    this.usuario,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["_id"],
        direccion: json["direccion"],
        avenida: json["avenida"],
        longitud: json["longitud"] is String
            ? double.parse(json["longitud"])
            : json["longitud"],
        latitud: json["latitud"] is String
            ? double.parse(json["latitud"])
            : json["latitud"],
        usuario: json["usuario"],
      );

  //transformar la data que viene en json en un arreglo list
  Address.fromJsonList(List<dynamic> jsonList) {
    for (var element in jsonList) {
      Address address = Address.fromJson(element);
      toList.add(address);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "direccion": direccion,
        "avenida": avenida,
        "longitud": longitud,
        "latitud": latitud,
        "usuario": usuario,
      };
}
