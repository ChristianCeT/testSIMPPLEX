import 'package:client_exhibideas/screens/client/products/client_products_menu/client_products_menu_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClienteProductsMenu extends StatefulWidget {
  const ClienteProductsMenu({Key? key}) : super(key: key);

  static String routeName = "/client/products/menu";

  @override
  _ClienteProductsMenuState createState() => _ClienteProductsMenuState();
}

class _ClienteProductsMenuState extends State<ClienteProductsMenu> {
  final ClientProductMenu _con = ClientProductMenu();
  @override
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
      body: _con.paginas[_con.position],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _con.position,
        onTap: (int index) {
          _con.position = index;
          setState(() {});
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_sharp),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cuenta',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: const Color.fromRGBO(116, 117, 152, 1),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
