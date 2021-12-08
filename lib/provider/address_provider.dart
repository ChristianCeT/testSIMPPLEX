import 'dart:convert';

import 'package:client_exhibideas/api/enviroment.dart';
import 'package:client_exhibideas/models/address.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class AddressProvider {
  String _url = Enviroment.API_DELIVERY;
  String _agregar = "/crearDireccion";
  String _usuarioDireccion = "/direcciones";

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Address>> getByUsers() async {
    try {
      Uri url = Uri.https(_url, "$_usuarioDireccion/${sessionUser.id}");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body); // categorias
      print(data);
      Address address = Address.fromJsonList(data);

      print(address.toList); // recibe la data que viene de la api

      return address.toList; // se retorna la lista de categorías

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<ResponseApi> create(Address address) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_agregar");
      String bodyParams = json.encode(address);
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
}
