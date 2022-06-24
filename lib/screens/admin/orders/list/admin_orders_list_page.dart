import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/screens/admin/orders/list/admin_orders_list_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/utils/relative_time_util.dart';
import 'package:simpplex_app/widgets/drawer.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminOrdersListPage extends StatefulWidget {
  const AdminOrdersListPage({Key? key}) : super(key: key);

  static String routeName = "/admin/orders/list";

  @override
  _AdminOrdersListPageState createState() => _AdminOrdersListPageState();
}

class _AdminOrdersListPageState extends State<AdminOrdersListPage> {
  final AdminOrdersListController _con = AdminOrdersListController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.status.length,
      child: Scaffold(
        drawer: DrawerMenu(
          apellido: _con.user?.apellido ?? "",
          telefono: _con.user?.telefono ?? "",
          image: _con.user?.image ?? "",
          nombre: _con.user?.nombre ?? "",
          correo: _con.user?.correo ?? "",
          items: _itemsDrawer(),
        ),
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: SafeArea(
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.1),
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
                      ],
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                indicatorColor: MyColors.primaryColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(_con.status.length, (index) {
                  return Tab(
                    child: Text(_con.status[index]),
                  );
                }),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: _con.status.map((String status) {
            return FutureBuilder(
                future: _con.getOrders(status),
                builder: (context, AsyncSnapshot<List<Order>?> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardOrder(snapshot.data![index],
                                snapshot.data!.length - index);
                          });
                    } else {
                      return const NoDataWidget(
                        text: "No hay ordenes",
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

  Widget _cardOrder(Order order, int index) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(order, index);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 180,
          child: Card(
            elevation: 3.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: MyColors.primaryColor,
                    child: Text(
                      "N° $index",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Divider(
                    thickness: 1.3,
                    height: 10,
                  ),
                  itemPrimerProducto(order.producto![0]),
                  const Divider(
                    thickness: 1.3,
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      itemsPedido("Cliente", order.cliente!.nombre!),
                      Container(
                        color: Colors.black45,
                        height: 29,
                        width: 0.4,
                      ),
                      itemsPedido("Fecha",
                          RelativeTimeUtil.getRelativeTime(order.fecha ?? 0)),
                      Container(
                        color: Colors.black45,
                        height: 29,
                        width: 0.3,
                      ),
                      itemsPedido("Entrega", order.direccion!.direccion!),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget itemPrimerProducto(Product product) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInImage(
            fadeInDuration: const Duration(milliseconds: 30),
            fit: BoxFit.contain,
            placeholder: const AssetImage("assets/images/noImagen.png"),
            image: product.imagenPrincipalSeleccionado != null
                ? NetworkImage(product.imagenPrincipalSeleccionado!)
                : const AssetImage("assets/images/noImagen.png")
                    as ImageProvider,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.nombre!),
                  Text(
                    "(${product.colorSelecionado ?? ""})",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "S/ ${product.precio}",
                style: TextStyle(color: MyColors.primaryColor),
              ),
              Text(
                "x ${product.cantidad}",
                style: TextStyle(
                    color: Colors.grey[400], fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget itemsPedido(String title, String descripcion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          descripcion,
          style: TextStyle(color: MyColors.primaryColor, fontSize: 14),
        ),
      ],
    );
  }

  Widget _itemsDrawer() {
    return Column(
      children: [
        ListTile(
          title: const Text("Productos"),
          onTap: _con.goToProductCreate,
          trailing: Icon(
            Icons.assessment_outlined,
            color: MyColors.primaryColor,
          ),
        ),
        _con.user != null
            ? _con.user!.roles!.length > 1
                ? ListTile(
                    title: const Text("Seleccionar rol"),
                    onTap: _con.goToRoles,
                    trailing: Icon(
                      Icons.person_outline,
                      color: MyColors.primaryColor,
                    ),
                  )
                : Container()
            : Container(),
        ListTile(
          onTap: _con.goToUsers,
          title: const Text("Usuarios"),
          trailing: Icon(
            Icons.person_add_outlined,
            color: MyColors.primaryColor,
          ),
        ),
        ListTile(
          onTap: _con.goToCategories,
          title: const Text("Categorias"),
          trailing: Icon(
            Icons.category_outlined,
            color: MyColors.primaryColor,
          ),
        ),
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
    setState(() {});
  }
}
