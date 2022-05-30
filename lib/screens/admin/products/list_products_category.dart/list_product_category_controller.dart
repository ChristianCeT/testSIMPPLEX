import 'package:flutter/material.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/products_provider.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/utils/share_preferences.dart';

class ListProductCategoryController {
  late BuildContext context;
  late Function refresh;
  final SharedPref _sharedPref = SharedPref();
  User? user;
  List<Product>? productData = [];
  final UsersProvider _usersProvider = UsersProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));
    _usersProvider.init(context, sessionUser: user);
    _productsProvider.init(context, user!);
    refresh();
  }

  Future<List<Product>?> getProductsByCategory(String idCategory) async {
    productData = await _productsProvider.getByCategory(idCategory);
    return productData;
  }

  deleteProduct(String idProduct) async {
    String? message = await _productsProvider.deleteProductById(idProduct);
    return message;
  }
}
