import 'package:client_exhibideas/screens/client/Account/client_account_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientAcountPage extends StatefulWidget {
  const ClientAcountPage({Key key}) : super(key: key);
  static String routeName = "/client/datos";

  @override
  _ClientAcountPageState createState() => _ClientAcountPageState();
}

class _ClientAcountPageState extends State<ClientAcountPage> {
  final ClienteAccountController _con = ClienteAccountController();
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
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                   ListTile(
                    title: Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: const Image(
                        image: AssetImage(
                          "assets/images/Simplex.png",
                        ),
                        height: 50,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        const Text(
                          "¡Bienvenido a tu cuenta!",
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
                                const AssetImage("assets/images/no-avatar.png"),
                            image: _con.user?.image != null
                                ? NetworkImage(_con.user?.image)
                                : const AssetImage(
                                    "assets/images/no-avatar.png"),
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 50),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    selected: false,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Nombre del usuario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_con.user?.nombre ?? ""),
                    leading: const Icon(Icons.person),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Apellido del usuario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_con.user?.apellido ?? ""),
                    leading: const Icon(Icons.person),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Correo del usuario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_con.user?.correo ?? ""),
                    leading: const Icon(Icons.email),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Teléfono del usuario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_con.user?.telefono ?? ""),
                    leading: const Icon(Icons.phone),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: _con.goToOrdersList,
                    title: const Text(
                      "Mis pedidos",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                    leading: const Icon(Icons.shop_outlined),
                  ),
                  const Divider(),
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
                  const Divider(),
                  _con.user != null
                      ? _con.user.roles.length > 1
                          ? ListTile(
                              title: const Text(
                                "Cambiar de rol",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              subtitle: const Text(
                                "Apreta aquí para cambiar de rol",
                                style: TextStyle(color: Colors.red),
                              ),
                              leading: const Icon(Icons.admin_panel_settings,
                                  color: Colors.red),
                              trailing: const Icon(Icons.keyboard_arrow_right,
                                  color: Colors.red),
                              onTap: _con.goToRoles,
                            )
                          : Container()
                      : Container(),
                  ListTile(
                    onTap: _con.logout,
                    title: const Text(
                      "Cerrar sesión",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("Salir de la cuenta"),
                    leading: const Icon(Icons.exit_to_app_rounded),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
