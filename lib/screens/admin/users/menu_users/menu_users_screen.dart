import 'package:flutter/material.dart';
import 'package:simpplex_app/screens/admin/users/list_users.dart';

class MenuUsersScreen extends StatefulWidget {
  const MenuUsersScreen({Key? key}) : super(key: key);
  static const routeName = "/admin/menu/users";

  @override
  State<MenuUsersScreen> createState() => _MenuUsersScreenState();
}

class _MenuUsersScreenState extends State<MenuUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      body: Column(
        children: const [
          CardUser(
            dataParameter: "Usuarios",
            nombre: "Todos los usuarios",
          ),
          CardUser(
            dataParameter: "CLIENTE",
            nombre: "Clientes",
          ),
          CardUser(
            dataParameter: "REPARTIDOR",
            nombre: "Repartidores",
          ),
          CardUser(
            dataParameter: "ADMIN",
            nombre: "Administradores",
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class CardUser extends StatelessWidget {
  final String dataParameter;
  final String nombre;
  const CardUser({
    Key? key,
    required this.dataParameter,
    required this.nombre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, UserScreen.routeName,
          arguments: dataParameter),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(nombre),
        ),
      ),
    );
  }
}
