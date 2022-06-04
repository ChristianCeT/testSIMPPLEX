import 'package:flutter/material.dart';
import 'package:simpplex_app/screens/admin/users/list_users.dart';
import 'package:simpplex_app/utils/my_colors.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CardUser(
              dataParameter: "Usuarios",
              nombre: "Todos los usuarios",
              icon: Icons.people,
            ),
            CardUser(
              dataParameter: "CLIENTE",
              nombre: "Clientes",
              icon: Icons.person,
            ),
            CardUser(
              dataParameter: "REPARTIDOR",
              nombre: "Repartidores",
              icon: Icons.delivery_dining_outlined,
            ),
            CardUser(
              dataParameter: "ADMIN",
              nombre: "Administradores",
              icon: Icons.admin_panel_settings,
            ),
          ],
        ),
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
  final IconData icon;
  const CardUser({
    Key? key,
    required this.dataParameter,
    required this.nombre,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, UserScreen.routeName,
          arguments: dataParameter),
      child: Card(
        elevation: 0.2,
        shadowColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(nombre, style: const TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: MyColors.primaryColor.withOpacity(0.69),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
