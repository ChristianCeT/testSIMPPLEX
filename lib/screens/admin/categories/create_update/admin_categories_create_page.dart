import 'package:simpplex_app/screens/admin/categories/create_update/admin_categories_create_controller.dart';
import 'package:simpplex_app/screens/admin/categories/list_categories/list_categories.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminCategoriesCreateUpdatePage extends StatefulWidget {
  const AdminCategoriesCreateUpdatePage({Key? key}) : super(key: key);
  static String routeName = "/admin/categories/create";

  @override
  _AdminCategoriesCreateUpdatePageState createState() =>
      _AdminCategoriesCreateUpdatePageState();
}

class _AdminCategoriesCreateUpdatePageState
    extends State<AdminCategoriesCreateUpdatePage> {
  final AdminCategoriesCreateUpdateController _con =
      AdminCategoriesCreateUpdateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List dataArguments =
        ModalRoute.of(context)?.settings.arguments as List;
    _con.option = dataArguments[0];
    _con.categoryT = dataArguments[1];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _con.option == "editar" ? "Editar categoría" : "Crear categoría"),
        backgroundColor: MyColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context, CategoriesScreen.routeName);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          _textFieldCategoryName(),
          _textFieldCategoryDescription(),
        ],
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: size.height * 0.04),
          child: _buttonCreate()),
    );
  }

  Widget _textFieldCategoryName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
          hintText: "Nombre de la categoría",
          hintStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: Icon(
            Icons.list_alt,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldCategoryDescription() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
            hintText: "Descripción de la categoría",
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.description_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _buttonCreate() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed:
            _con.option == "editar" ? _con.updateCategory : _con.createCategory,
        child: Text(_con.option == "editar"
            ? "Actualizar categoría"
            : "Crear categoría"),
        style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
