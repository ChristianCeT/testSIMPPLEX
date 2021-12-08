import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/orders_provider.dart';
import 'package:client_exhibideas/provider/user_provider.dart';
import 'package:client_exhibideas/screens/client/orders/map/client_orders_map_page.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientOrdersDetailsController {
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
    Navigator.pushNamed(context, ClientOrdersMapPage.routeName,
        arguments: order.toJson());
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
