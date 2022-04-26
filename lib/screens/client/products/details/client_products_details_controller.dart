import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientProductDetailController {
  BuildContext context;
  Function refresh;
  Product product;

  int counter = 1;
  double productPrice;

  final SharedPref _sharedPref = SharedPref();

  List<Product> selectedProducts = [];

  String url1 = '';

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.precio;
    /*  _sharedPref.remove("order");  */ //eliminar lo que hay en el sharedpreferences
    selectedProducts =
        Product.fromJsonList(await _sharedPref.read("order")).toList;
    refresh();
  }

  void launchURL() async {
    url1 = product?.linkRA;
    if (!await launch(url1)) throw 'Could not launcher $url1';
    refresh();
  }

  void addToBag() {
    int index = selectedProducts
        .indexWhere((p) => p.id == product.id); // para saber si elemento existe
    //si es -1 no existe el producto
    if (index == -1) {
      product.cantidad ??= 1;
      selectedProducts.add(product);
    } else {
      selectedProducts[index].cantidad =
          selectedProducts[index].cantidad + counter;
    }

    _sharedPref.save("order", selectedProducts);
    Fluttertoast.showToast(msg: "Producto agregado al carrito");
  }

  void addItem() {
    counter = counter + 1;
    productPrice = product.precio * counter;
    product.cantidad = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter = counter - 1;
      productPrice = product.precio * counter;
      product.cantidad = counter;
      refresh();
    }
  }

  void close() {
    Navigator.pop(context);
  }
}
