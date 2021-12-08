import 'package:client_exhibideas/models/category.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/screens/client/products/list/client_products_list_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientProductsListPage extends StatefulWidget {
  ClientProductsListPage({Key key}) : super(key: key);

  static String routeName = "/client/products/list";

  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  ClientProductsListController _con = new ClientProductsListController();
  //inicializar el controlador

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        drawer: _drawer(),
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [_shoppingBag()],
            flexibleSpace: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                _menuDrawer(),
                SizedBox(
                  height: 18,
                ),
                _textFieldSearch(),
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index) {
                return Tab(
                  child: Text(_con.categories[index].nombre ?? ""),
                );
              }),
            ),
          ),
        ),
        body: TabBarView(
          children: _con.categories.map((Category category) {
            return FutureBuilder(
                future: _con.getProducts(category.id, _con.productName),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return GridView.builder(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardProducts(snapshot.data[index]);
                          });
                    } else {
                      return NoDataWidget(
                        text: "No hay productos",
                      );
                    }
                  } else {
                    return NoDataWidget(
                      text: "No hay productos",
                    );
                  }
                }); // numero de productos
          }).toList(),
        ),
      ),
    );
  }

  Widget _cardProducts(Product product) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheets(product);
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: -1.0, // se posciona al lado derecho superior
                  right: -1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(
                                20)) // en que lado se establece las esquinas del rendondeado
                        ),
                    child: Icon(Icons.add, color: Colors.white),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.all(20),
                    child: FadeInImage(
                      image: product.image1 != null
                          ? NetworkImage(product.image1)
                          : AssetImage("assets/images/noImagen.png"),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage("assets/images/noImagen.png"),
                    ),
                  ),
                  Container(
                    height: 33,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      product.nombre ?? "",
                      maxLines: 2, // maximo 2 lineas de texto
                      overflow: TextOverflow
                          .ellipsis, // EL NOMBRE TODAVIA TIENE UNOS CARACTERES MAS muestra "..."
                      style: TextStyle(fontSize: 15, fontFamily: "NimbuSans"),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text('${product.precio ?? 0}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "NimbuSans",
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _shoppingBag() {
    return GestureDetector(
      onTap: _con.goToOrderCreatePage,
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(right: 15, top: 13),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              )),
          Positioned(
              top: 15,
              right: 16,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              )),
        ],
      ),
    );
  }

  Widget _textFieldSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
          onChanged: _con
              .onChangeText, // permite capturar el texto qeu el usuario digite
          decoration: InputDecoration(
              hintText: "Buscar",
              suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
              hintStyle: TextStyle(fontSize: 17, color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300])),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300])),
              contentPadding: EdgeInsets.all(15))),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.menu_sharp, color: MyColors.primaryColor),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_con.user?.nombre ?? ''} ${_con.user?.apellido ?? ''} ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1, // no puede ocupar mas de una linea
                  ),
                  Text(
                    "${_con.user?.correo ?? ''}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1, // no puede ocupar mas de una linea
                  ),
                  Text(
                    "${_con.user?.telefono ?? ''}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1, // no puede ocupar mas de una linea
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 60,
                    child: FadeInImage(
                      image: _con.user?.image != null
                          ? NetworkImage(_con.user?.image)
                          : AssetImage("assets/image/no-avatar.png"),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage("assets/images/no-avatar.png"),
                    ),
                  )
                ],
              )),
          ListTile(
            title: Text("Editar perfil"),
            trailing: Icon(
              Icons.edit_outlined,
              color: MyColors.primaryColor,
            ),
          ),
          ListTile(
            onTap: _con.goToOrdersList,
            title: Text("Mis pedidos"),
            trailing: Icon(
              Icons.shopping_cart_outlined,
              color: MyColors.primaryColor,
            ),
          ),
          _con.user != null
              ? _con.user.roles.length > 1
                  ? ListTile(
                      onTap: _con.goToRoles,
                      title: Text("Seleccionar rol"),
                      trailing: Icon(
                        Icons.person_outline,
                        color: MyColors.primaryColor,
                      ),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _con.logout,
            title: Text("Cerrar sesión"),
            trailing: Icon(
              Icons.power_settings_new,
              color: MyColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
