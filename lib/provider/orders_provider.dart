import 'dart:convert';

import 'package:client_exhibideas/api/enviroment.dart';
import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class OrdersProvider {
  String _url = Enviroment.API_DELIVERY;
  String _agregar = "/crearPedido";
  String _pedidoEstado = "/pedidoDetalle";
  String _pedidoActualizado = "/pedidoUpdate";
  String _pedidoDeliveryEstado = "/pedidoRepartidor";
  String _pedidoActualizarEnCamino = "/pedidoUpdateEnCamino";
  String _pedidoActualizarEntregado = "/pedidoUpdateEntregado";
  String _pedidoClientEstado = "/pedidoCliente";
  String _pedidoUpdateLatLong = "/pedidoUpdateLatLong";
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Order>> getByStatus(String status) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoEstado/$status");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body); // categorias
      print(data);
      Order category = Order.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<List<Order>> getByDeliveryStatus(
      String idDelivery, String status) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoDeliveryEstado/$idDelivery/$status");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body); // categorias
      print(data);
      Order category = Order.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<List<Order>> getByClientStatus(String idClient, String status) async {
    try {
      Uri url = Uri.https(_url, "$_pedidoClientEstado/$idClient/$status");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body); // categorias
      print(data);
      Order category = Order.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<ResponseApi> create(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_agregar");
      print("$url");
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.post(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi> updateToOrder(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoActualizado/${order.id}");
      print("$url");
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi> updateToOrderOnTheWay(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoActualizarEnCamino/${order.id}");
      print("$url");
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi> updateToDelivered(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoActualizarEntregado/${order.id}");
      print("$url");
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi> updateLatLong(Order order) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_pedidoUpdateLatLong/${order.id}");
      print("$url");
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
