import 'package:client_exhibideas/screens/client/Account/client_account_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientAcountPage extends StatefulWidget {
  ClientAcountPage({Key key}) : super(key: key);
  static String routeName = "/client/datos";

  @override
  _ClientAcountPageState createState() => _ClientAcountPageState();
}

class _ClientAcountPageState extends State<ClientAcountPage> {
  ClienteAccountController _con = new ClienteAccountController();
  @override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Mi cuenta"),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        "Bienvenido a mi cuenta",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: FadeInImage(
                          placeholder:
                              AssetImage("assets/images/no-avatar.png"),
                          image: _con.user?.image != null
                              ? NetworkImage(_con.user?.image)
                              : AssetImage("assets/images/no-avatar.png"),
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 50),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  selected: false,
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Nombre del usuario",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${_con.user?.nombre ?? ""}"),
                  leading: Icon(Icons.person),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Apellido del usuario",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${_con.user?.apellido ?? ""}"),
                  leading: Icon(Icons.person),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Correo del usuario",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_con.user?.correo ?? ""),
                  leading: Icon(Icons.email),
                ),
                Divider(),
                ListTile(
                  onTap: _con.goToOrdersList,
                  title: Text(
                    "Mis pedidos",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.shop_outlined),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Teléfono del usuario",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${_con.user?.telefono ?? ""}"),
                  leading: Icon(Icons.phone),
                ),
                Divider(),
                ListTile(
                  onTap: _con.gotToUpdatePage,
                  title: Text(
                    "Actualizar datos",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryColor),
                  ),
                  leading: Icon(
                    Icons.update,
                    color: MyColors.primaryColor,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: MyColors.primaryColor,
                  ),
                ),
                Divider(),
                _con.user != null
                    ? _con.user.roles.length > 1
                        ? ListTile(
                            title: Text(
                              "Cambiar de rol",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            subtitle: Text(
                              "Apreta aquí para cambiar de rol",
                              style: TextStyle(color: Colors.red),
                            ),
                            leading: Icon(Icons.admin_panel_settings,
                                color: Colors.red),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.red),
                            onTap: _con.goToRoles,
                          )
                        : Container()
                    : Container(),
                ListTile(
                  onTap: _con.logout,
                  title: Text(
                    "Cerrar sesión",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Salir de la cuenta"),
                  leading: Icon(Icons.exit_to_app_rounded),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            );
          }),
    );
  }

  void refresh() {
    setState(() {});
  }
}
