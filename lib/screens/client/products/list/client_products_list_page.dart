import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/screens/client/products/list/client_products_list_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/drawer.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key? key}) : super(key: key);

  static String routeName = "/client/products/list";

  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  final ClientProductsListController _con = ClientProductsListController();
  //inicializar el controlador

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories.length,
      child: Scaffold(
        drawer: DrawerMenu(
          apellido: _con.user?.apellido ?? "",
          nombre: _con.user?.nombre ?? "",
          correo: _con.user?.correo ?? "",
          telefono: _con.user?.telefono ?? "",
          image: _con.user?.image ?? "",
          items: _itemsDrawer(),
        ),
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(155),
          child: SafeArea(
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.01),
              flexibleSpace: Container(
                margin: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MenuIconDrawer(
                          openDrawer: _con.openDrawer,
                        ),
                        _shoppingBag(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _textFieldSearch(),
                  ],
                ),
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
        ),
        body: TabBarView(
          children: _con.categories.map((Category category) {
            return FutureBuilder(
                future: _con.getProducts(category.id!, _con.productName),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardProducts(snapshot.data![index]);
                          });
                    } else {
                      return NoDataWidget(
                        text: "No hay productos",
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
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
      child: SizedBox(
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
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(
                                20)) // en que lado se establece las esquinas del rendondeado
                        ),
                    child: const Icon(Icons.add, color: Colors.white),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.all(20),
                    child: FadeInImage(
                      image: product.image1 != null
                          ? NetworkImage(product.image1!)
                          : const AssetImage("assets/images/noImagen.png")
                              as ImageProvider,
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 50),
                      placeholder:
                          const AssetImage("assets/images/noImagen.png"),
                    ),
                  ),
                  Container(
                    height: 33,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      product.nombre ?? "",
                      maxLines: 2, // maximo 2 lineas de texto
                      overflow: TextOverflow
                          .ellipsis, // EL NOMBRE TODAVIA TIENE UNOS CARACTERES MAS muestra "..."
                      style: const TextStyle(
                          fontSize: 15, fontFamily: "NimbuSans"),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text('${product.precio ?? 0}',
                        style: const TextStyle(
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
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
              )),
          Positioned(
            top: 3,
            right: 16,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
          onChanged: _con
              .onChangeText, // permite capturar el texto qeu el usuario digite
          decoration: InputDecoration(
              hintText: "Buscar",
              suffixIcon: Icon(Icons.search, color: MyColors.primaryColor),
              hintStyle: TextStyle(fontSize: 17, color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.1), width: 2)),
              contentPadding: const EdgeInsets.all(15))),
    );
  }

  Widget _itemsDrawer() {
    return Column(
      children: [
        ListTile(
          title: const Text("Editar perfil"),
          trailing: Icon(
            Icons.edit_outlined,
            color: MyColors.primaryColor,
          ),
        ),
        ListTile(
          onTap: _con.goToOrdersList,
          title: const Text("Mis pedidos"),
          trailing: Icon(
            Icons.shopping_cart_outlined,
            color: MyColors.primaryColor,
          ),
        ),
        _con.user != null
            ? _con.user!.roles![1].active || _con.user!.roles![2].active
                ? ListTile(
                    onTap: _con.goToRoles,
                    title: const Text("Seleccionar rol"),
                    trailing: Icon(
                      Icons.person_outline,
                      color: MyColors.primaryColor,
                    ),
                  )
                : Container()
            : Container(),
        ListTile(
          onTap: _con.logout,
          title: const Text("Cerrar sesión"),
          trailing: Icon(
            Icons.power_settings_new,
            color: MyColors.primaryColor,
          ),
        ),
      ],
    );
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
  }
}
