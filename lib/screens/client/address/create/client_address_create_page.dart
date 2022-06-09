import 'package:simpplex_app/screens/client/address/create/client_address_create_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({Key? key}) : super(key: key);

  static String routeName = "/client/address/create";

  @override
  _ClientAddressCreatePageState createState() =>
      _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  final ClientAddressCreateController _con = ClientAddressCreateController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Crear dirección"),
        ),
        bottomNavigationBar: _buttonAccept(size),
        body: Column(
          children: [
            _textCompleteData(),
            _textFieldAddress(),
            _textFieldNeighborhood(),
            _textFieldRefPoint()
          ],
        ));
  }

  Widget _buttonAccept(Size size) {
    return Container(
      height: 50,
      width: double.infinity,
      margin:
          EdgeInsets.symmetric(vertical: size.height * 0.07, horizontal: 30),
      child: ElevatedButton(
        onPressed: _con.createAddress,
        child: const Text("ACEPTAR"),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _textFieldAddress() {
    return Container(
      child: TextField(
        controller: _con.addressController,
        decoration: InputDecorations.authInputDecoration(
            hintText: "Dirección",
            labelText: "Ingresa la dirección",
            prefixIcon: Icons.location_on),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }

  Widget _textFieldNeighborhood() {
    return Container(
      child: TextField(
        controller: _con.neighborhoodController,
        decoration: InputDecorations.authInputDecoration(
            hintText: "Avenida",
            labelText: "Ingrese la avenida",
            prefixIcon: Icons.location_city),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }

  Widget _textFieldRefPoint() {
    return Container(
      child: TextField(
        controller: _con.refPointController,
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecorations.authInputDecoration(
            hintText: "Punto de referencia",
            labelText: "¡Ubica aquí tu dirección!",
            prefixIcon: Icons.map),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }

  Widget _textCompleteData() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: const Text(
        "Completa estos datos",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
