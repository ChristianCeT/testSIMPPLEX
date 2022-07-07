import 'package:flutter/material.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/categories_provider.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/utils/share_preferences.dart';

class ListProductsController {
  late BuildContext context;
  late Function refresh;
  final SharedPref _sharedPref = SharedPref();
  User? user;
  List<Category>? categories = [];
  final UsersProvider _usersProvider = UsersProvider();
  final CategoriesProvider _categoriesProvider = CategoriesProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));
    _categoriesProvider.init(context, user!);
    _usersProvider.init(context, sessionUser: user);
    refresh();
  }

  Future<List<Category>?> getCategories() async {
    categories = await _categoriesProvider.getCategories();
    return categories;
  }
}
