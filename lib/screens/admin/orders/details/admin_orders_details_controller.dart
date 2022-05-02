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
  late BuildContext context;
  late Function refresh;
  late Product product;
  late int counter = 1;
  late double productPrice;

  final SharedPref _sharedPref = SharedPref();

  double total = 0;
  Order? order;
  User? user;
  List<User> users = [];
  final UsersProvider _usersProvider = UsersProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();
  String? idDelivery;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user!);
    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order!.idDelivery = idDelivery;
      ResponseApi? responseApi = await _ordersProvider.updateToOrder(order!);
      if (responseApi == null) return;
      Fluttertoast.showToast(
          msg: responseApi.message!, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "Selecciona el repartidor");
    }
  }

  void getUsers() async {
    users = (await _usersProvider.getDeliveryUser())!;
    refresh();
  }

  void getTotal() {
    total = 0;
    // ignore: sdk_version_set_literal
    for (var product in order!.producto!) {
      {
        total = total + (product.precio! * product.cantidad!);
      }
    }
    refresh();
  }
}
