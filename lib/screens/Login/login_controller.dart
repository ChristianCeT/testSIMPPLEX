import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/user_provider.dart';
import 'package:client_exhibideas/screens/client/products/client_products_menu/client_products_menu.dart';
import 'package:client_exhibideas/screens/register/register_page.dart';
import 'package:client_exhibideas/screens/roles/roles_page.dart';
import 'package:client_exhibideas/utils/my_snackbar.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class LoginController {
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);

    //nombre de la llave
    User user = User.fromJson(await _sharedPref.read("user") ?? {});

    if (user?.sessionToken != null) {
      if (user.roles.length > 1) {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, RolesPage.routeName, (route) => false);
      } else {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
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
    ResponseApi responseApi = await usersProvider.login(email, password);

    if (responseApi.success) {
      //retorno de mapa de valores
      // se obtiene el usuario
      User user = await User.fromJson(responseApi.data);
      //se almacena el usuario en el dispositivo
      _sharedPref.save('user', await user.toJson());

      print("USUARIO LOGEADO: ${user.toJson()}");

      if (user.roles.length > 1) {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, RolesPage.routeName, (route) => false);
      } else {
        //sirve para que despues de esa pantalla ya no existe nada
        Navigator.pushNamedAndRemoveUntil(
            context, ClienteProductsMenu.routeName, (route) => false);
      }
    } else {
      MySnackBar.show(context, responseApi.message);
    }

    print("respuesta: ${responseApi.toJson()}");
    MySnackBar.show(context, responseApi.message);

    print("EMAIL: $email");
    print("PASSOWRD: $password");
  }

  // NULL SAFETY ninguna variable puede ser nulla
}
