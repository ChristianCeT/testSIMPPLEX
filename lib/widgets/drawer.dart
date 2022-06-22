import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final String? image;
  final String nombre;
  final String apellido;
  final String correo;
  final String telefono;
  final Widget? items;
  const DrawerMenu(
      {Key? key,
      this.image,
      required this.nombre,
      required this.apellido,
      required this.correo,
      required this.telefono,
      this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: image == null || image!.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Text(
                            nombre.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                        )
                      : FadeInImage(
                          image: NetworkImage(image!),
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 50),
                          placeholder:
                              const AssetImage("assets/images/no-avatar.png"),
                        ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '$nombre $apellido',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // no puede ocupar mas de una linea
                ),
                Text(
                  correo,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // no puede ocupar mas de una linea
                ),
                Text(
                  telefono,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // no puede ocupar mas de una linea
                ),
              ],
            ),
          ),
          (items != null)
              ? Container(
                  child: items,
                )
              : Container(),
        ],
      ),
    );
  }
}

class MenuIconDrawer extends StatelessWidget {
  final Function() openDrawer;
  const MenuIconDrawer({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.menu_sharp, color: MyColors.primaryColor),
      ),
    );
  }
}
