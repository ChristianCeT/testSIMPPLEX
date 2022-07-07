import 'dart:convert';
import 'dart:io';
import 'package:simpplex_app/api/enviroment.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import "package:path/path.dart";
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;

class ProductsProvider {
  final String _url = Enviroment.apiProduction;

  final String _productoCategoria = "/productoCategoria";
  final String _productoCategoriaNombre = "/buscarProductoNombreCat";

  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
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

  Future<Stream?> updateProduct(
      Product product,
      List<File?> images,
      List<Map<String, dynamic>> listMap,
      int lenghtImagesSecondary,
      int lenghImagesListMap,
      List imagesSecondaryValidation) async {
    try {
      Uri url = Uri.https(_url, "/updateProductv2/${product.id}");

      final request = http.MultipartRequest("PUT", url);

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };

      List<File?>? imagesOrden = [];
      List<ImagenPrincipal>? imagenesPrincipal = [];

      imagesOrden.addAll(listMap.map((e) => e["file"]));
      imagesOrden.addAll(images);

      for (int i = 0; i < imagesOrden.length; i++) {
        if (imagesOrden[i] != null) {
          request.files.add(
            http.MultipartFile(
              "image",
              http.ByteStream(imagesOrden[i]!.openRead().cast()),
              await imagesOrden[i]!.length(),
              filename: basename(imagesOrden[i]!.path),
            ),
          );
        }
      }

      for (int i = 0; i < listMap.length; i++) {
        imagenesPrincipal.add(ImagenPrincipal(
          color: listMap[i]["color"].toString(),
          posicion: listMap[i]["posicion"],
          colorName: listMap[i]["colorName"],
          path: listMap[i]["path"],
        ));
      }

      product.imagenPrincipal = imagenesPrincipal;

      request.headers.addAll(headers);
      request.fields["producto"] = json.encode(product);
      request.fields["lenghtSecondary"] = json.encode(lenghtImagesSecondary);
      request.fields["lenghtListMap"] = json.encode(lenghImagesListMap);
      request.fields["imagesSecondaryValidation"] =
          json.encode(imagesSecondaryValidation);

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseApi?> updateStockProduct(List<Product> producto) async {
    try {
      Uri uri = Uri.https(_url, "/actualizarStockProducto");

      String bodyParams = json.encode(producto);

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

  Future<String?> sendCountImages(int countImagesSend) async {
    try {
      Uri uri = Uri.https(_url, "/countImagesSend");

      String bodyParams = json.encode({
        "numeroImagenes": countImagesSend,
      });

      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };

      final res = await http.post(uri, headers: headers, body: bodyParams);

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: "Sesión expirada");
        SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);

      print(data["message"]);

      return data["message"];
    } catch (e) {
      return null;
    }
  }

  Future<Stream?> create2(Product product, List<File> images,
      List<Map<String, dynamic>> listMap) async {
    try {
      Uri url = Uri.https(_url, "/createProductv2");

      final request = http.MultipartRequest("POST", url);
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": sessionUser.sessionToken!
      };

      List<File> imagesOrden = [];
      List<ImagenPrincipal>? imagenesPrincipal = [];

      imagesOrden.addAll(listMap.map((e) => e["file"]));
      imagesOrden.addAll(images);

      for (int i = 0; i < imagesOrden.length; i++) {
        request.files.add(
          http.MultipartFile(
            "image",
            http.ByteStream(imagesOrden[i].openRead().cast()),
            await imagesOrden[i].length(),
            filename: basename(
              imagesOrden[i].path,
            ),
          ),
        );
      }

      for (int i = 0; i < listMap.length; i++) {
        imagenesPrincipal.add(ImagenPrincipal(
          color: listMap[i]["color"].toString(),
          posicion: listMap[i]["posicion"],
          colorName: listMap[i]["colorName"],
          path: listMap[i]["path"],
        ));
      }

      product.imagenPrincipal = imagenesPrincipal;

      request.headers.addAll(headers);
      request.fields["producto"] = json.encode(product);

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print("Error $e");
      return null;
    }
  }
}
