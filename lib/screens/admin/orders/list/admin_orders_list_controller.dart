import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/orders_provider.dart';
import 'package:client_exhibideas/screens/admin/categories/create/admin_categories_create_page.dart';
import 'package:client_exhibideas/screens/admin/orders/details/admin_orders_details_page.dart';
import 'package:client_exhibideas/screens/admin/products/create/admin_products_create_page.dart';
import 'package:client_exhibideas/screens/roles/roles_page.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminOrdersListController {
  BuildContext context;
  Function refresh;
  User user;
  SharedPref sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<String> status = ["PAGADO", "DESPACHADO", "EN CAMINO", "ENTREGADO"];
  
  final OrdersProvider _ordersProvider = OrdersProvider();

  bool isUpdated;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    _ordersProvider.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.getByStatus(status);
  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => AdminOrdersDetailsPage(order: order));

    if (isUpdated == null) {
      return;
    } else {
      refresh();
    }
  }

  logout() {
    sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(
        context, RolesPage.routeName, (route) => false);
  }

  void goToCaterogyCreate() {
    Navigator.pushNamed(context, AdminCategoriesCreatePage.routeName);
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, AdminProductsCreatePage.routeName);
  }
}
