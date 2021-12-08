import 'package:client_exhibideas/screens/client/address/map/client_address_map_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatefulWidget {
  ClientAddressMapPage({Key key}) : super(key: key);

  static String routeName = "/client/address/map";

  @override
  _ClientAddressMapPageState createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {
  ClientAddressMapController _con = new ClientAddressMapController();
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
          title: Text("Ubica tu dirección en el mapa"),
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            _googleMaps(),
            Container(child: iconMyLocation(), alignment: Alignment.center),
            Container(
              child: _cardAddress(),
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 30),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: _buttonAccept(),
            )
          ],
        ));
  }

  Widget _cardAddress() {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          _con.addressName ?? "",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      color: Colors.grey[800],
    ));
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(
        onPressed: _con.selectRefPoint,
        child: Text("SELECCIONAR ESTE PUNTO"),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget iconMyLocation() {
    return Image.asset(
      "assets/images/my-location.png",
      width: 65,
      height: 65,
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
