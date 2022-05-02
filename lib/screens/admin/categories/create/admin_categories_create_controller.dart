import 'package:client_exhibideas/models/category.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/categories_provider.dart';
import 'package:client_exhibideas/utils/my_snackbar.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class AdminCategoriesCreateController {
  late BuildContext context;
  late Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  late User user;

  SharedPref sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read("user"));
    _categoriesProvider.init(context, user);
    refresh();
  }

  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      MySnackBar.show(context, "Debe ingresar todos los campos");
      return;
    }

    Category category = Category(nombre: name, descripcion: description);

    ResponseApi? responseApi = await _categoriesProvider.create(category);
    if(responseApi == null) return;
    MySnackBar.show(context, responseApi.message!);
    if (responseApi.success!) {
      nameController.text = "";
      descriptionController.text = "";
    }
  }
}
