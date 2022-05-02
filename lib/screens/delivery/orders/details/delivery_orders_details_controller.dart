import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/orders_provider.dart';
import 'package:client_exhibideas/provider/user_provider.dart';
import 'package:client_exhibideas/screens/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryOrdersDetailsController {
  late BuildContext context;
  late Function refresh;
  late Product product;
  int counter = 1;
  late double productPrice;

  SharedPref _sharedPref = SharedPref();

  double total = 0;
  late Order order;
  late User user;
  List<User> users = [];
  UsersProvider _usersProvider = UsersProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  late String idDelivery;

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
    if (order.estado == "DESPACHADO") {
      ResponseApi? responseApi =
          await _ordersProvider.updateToOrderOnTheWay(order);
      if (responseApi == null) return;
      Fluttertoast.showToast(
          msg: responseApi.message!, toastLength: Toast.LENGTH_LONG);
      if (responseApi.success!) {
        Navigator.pushNamed(context, DeliveryOrdersMapPage.routeName,
            arguments: order.toJson());
      }
    } else {
      Navigator.pushNamed(context, DeliveryOrdersMapPage.routeName,
          arguments: order.toJson());
    }
  }

  void getUsers() async {
    users = (await _usersProvider.getDeliveryUser())!;

    refresh();
  }

  void getTotal() {
    total = 0;
    // ignore: sdk_version_set_literal
    order.producto?.forEach(
        (product) => {total = total + (product.precio! * product.cantidad!)});
    refresh();
  }
}
