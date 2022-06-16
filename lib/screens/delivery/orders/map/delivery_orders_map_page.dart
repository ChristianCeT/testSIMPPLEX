import 'package:simpplex_app/screens/delivery/orders/assets_signature_evidence/assets_signature_evidence_screen.dart';
import 'package:simpplex_app/screens/delivery/orders/map/delivery_orders_map_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryOrdersMapPage extends StatefulWidget {
  const DeliveryOrdersMapPage({Key? key}) : super(key: key);

  static String routeName = "/delivery/orders/map";

  @override
  _DeliveryOrdersMapPageState createState() => _DeliveryOrdersMapPageState();
}

class _DeliveryOrdersMapPageState extends State<DeliveryOrdersMapPage> {
  final DeliveryOrdersMapController _con = DeliveryOrdersMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: _googleMaps()),
        SafeArea(
          child: Column(
            children: [
              _buttonCenterPosition(),
              const Spacer(),
              _cardOrderInfo(),
            ],
          ),
        ),
        Positioned(top: 40, left: 15, child: _iconGoogleMaps()),
        Positioned(top: 85, left: 15, child: _iconWaze()),
      ],
    ));
  }

  Widget _cardOrderInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, 3))
          ]),
      child: Column(
        children: [
          _listTitleAddress(_con.order?.direccion?.avenida ?? "", "Avenida",
              Icons.my_location),
          _listTitleAddress(_con.order?.direccion?.direccion ?? "", "Dirección",
              Icons.location_on),
          Divider(color: MyColors.primaryColor, endIndent: 30, indent: 30),
          _clientInfo(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _clientInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 33, vertical: 20),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: FadeInImage(
              image: _con.order?.cliente?.image != null
                  ? NetworkImage(_con.order!.cliente!.image!)
                  : const AssetImage("assets/images/noImagen.png")
                      as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage("assets/images/noImagen.png"),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                "${_con.order?.cliente?.nombre ?? ''} ${_con.order?.cliente?.apellido ?? ''} ",
                style: const TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 1,
              )),
          const Spacer(),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, SignatureEvidenceScreen.routeName);
                  },
                  child: const Text("F")),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  onPressed: _con.call,
                  icon: const Icon(Icons.phone, color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconGoogleMaps() {
    return GestureDetector(
      onTap: _con.launchGoogleMaps,
      child: Image.asset("assets/images/googlemaps.png", width: 35, height: 35),
    );
  }

  Widget _iconWaze() {
    return GestureDetector(
      onTap: _con.launchWaze,
      child: Image.asset("assets/images/wase.png", width: 35, height: 35),
    );
  }

  Widget _listTitleAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 13)),
        subtitle: const Text("Vecindario"),
        trailing: Icon(iconData),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
      child: ElevatedButton(
        onPressed: _con.updateToDelivered,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "ENTREGAR PRODUCTO",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: const CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.location_searching,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition!,
      onMapCreated: _con.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh() {
    setState(() {});
  }
}
