import 'package:client_exhibideas/screens/admin/categories/create/admin_categories_create_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminCategoriesCreatePage extends StatefulWidget {
  AdminCategoriesCreatePage({Key key}) : super(key: key);
  static String routeName = "/admin/categories/list";

  @override
  _AdminCategoriesCreatePageState createState() =>
      _AdminCategoriesCreatePageState();
}

class _AdminCategoriesCreatePageState extends State<AdminCategoriesCreatePage> {
  AdminCategoriesCreateController _con = new AdminCategoriesCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Categoría"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          _textFieldCategoryName(),
          _textFieldCategoryDescription(),
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _textFieldCategoryName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: "Nombre de la categoría",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.list_alt,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldCategoryDescription() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
            hintText: "Descripción de la categoría",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.description_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _buttonCreate() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.createCategory,
        child: Text("Crear categoria"),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
