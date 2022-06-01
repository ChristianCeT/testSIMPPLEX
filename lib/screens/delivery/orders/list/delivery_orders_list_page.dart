import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/screens/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/utils/relative_time_util.dart';
import 'package:simpplex_app/widgets/drawer.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DeliveryOrdersListPage extends StatefulWidget {
  const DeliveryOrdersListPage({Key? key}) : super(key: key);
  static String routeName = "/delivery/orders/list";

  @override
  _DeliveryOrdersListPageState createState() => _DeliveryOrdersListPageState();
}

class _DeliveryOrdersListPageState extends State<DeliveryOrdersListPage> {
  final DeliveryOrdersListController _con = DeliveryOrdersListController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.status.length,
      child: Scaffold(
        drawer: DrawerMenu(
          apellido: _con.user?.apellido ?? "",
          nombre: _con.user?.nombre ?? "",
          correo: _con.user?.correo ?? "",
          image: _con.user?.image ?? "",
          telefono: _con.user?.telefono ?? "",
          items: _itemsDrawer(),
        ),
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: SafeArea(
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.01),
              flexibleSpace: Container(
                margin: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MenuIconDrawer(
                          openDrawer: _con.openDrawer,
                        )
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
                            return _cardOrder(snapshot.data![index]);
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
                          "Pedido: ${RelativeTimeUtil.getRelativeTime(order.fecha ?? 0)}",
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
          title: const Text("Seleccionar rol"),
          onTap: _con.goToRoles,
          trailing: Icon(
            Icons.person_outline,
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
