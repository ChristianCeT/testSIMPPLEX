import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/orders_provider.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/screens/client/orders/map/client_orders_map_page.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class ClientOrdersDetailsController {
  late BuildContext context;
  late Function refresh;
  Product? product;
  int counter = 1;
  double? productPrice;

  final SharedPref _sharedPref = SharedPref();

  double total = 0;
  Order? order;
  late User user;
  List<User> users = [];
  final UsersProvider _usersProvider = UsersProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();
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
    Navigator.pushNamed(context, ClientOrdersMapPage.routeName,
        arguments: order?.toJson());
  }

  void getUsers() async {
    users = (await _usersProvider.getDeliveryUser())!;

    refresh();
  }

  void getTotal() {
    total = 0;
    for (var product in order!.producto!) {
      total = total + (product.precio! * product.cantidad!);
    }
    refresh();
  }
}
