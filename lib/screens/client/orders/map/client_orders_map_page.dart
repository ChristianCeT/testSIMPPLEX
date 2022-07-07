import 'package:simpplex_app/screens/client/orders/map/client_orders_map_controller.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientOrdersMapPage extends StatefulWidget {
  const ClientOrdersMapPage({Key? key}) : super(key: key);

  static String routeName = "/client/orders/map";

  @override
  _ClientOrdersMapPageState createState() => _ClientOrdersMapPageState();
}

class _ClientOrdersMapPageState extends State<ClientOrdersMapPage> {
  final ClientOrdersMapController _con = ClientOrdersMapController();

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
            height: MediaQuery.of(context).size.height * 0.67,
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
      ],
    ));
  }

  Widget _cardOrderInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
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
          _listTitleAddress(
              _con.order?.direccion?.avenida, "Avenida", Icons.my_location),
          _listTitleAddress(_con.order?.direccion?.direccion!, "Dirección",
              Icons.location_on),
          Divider(color: MyColors.primaryColor, endIndent: 30, indent: 30),
          _clientInfo(),
        ],
      ),
    );
  }

  Widget _clientInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
                "${_con.order?.deliveryList?.nombre ?? ''} ${_con.order?.deliveryList?.apellido ?? ''} ",
                style: const TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 1,
              )),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[300],
            ),
            child: IconButton(
                onPressed: _con.call,
                icon: const Icon(Icons.phone, color: Colors.black)),
          )
        ],
      ),
    );
  }

  Widget _listTitleAddress(String? title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(title ?? '', style: const TextStyle(fontSize: 13)),
        subtitle: const Text("Vecindario"),
        trailing: Icon(iconData),
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
