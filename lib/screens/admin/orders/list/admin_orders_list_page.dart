import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/screens/admin/orders/list/admin_orders_list_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminOrdersListPage extends StatefulWidget {
  AdminOrdersListPage({Key key}) : super(key: key);

  static String routeName = "/admin/orders/list";

  @override
  _AdminOrdersListPageState createState() => _AdminOrdersListPageState();
}

class _AdminOrdersListPageState extends State<AdminOrdersListPage> {
  AdminOrdersListController _con = new AdminOrdersListController();

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
      length: _con.status?.length,
      child: Scaffold(
        drawer: _drawer(),
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                _menuDrawer(),
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.status.length, (index) {
                return Tab(
                  child: Text(_con.status[index] ?? ""),
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
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardOrder(snapshot.data[index]);
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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text("Pedido ${order.id}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: "NimbusSans",
                              )),
                        ))),
                Container(
                  margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Pedido: 2015-05-23",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Cliente: ${order.cliente?.nombre ?? ''} ${order.cliente?.apellido ?? ''}",
                          style: TextStyle(fontSize: 13),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        child: Text(
                          "Entregar en: ${order.direccion?.direccion ?? ''}",
                          style: TextStyle(fontSize: 13),
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

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
          margin: EdgeInsets.only(left: 15),
          alignment: Alignment.centerLeft,
          child: Icon(Icons.menu)),
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
            title: Text("Crear categoría"),
            onTap: _con.goToCaterogyCreate,
            trailing: Icon(
              Icons.category_outlined,
              color: MyColors.primaryColor,
            ),
          ),
          ListTile(
            title: Text("Crear producto"),
            onTap: _con.goToProductCreate,
            trailing: Icon(
              Icons.assessment_outlined,
              color: MyColors.primaryColor,
            ),
          ),
          _con.user != null
              ? _con.user.roles.length > 1
                  ? ListTile(
                      title: Text("Seleccionar rol"),
                      onTap: _con.goToRoles,
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
