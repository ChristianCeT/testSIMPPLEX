import 'dart:convert';

import 'package:simpplex_app/api/enviroment.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/models/response_api.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class CategoriesProvider {
  final String _url = Enviroment.API_DELIVERY;
  final String _agregar = "/crearCategoria";
  final String _categorias = "/categories";

  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Category>> getCategories() async {
    try {
      Uri url = Uri.https(_url, _categorias);

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

      Category category = Category.fromJsonList(data);

      print(category.toList); // recibe la data que viene de la api

      return category.toList; // se retorna la lista de categorías

    } catch (e) {
      return [];
    }
  }

  Future<ResponseApi?> create(Category category) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, _agregar);
      String bodyParams = json.encode(category);
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

  Future<String?> deleteCategory(String id) async {
    try {
      Uri url = Uri.https(_url, "/deletecategory/$id");
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.delete(url, headers: headers);
      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }
      final data = json.decode(res.body);

      return data["message"];
    } catch (e) {
      return null;
    }
  }

  Future<ResponseApi?> updateCategory(String id, Category category) async {
    try {
      Uri uri = Uri.https(_url, "/updatecategory/$id");
      String bodyParams = json.encode(category);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);

      return responseApi;
    } catch (e) {
      return null;
    }
  }
}
