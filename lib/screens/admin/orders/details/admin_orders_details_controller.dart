import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/providers.dart';
import 'package:simpplex_app/screens/admin/orders/evidences/admin_orders_evidences.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
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
    users = (await _usersProvider.getUsersByRolDynamic("REPARTIDOR"))!;
    refresh();
  }

  void getTotal() {
    total = 0;

    for (var product in order!.producto!) {
      {
        total = total + (product.precio! * product.cantidad!);
      }
    }
    refresh();
  }

  void showBottomSheet() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => const AdminEvidencesScreen(),
      settings: RouteSettings(arguments: order),
    );
  }
}
