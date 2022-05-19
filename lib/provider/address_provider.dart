import 'dart:convert';
import 'package:simpplex_app/api/enviroment.dart';
import 'package:simpplex_app/models/address.dart';
import 'package:simpplex_app/models/response_api.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class AddressProvider {
  final String _url = Enviroment.API_DELIVERY;
  final String _agregar = "/crearDireccion";
  final String _usuarioDireccion = "/direcciones";

  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Address>> getByUsers() async {
    try {
      Uri url = Uri.https(_url, "$_usuarioDireccion/${sessionUser.id}");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
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

  Future<ResponseApi?> create(Address address) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, _agregar);
      String bodyParams = json.encode(address);
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
      print("Error: $e");
      return null;
    }
  }
}
