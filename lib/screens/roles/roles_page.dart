import 'package:client_exhibideas/models/rol.dart';
import 'package:client_exhibideas/screens/roles/roles_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super(key: key);
  static String routeName = "/roles";

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final RolesController _con = RolesController();

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
        title: const Text("Selecciona un rol"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
        child: ListView(
            children: _con.user != null
                ? _con.user.roles.map((Rol rol) {
                    return _cardRol(rol, context);
                  }).toList()
                : []),
      ),
    );
  }

  Widget _cardRol(Rol rol, BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
      width: size.width,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(2, 2), // changes position of shadow
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFFFFF),
            MyColors.primaryColor,
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          _con.goToPage(rol.route);
        },
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.15,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(2, 2), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFFFFF),
                MyColors.primaryColor,
              ],
            ),
          ),
          child: _dataContainer(rol),
        ),
      ),
    );
  }

  Widget _dataContainer(Rol rol) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      Text(rol.nombre ?? "", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(
        height: 25,
      ),
      SizedBox(
        height: 100,
        child: FadeInImage(
          image: rol.imagen != null
              ? NetworkImage(rol.imagen)
              : const AssetImage("assets/images/noImagen.png"),
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage("assets/images/noImagen.png"),
        ),
      ),
    ]);
  }

/*  */
  void refresh() {
    setState(() {});
  }
}
