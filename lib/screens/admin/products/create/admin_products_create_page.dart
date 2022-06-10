import 'dart:io';
import 'package:flutter/services.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/screens/admin/products/create/admin_products_create_controller.dart';
import 'package:simpplex_app/screens/admin/products/list_products_category.dart/list_products_category.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/widgets/container_image_product.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List dataArguments =
        ModalRoute.of(context)!.settings.arguments as List;
    _con.option = dataArguments[0];
    _con.productToEdit = dataArguments[1];
    _con.categorySelect = dataArguments[2];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _con.option == "agregar" ? "Crear producto" : "Editar producto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _con.option == "agregar"
                ? Navigator.of(context).pop()
                : Navigator.pushReplacementNamed(
                    context, ListProductByCategoryScreen.routeName,
                    arguments: _con.categorySelect);
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          _textFieldProductName(),
          _textFieldCategoryDescription(),
          _textFieldProductPrice(),
          Row(
            children: [
              _textFieldRALink(),
              Expanded(
                child: _textFieldRACode(),
              )
            ],
          ),
          const SizedBox(height: 7),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardImage(_con.imageFile1, 1, _con.productToEdit?.image1!),
                _cardImage(_con.imageFile2, 2, _con.productToEdit?.image2!),
                _cardImage(_con.imageFile3, 3, _con.productToEdit?.image3!),
              ],
            ),
          ),
          _textActionImage(),
          _availableProduct(_con.productToEdit?.disponible),
          _stockProduct(_con.productToEdit?.stock),
          _dropDownCategories(_con.categories),
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _textActionImage() {
    return const ModalColorImage();
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
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: Icon(
            Icons.list_alt,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldRALink() {
    return Container(
        margin: const EdgeInsets.only(left: 40),
        child: const Text("https://go.echo3d.co/",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)));
  }

  Widget _textFieldRACode() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 30),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.linkRAController,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: "Código RA",
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.device_hub,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldProductPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.priceController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        ],
        maxLines: 1,
        decoration: InputDecoration(
            hintText: "Precio",
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.monetization_on_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 9),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: MyColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "Categorías",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,
                      )),
                  elevation: 3,
                  isExpanded: true,
                  hint: const Text("Selecciona la categoría",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  items: _dropDownItems(categories),
                  value: _con.option == "editar"
                      ? _con.productToEdit!.categoria
                      : _con.idCategory,
                  onChanged: (String? option) {
                    setState(() {
                      _con.option == "editar"
                          ? _con.productToEdit!.categoria = option
                          : _con.idCategory = option;
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

  Widget _cardImage(
      File? imageFile, int numberFile, String? imageProductEditT) {
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
                  child: Image(
                    image: _con.option == "editar" && imageProductEditT != null
                        ? NetworkImage(imageProductEditT)
                        : const AssetImage('assets/images/noImagen.png')
                            as ImageProvider,
                  )),
            ),
    );
  }

  Widget _buttonCreate() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
      child: ElevatedButton(
        onPressed:
            _con.option == "editar" ? _con.updateProduct : _con.createProduct,
        child: Text(
            _con.option == "editar" ? "Actualizar producto" : "Crear producto"),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _availableProduct(bool? available) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: SwitchListTile.adaptive(
        activeColor: MyColors.primaryColor,
        title: const Text(
          "Disponible",
          style: TextStyle(fontSize: 15),
        ),
        value: _con.option == "editar"
            ? _con.productToEdit!.disponible!
            : _con.disponibleStockAdd,
        onChanged: (value) {
          if (_con.option == "editar") {
            _con.updateAvailable(available!);
          } else {
            _con.updateAvailable(_con.disponibleStockAdd);
          }
        },
      ),
    );
  }

  Widget _stockProduct(int? stock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.quantityController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        maxLines: 1,
        decoration: InputDecoration(
          hintText: "Stock",
          hintStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: Icon(
            Icons.numbers,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
