import 'package:client_exhibideas/screens/client/address/create/client_address_create_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientAddressCreatePage extends StatefulWidget {
  ClientAddressCreatePage({Key key}) : super(key: key);

  static String routeName = "/client/address/create";

  @override
  _ClientAddressCreatePageState createState() =>
      _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  ClientAddressCreateController _con = new ClientAddressCreateController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Crear dirección"), backgroundColor: Colors.black),
        bottomNavigationBar: _buttonAccept(),
        body: Column(
          children: [
            _textCompleteData(),
            _textFieldAddress(),
            _textFieldNeighborhood(),
            _textFieldRefPoint()
          ],
        ));
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.createAddress,
        child: Text("ACEPTAR"),
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
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyColors.primaryColor),
          labelText: "Dirección",
          suffixIcon: Icon(
            Icons.location_on,
            color: Colors.black,
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }

  Widget _textFieldNeighborhood() {
    return Container(
      child: TextField(
        controller: _con.neighborhoodController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyColors.primaryColor),
          labelText: "Avenida",
          suffixIcon: Icon(
            Icons.location_city,
            color: Colors.black,
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }

  Widget _textFieldRefPoint() {
    return Container(
      child: TextField(
        controller: _con.refPointController,
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: MyColors.primaryColor),
          labelText: "Punto de referencia",
          suffixIcon: Icon(
            Icons.map,
            color: Colors.black,
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }

  Widget _textCompleteData() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
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
