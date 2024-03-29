import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/providers.dart';
import 'package:simpplex_app/screens/client/products/client_products_menu/client_products_menu.dart';
import 'package:simpplex_app/screens/register/register_page.dart';
import 'package:simpplex_app/screens/roles/roles_page.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginController {
  late BuildContext context;
  late User user;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  final SharedPref _sharedPref = SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);

    //nombre de la llave
    user = User.fromJson(await _sharedPref.read('user') ?? {});

    if (user.sessionToken != null) {
      if (user.roles![1].active || user.roles![2].active) {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, RolesPage.routeName, (route) => false);
      } else {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles![0].route, (route) => false);
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  void login() async {
    //capturar el texto del usuario
    //trim sirve para eliminar espacios en blanco
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    ResponseApi? responseApi = await usersProvider.login(email, password);

    if (responseApi == null) return;

    if (responseApi.success!) {
      //retorno de mapa de valores
      // se obtiene el usuario
      User user = User.fromJson(responseApi.data);

      //se almacena el usuario en el dispositivo
      _sharedPref.save('user', user.toJson());

      if (user.roles![1].active || user.roles![2].active) {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, RolesPage.routeName, (route) => false);
      } else {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, ClienteProductsMenu.routeName, (route) => false);
      }
    } else {
      MySnackBar.show(context, responseApi.message!);
    }

    MySnackBar.show(context, responseApi.message!);
  }
}
