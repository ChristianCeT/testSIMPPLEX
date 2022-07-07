import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/providers.dart';
import 'package:simpplex_app/screens/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryOrdersDetailsController {
  late BuildContext context;
  late Function refresh;
  late Product product;
  int counter = 1;
  late double productPrice;

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
    if (order!.estado == "DESPACHADO") {
      ResponseApi? responseApi =
          await _ordersProvider.updateToOrderOnTheWay(order!);
      if (responseApi == null) return;
      Fluttertoast.showToast(
          msg: responseApi.message!, toastLength: Toast.LENGTH_LONG);
      if (responseApi.success!) {
        Navigator.pushNamed(context, DeliveryOrdersMapPage.routeName,
            arguments: order!.toJson());
      }
    } else {
      Navigator.pushNamed(context, DeliveryOrdersMapPage.routeName,
          arguments: order!.toJson());
    }
  }

  void getUsers() async {
    users = (await _usersProvider.getDeliveryUser())!;

    refresh();
  }

  void getTotal() {
    total = 0;
    // ignore: sdk_version_set_literal
    order!.producto?.forEach(
        (product) => {total = total + (product.precio! * product.cantidad!)});
    refresh();
  }
}
