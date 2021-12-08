import 'dart:convert';
import 'dart:io';

import 'package:client_exhibideas/api/enviroment.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;
import "package:path/path.dart";

class UsersProvider {
  String _url = Enviroment.API_DELIVERY;
  String _crear = "/crearUsuario";
  String _login = "/login";
  String _update = "/actualizarUsuario";
  String _usuarioUnico = "/usuario";
  String _logout = "/logout";
  String _usuarioRol = "/usuarioRol";

  BuildContext context;
  User sessionUser;
//parametro opcional {String token}
  Future init(BuildContext context, {User sessionUser}) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<ResponseApi> getById(String id) async {
    try {
      Uri url = Uri.https(_url, "$_usuarioUnico/$id");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Tu sesión expiró");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("ERROR $e");
      return null;
    }
  }

  Future<List<User>> getDeliveryUser() async {
    try {
      Uri url = Uri.https(_url, "$_usuarioRol");
      print(url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Tu sesión expiró");
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      User user = User.fromJsonList(data);
      return user.toList;
    } catch (e) {
      print("ERROR $e");
      return null;
    }
  }

  Future<Stream> createWithImage(User user, File image) async {
    try {
      Uri url = Uri.https(_url, "$_crear");
      final request = http.MultipartRequest("POST", url);
      Map<String, String> headers = {"Content-type": "application/json"};

      if (image != null) {
        request.files.add(http.MultipartFile("image",
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.headers.addAll(headers);
      request.fields["user"] = json.encode(user);
      request.fields["nombre"] = user.nombre;
      request.fields["apellido"] = user.apellido;
      request.fields["correo"] = user.correo;
      request.fields["password"] = user.password;
      request.fields["telefono"] = user.telefono;

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print("Error $e");
      return null;
    }
  }

  Future<Stream> updateWithImage(User user, File image) async {
    try {
      Uri url = Uri.https(_url, "$_update/${user.id}");
      print(url);
      final request = http.MultipartRequest("PUT", url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken
      };

      if (image != null) {
        request.files.add(http.MultipartFile("image",
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.headers.addAll(headers);
      request.fields["user"] = json.encode(user);
      request.fields["nombre"] = user.nombre;
      request.fields["correo"] = user.correo;
      request.fields["apellido"] = user.apellido;
      request.fields["telefono"] = user.telefono;
      request.fields["password"] = user.password;

      final response = await request.send();

      if (response.statusCode == 404) {
        Fluttertoast.showToast(msg: "Tu sesión expiró");
        new SharedPref().logout(context, sessionUser.id);
      }

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print("Error $e");
      return null;
    }
  }

  Future<ResponseApi> logout(String idUser) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_logout/$idUser");
      print(url);
      Map<String, String> headers = {"Content-type": "application/json"};

      final res = await http.post(url, headers: headers);
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi> create(User user) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_crear");
      String bodyParams = json.encode(user);
      Map<String, String> headers = {"Content-type": "application/json"};

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      //espera mapa de valores
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi> login(String correo, String password) async {
    try {
      //authority url de la peticion
      Uri url = Uri.https(_url, "$_login");
      String bodyParams = json.encode({"correo": correo, "password": password});
      Map<String, String> headers = {"Content-type": "application/json"};

      final res = await http.post(url, headers: headers, body: bodyParams);
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
