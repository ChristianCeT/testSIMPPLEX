import 'package:simpplex_app/models/orders.dart';
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
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
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
                builder: (context, AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardOrder(snapshot.data![index]);
                          });
                    } else {
                      return const NoDataWidget(
                        text: "No hay ordenes",
                      );
                    }
                  } else {
                    return const NoDataWidget(
                      text: "No hay ordenes",
                    );
                  }
                }); // numero de productos
          }).toList(),
        ),
      ),
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(order);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 150,
          child: Card(
            elevation: 3.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                Positioned(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: 30,
                        decoration: BoxDecoration(
                            color: MyColors.primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text("Pedido ${order.id}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: "NimbusSans",
                              )),
                        ))),
                Container(
                  margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Fecha: ${RelativeTimeUtil.getRelativeTime(order.fecha ?? 0)}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Cliente: ${order.cliente?.nombre ?? ''} ${order.cliente?.apellido ?? ''}",
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Entregar en: ${order.direccion?.direccion ?? ''}",
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _itemsDrawer() {
    return Column(
      children: [
        ListTile(
          title: const Text("Crear categoría"),
          onTap: _con.goToCaterogyCreate,
          trailing: Icon(
            Icons.category_outlined,
            color: MyColors.primaryColor,
          ),
        ),
        ListTile(
          title: const Text("Crear producto"),
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
