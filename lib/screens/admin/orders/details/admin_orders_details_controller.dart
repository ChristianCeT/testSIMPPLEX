import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/orders_provider.dart';
import 'package:client_exhibideas/provider/user_provider.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminOrdersDetailsController {
  BuildContext context;
  Function refresh;
  Product product;
  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  double total = 0;
  Order order;
  User user;
  List<User> users = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  String idDelivery;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);
    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order.idDelivery = idDelivery;
      ResponseApi responseApi = await _ordersProvider.updateToOrder(order);
      Fluttertoast.showToast(
          msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "Selecciona el repartidor");
    }
  }

  void getUsers() async {
    users = await _usersProvider.getDeliveryUser();

    refresh();
  }

  void getTotal() {
    total = 0;
    // ignore: sdk_version_set_literal
    order.producto.forEach(
        (product) => {total = total + (product.precio * product.cantidad)});
    refresh();
  }
}
