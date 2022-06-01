import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/orders_provider.dart';
import 'package:simpplex_app/screens/admin/categories/create_update/admin_categories_create_page.dart';
import 'package:simpplex_app/screens/admin/categories/list_categories/list_categories.dart';
import 'package:simpplex_app/screens/admin/orders/details/admin_orders_details_page.dart';
import 'package:simpplex_app/screens/admin/products/list_products/list_products.dart';
import 'package:simpplex_app/screens/admin/users/menu_users/menu_users_screen.dart';
import 'package:simpplex_app/screens/roles/roles_page.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdminOrdersListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<String> status = ["PAGADO", "DESPACHADO", "EN CAMINO", "ENTREGADO"];

  final OrdersProvider _ordersProvider = OrdersProvider();

  bool? isUpdated;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    _ordersProvider.init(context, user! );
    refresh();
  }

  Future<List<Order>?> getOrders(String status) async {
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
    sharedPref.logout(context, user!.id!);
  }

  void openDrawer() {
    key.currentState?.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(
        context, RolesPage.routeName, (route) => false);
  }

  void goToCaterogyCreate() {
    Navigator.pushNamed(context, AdminCategoriesCreateUpdatePage.routeName);
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, ListProductsScreen.routeName);
  }

  void goToUsers() {
    Navigator.pushNamed(context, MenuUsersScreen.routeName);
  }

  void goToCategories() {
    Navigator.pushNamed(context, CategoriesScreen.routeName);
  }
}
