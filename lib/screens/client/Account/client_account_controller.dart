import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/client/orders/list/client_orders_list_page.dart';
import 'package:simpplex_app/screens/client/update/client_update_page.dart';
import 'package:simpplex_app/screens/roles/roles_page.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ClienteAccountController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    refresh();
  }

  logout() {
    sharedPref.logout(context, user!.id!);
  }

  void goToOrdersList() {
    Navigator.pushNamed(context, ClientOrdersListPage.routeName);
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(
        context, RolesPage.routeName, (route) => false);
  }

  void gotToUpdatePage() {
    Navigator.pushNamed(context, ClientUpdatePage.routeName);
  }
}
