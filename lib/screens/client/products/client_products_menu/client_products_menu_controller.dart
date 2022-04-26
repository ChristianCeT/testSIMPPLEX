import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/screens/client/Account/client_account_page.dart';
import 'package:client_exhibideas/screens/client/orders/create/client_orders_create_page.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import '../list/client_products_list_page.dart';

class ClientProductMenu {
  Function refresh;
  BuildContext context;
  User user;
  SharedPref sharedPref = SharedPref();
  int position = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    refresh();
  }

  final List<Widget> paginas = const [
    ClientProductsListPage(),
    ClientOrderCreatePage(),
    ClientAcountPage()
  ];
}
