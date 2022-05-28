import 'dart:io';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/screens/admin/products/create/admin_products_create_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminProductsCreatePage extends StatefulWidget {
  const AdminProductsCreatePage({Key? key}) : super(key: key);
  static String routeName = "/admin/products/create";

  @override
  _AdminProductsCreatePageState createState() =>
      _AdminProductsCreatePageState();
}

class _AdminProductsCreatePageState extends State<AdminProductsCreatePage> {
  final AdminProductsCreateController _con = AdminProductsCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Producto"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          _textFieldProductName(),
          _textFieldCategoryDescription(),
          _textFieldProductPrice(),
          _textFieldRALink(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardImage(_con.imageFile1, 1),
                _cardImage(_con.imageFile2, 2),
                _cardImage(_con.imageFile3, 3),
              ],
            ),
          ),
          _dropDownCategories(_con.categories),
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _textFieldProductName() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.nameController,
        maxLines: 1,
        maxLength: 180,
        decoration: InputDecoration(
            hintText: "Nombre del producto",
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.list_alt,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldRALink() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.linkRAController,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: "URL del modelo RA",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.device_hub,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldProductPrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: "Precio",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.monetization_on_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 34, vertical: 9),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: MyColors.primaryColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Categorías",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,
                      )),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text("Selecciona la categoría",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  items: _dropDownItems(categories),
                  value: _con.idCategory,
                  onChanged: (String? option) {
                    setState(() {
                      print("Categoria seleccionada $option");
                      _con.idCategory = option;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var category in categories) {
      list.add(DropdownMenuItem(
        child: Text(category.nombre!),
        value: category.id,
      ));
    }
    return list;
  }

  Widget _textFieldCategoryDescription() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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

  Widget _cardImage(File? imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog(numberFile);
      }, // cuando hay un parametro
      child: imageFile != null
          ? Card(
              elevation: 2.0,
              child: SizedBox(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.24,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 2.0,
              child: SizedBox(
                  height: 140,
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: const Image(
                    image: AssetImage('assets/images/noImagen.png'),
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
        onPressed: _con.createProduct,
        child: Text("Crear producto"),
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
