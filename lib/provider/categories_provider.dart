import 'dart:convert';

import 'package:client_exhibideas/api/enviroment.dart';
import 'package:client_exhibideas/models/category.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class CategoriesProvider {
  String _url = Enviroment.API_DELIVERY;
  String _agregar = "/crearCategoria";
  String _categorias = "/categories";

  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Category>> getAll() async {
    try {
      Uri url = Uri.https(_url, "$_categorias");
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
      Category category = Category.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<ResponseApi> create(Category category) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_agregar");
      String bodyParams = json.encode(category);
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
