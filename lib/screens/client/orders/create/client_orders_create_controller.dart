import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/screens/client/address/list/client_address_list_page.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class ClientOrdersCreateController {
  late BuildContext context;
  late Function refresh;
  Product? product;

  int counter = 1;
  double? productPrice;

  final SharedPref _sharedPref = SharedPref();

  List<Product> selectedProducts = [];
  double total = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    selectedProducts =
        Product.fromJsonList(await _sharedPref.read("order") ?? []).toList;
    getTotal();
    refresh();
  }

  void getTotal() {
    total = 0;
    for (var product in selectedProducts) {
      total = total + (product.cantidad! * product.precio!);
    }
    refresh();
  }

  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) =>
        p.id ==
        product.id); // para saber si elemento existe y que modifico en la lista
    selectedProducts[index].cantidad = selectedProducts[index].cantidad! + 1;
    _sharedPref.save("order", selectedProducts);
    getTotal();
  }

  void removeItem(Product product) {
    if (product.cantidad! > 1) {
      int index = selectedProducts.indexWhere((p) =>
          p.id ==
          product
              .id); // para saber si elemento existe y que modifico en la lista
      selectedProducts[index].cantidad = selectedProducts[index].cantidad! - 1;
      _sharedPref.save("order", selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPref.save("order", selectedProducts);
    getTotal();
  }

  void goToAddress() {
    Navigator.pushNamed(context, ClientAddressListPage.routeName);
  }
}
