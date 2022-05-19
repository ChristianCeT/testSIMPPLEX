import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/screens/client/orders/list/client_orders_list_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({Key? key}) : super(key: key);
  static String routeName = "/client/orders/list";

  @override
  _ClientOrdersListPageState createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage> {
  final ClientOrdersListController _con = ClientOrdersListController();

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
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            title: const Text("Mis pedidos"),
            backgroundColor: MyColors.primaryColor,
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.white,
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
                      return NoDataWidget(
                        text: "No hay ordenes",
                      );
                    }
                  } else {
                    return NoDataWidget(
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
                        child: const Text(
                          "Pedido: 2015-05-23",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Repartidor: ${order.deliveryList?.nombre ?? 'No asignado'} ${order.deliveryList?.apellido ?? ''}",
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

  void refresh() {
    setState(() {});
  }
}
