import 'dart:convert';
import 'dart:io';
import 'package:simpplex_app/api/enviroment.dart';
import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/models/response_api.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import "package:path/path.dart";
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class OrdersProvider {
  final String _url = Enviroment.API_DELIVERY;
/*   final String _urlDev = Enviroment.apiDev; */
  final String _agregar = "/crearPedido";
  final String _pedidoEstado = "/pedidoDetalle";
  final String _pedidoActualizado = "/pedidoUpdate";
  final String _pedidoDeliveryEstado = "/pedidoRepartidor";
  final String _pedidoActualizarEnCamino = "/pedidoUpdateEnCamino";
  final String _pedidoActualizarEntregado = "/pedidoUpdateEntregado";
  final String _pedidoClientEstado = "/pedidoCliente";
  final String _pedidoUpdateLatLong = "/pedidoUpdateLatLong";
  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Order>?> getByStatus(String status) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoEstado/$status");

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body); // categorias

      Order category = Order.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      return null;
    }
  }

  Future<List<Order>?> getByDeliveryStatus(
      String idDelivery, String status) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoDeliveryEstado/$idDelivery/$status");

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body); // categorias

      Order category = Order.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      return null;
    }
  }

  Future<List<Order>> getByClientStatus(String idClient, String status) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoClientEstado/$idClient/$status");

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body); // categorias

      Order category = Order.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      return [];
    }
  }

  Future<ResponseApi?> createOrder(Order order) async {
    try {
      Uri url = Uri.https(_url, _agregar);

      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.post(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseApi?> updateToOrder(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoActualizado/${order.id}");

      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseApi?> updateToOrderOnTheWay(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoActualizarEnCamino/${order.id}");

      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null;
    }
  }

  Future<Stream?> updateToDelivered(
      Order order, List<File?> fileEvidences) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoActualizarEntregado/${order.id}");

      final request = http.MultipartRequest("PUT", url);

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };

      for (int i = 0; i < fileEvidences.length; i++) {
        if (fileEvidences[i] != null) {
          request.files.add(
            http.MultipartFile(
              "image",
              http.ByteStream(fileEvidences[i]!.openRead().cast()),
              await fileEvidences[i]!.length(),
              filename: basename(fileEvidences[i]!.path),
            ),
          );
        }
      }

      request.headers.addAll(headers);
      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      return null;
    }
  }

  Future<ResponseApi?> updateLatLong(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoUpdateLatLong/${order.id}");

      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null;
    }
  }
}
