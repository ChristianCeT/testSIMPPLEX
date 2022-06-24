import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/orders_provider.dart';
import 'package:simpplex_app/screens/admin/products/create/admin_products_create_page.dart';
import 'package:simpplex_app/screens/delivery/orders/details/delivery_orders_details_page.dart';
import 'package:simpplex_app/screens/roles/roles_page.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeliveryOrdersListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<String> status = ["DESPACHADO", "EN CAMINO", "ENTREGADO"];
  final OrdersProvider _ordersProvider = OrdersProvider();

  bool? isUpdated;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    _ordersProvider.init(context, user!);
    refresh();
  }

  Future<List<Order>?> getOrders(String status) async {
    if (user == null) {
      return null;
    }
    return await _ordersProvider.getByDeliveryStatus(user!.id!, status);
  }

  void openBottomSheet(Order order, int index) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeliveryOrdersDetailsPage(order: order),
        settings: RouteSettings(
          arguments: index,
        ));

    if (isUpdated == null) {
      return;
    } else {
      refresh();
    }
  }

  logout() {
    sharedPref.logout(context, user!.id!);
  }

  void openDrawer() {
    key.currentState?.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(
        context, RolesPage.routeName, (route) => false);
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, AdminProductsCreatePage.routeName);
  }
}
