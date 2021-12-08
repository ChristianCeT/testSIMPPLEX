import 'package:client_exhibideas/models/rol.dart';
import 'package:client_exhibideas/screens/roles/roles_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RolesPage extends StatefulWidget {
  RolesPage({Key key}) : super(key: key);
  static String routeName = "/roles";

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  RolesController _con = new RolesController();

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
        title: Text("Selecciona un rol"),
        backgroundColor: MyColors.primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
        child: ListView(
            children: _con.user != null
                ? _con.user.roles.map((Rol rol) {
                    return _cardRol(rol);
                  }).toList()
                : []),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () {
        _con.goToPage(rol.route);
      },
      child: Column(children: [
        Container(
          height: 100,
          // nos da una animación
          child: FadeInImage(
            image: rol.imagen != null
                ? NetworkImage(rol.imagen)
                : AssetImage("assets/images/noImagen.png"),
            fit: BoxFit.contain,
            fadeInDuration: Duration(milliseconds: 50),
            placeholder: AssetImage("assets/images/noImagen.png"),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(rol.nombre ?? "",
            style: TextStyle(fontSize: 16, color: Colors.black)),
        SizedBox(
          height: 25,
        ),
      ]),
    );
  }

  void refresh() {
    setState(() {});
  }
}
