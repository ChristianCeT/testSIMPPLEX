import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class RolesController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    //OBTENER EL USUARIO CUANDO EL USUARIO SE LOGEA
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    refresh();
  }

  void goToPage(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
