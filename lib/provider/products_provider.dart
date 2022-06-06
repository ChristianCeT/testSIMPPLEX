import 'dart:convert';
import 'dart:io';
import 'package:simpplex_app/api/enviroment.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import "package:path/path.dart";
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class ProductsProvider {
  final String _url = Enviroment.API_DELIVERY;
  final String _agregar = "/crearProducto";
  final String _productoCategoria = "/productoCategoria";
  final String _productoCategoriaNombre = "/buscarProductoNombreCat";

  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<Stream?> create(Product product, List<File> images) async {
    try {
      Uri url = Uri.https(_url, _agregar);
      print(url);

      final request = http.MultipartRequest("POST", url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            "image",
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)));
      }

      request.headers.addAll(headers);
      request.fields["producto"] = json.encode(product);
      request.fields["nombre"] = product.nombre!;
      request.fields["descripcion"] = product.descripcion!;
      request.fields["linkRA"] = product.linkRA!;
      request.fields["precio"] = product.precio.toString();
      request.fields["categoria"] = product.categoria!;
      request.fields["stock"] = product.stock.toString();
      request.fields["disponible"] = product.disponible.toString();

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print("Error $e");
      return null;
    }
  }

  Future<List<Product>?> getByCategory(String idCategory) async {
    try {
      Uri url = Uri.https(_url, "$_productoCategoria/$idCategory");
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

      Product product = Product.fromJsonList(data);

      // recibe la data que viene de la api

      return product.toList; // se retorna la lista de categorías

    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> getByCategoryAndProductName(
      String idCategory, String productName) async {
    try {
      Uri url =
          Uri.https(_url, "$_productoCategoriaNombre/$idCategory/$productName");
      print(url);
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
      print(data);
      Product product = Product.fromJsonList(data);

      print(product.toList); // recibe la data que viene de la api

      return product.toList; // se retorna la lista de categorías

    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<String?> deleteProductById(String id) async {
    try {
      Uri uri = Uri.https(_url, "/eliminarProducto/$id");
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };
      final res = await http.delete(uri, headers: headers);

      if (res.statusCode == 403) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);

      return data["message"];
    } catch (e) {
      return null;
    }
  }

  Future<Stream?> updateProduct(Product product, List<File?> images) async {
    try {
      Uri url = Uri.https(_url, "/actualizarProducto/${product.id}");

      final request = http.MultipartRequest("PUT", url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };

      List<Map> stringImages = [];

      List<File> imagesToSend = [];

      for (int i = 0; i < images.length; i++) {
        if (images[i] == null) {
          stringImages.add({"imagen": i, "tiene": false});
        } else {
          stringImages.add({"imagen": i, "tiene": true});
          request.files.add(http.MultipartFile(
              "image",
              http.ByteStream(images[i]!.openRead().cast()),
              await images[i]!.length(),
              filename: basename(images[i]!.path)));
        }
      }

      for (int i = 0; i < imagesToSend.length; i++) {}

      request.headers.addAll(headers);
      request.fields["producto"] = json.encode(product);
      request.fields["nombre"] = product.nombre!;
      request.fields["descripcion"] = product.descripcion!;
      request.fields["linkRA"] = product.linkRA!;
      request.fields["precio"] = product.precio.toString();
      request.fields["categoria"] = product.categoria!;
      request.fields["posicion1"] =
          stringImages[0]["tiene"] == true ? "true" : "false";
      request.fields["posicion2"] =
          stringImages[1]["tiene"] == true ? "true" : "false";
      request.fields["posicion3"] =
          stringImages[2]["tiene"] == true ? "true" : "false";
      request.fields["stock"] = product.stock.toString();
      request.fields["disponible"] = product.disponible.toString();

      final response = await request.send();

      print(response);

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
