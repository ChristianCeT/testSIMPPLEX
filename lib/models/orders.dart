import 'dart:convert';
import 'package:client_exhibideas/models/address.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/models/user.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String id;
  User deliveryList;
  String estado;
  String idDelivery;
  int fecha;
  List<Product> producto = [];
  List<Order> toList = [];
  User cliente;
  Address direccion;
  double latitud;
  double longitud;

  Order(
      {this.id,
      this.cliente,
      this.idDelivery,
      this.deliveryList,
      this.direccion,
      this.estado,
      this.producto,
      this.fecha,
      this.latitud,
      this.longitud});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json["_id"],
      cliente: json["cliente"] is String
          ? userFromJson(json["cliente"])
          : json["cliente"] is User
              ? json["cliente"]
              : User.fromJson(json["cliente"]),
      direccion: json["direccion"] is String
          ? addressFromJson(json["direccion"])
          : json["direccion"] is Address
              ? json["direccion"]
              : Address.fromJson(json["direccion"]),
      idDelivery: json["id_delivery"],
      deliveryList: json["detalle_repartidor"] == null
          ? json["detalle_repartidor"]
          : json["detalle_repartidor"] is String
              ? userFromJson(json["detalle_repartidor" ?? {}])
              : json["detalle_repartidor"] is User
                  ? json["detalle_repartidor"]
                  : User.fromJson(json["detalle_repartidor" ?? {}]),
      estado: json["estado"],
      producto: json["producto"] != null
          ? List<Product>.from(json["producto"].map((model) =>
                  model is Product ? model : Product.fromJson(model))) ??
              []
          : [],
      fecha: json["horaOrden"],
      longitud: json["longitud"] is String
          ? double.parse(json["longitud"])
          : json["longitud"].toDouble(),
      latitud: json["latitud"] is String
          ? double.parse(json["latitud"])
          : json["latitud"].toDouble());

  Order.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((element) {
      Order order = Order.fromJson(element);
      toList.add(order);
    });
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "cliente": cliente,
        "id_delivery": idDelivery,
        "detalle_repartidor": deliveryList,
        "direccion": direccion,
        "estado": estado,
        "producto": producto,
        "horaOrden": fecha,
        "latitud": latitud,
        "longitud": longitud,
      };
}
