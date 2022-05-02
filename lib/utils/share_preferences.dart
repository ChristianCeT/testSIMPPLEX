import 'dart:convert';
import 'package:client_exhibideas/provider/user_provider.dart';
import 'package:client_exhibideas/screens/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  void save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, json.encode(value));
    print("USUARIO GUARDADO: $value $key");
  }

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) {
      return null;
    } else {
      return json.decode(prefs.getString(key) ?? "");
    }
  }

  // para saber si existe el token
  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  void logout(BuildContext context, String idUser) async {
    UsersProvider usersProvider = UsersProvider();
    usersProvider.init(context);

    await usersProvider.logout(idUser);
    await remove("user");
    //eliminar todo el historial de pantallas
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (route) => false);
  }
}
