import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class ClientProductMenu {
  Function refresh;
  BuildContext context;
  User user;
  SharedPref sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    refresh();
  }
}
