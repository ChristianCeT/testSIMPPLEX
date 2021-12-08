import 'package:client_exhibideas/screens/client/Account/client_account_page.dart';
import 'package:client_exhibideas/screens/client/orders/create/client_orders_create_page.dart';
import 'package:client_exhibideas/screens/client/products/client_products_menu/client_products_menu_controller.dart';
import 'package:client_exhibideas/screens/client/products/list/client_products_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClienteProductsMenu extends StatefulWidget {
  ClienteProductsMenu({Key key}) : super(key: key);

  static String routeName = "/client/products/menu";

  @override
  _ClienteProductsMenuState createState() => _ClienteProductsMenuState();
}

int _paginaActual = 0;
List<Widget> _paginas = [
  ClientProductsListPage(),
  ClientOrderCreatePage(),
  ClientAcountPage()
];

class _ClienteProductsMenuState extends State<ClienteProductsMenu> {
  ClientProductMenu _con = new ClientProductMenu();
  @override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _paginaActual,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
