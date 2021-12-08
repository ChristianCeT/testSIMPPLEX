import 'package:client_exhibideas/models/category.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/categories_provider.dart';
import 'package:client_exhibideas/utils/my_snackbar.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class AdminCategoriesCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  User user;

  SharedPref sharedPref = new SharedPref();

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

    Category category = new Category(nombre: name, descripcion: description);

    ResponseApi responseApi = await _categoriesProvider.create(category);
    MySnackBar.show(context, responseApi.message);
    if (responseApi.success) {
      nameController.text = "";
      descriptionController.text = "";
    }

    print("Nombre: $name, Description: $description");
  }
}
