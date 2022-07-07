import 'dart:async';
import 'package:simpplex_app/api/enviroment.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/providers.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:location/location.dart" as location;
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClientOrdersMapController {
  late BuildContext context;
  late Function refresh;
  Position? _position;
  String? addressName;
  late LatLng addressLaglng;

  CameraPosition? initialPosition = const CameraPosition(
      target: LatLng(-11.991651, -77.0147332), zoom: 20); // zoom del 1 al 20

  final Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final OrdersProvider _ordersProvider = OrdersProvider();
  late User user;
  final SharedPref _sharedPref = SharedPref();
  Order? order;
  double? _distanceBetween;
  IO.Socket? socket;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order.fromJson(ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>); // obtener datos de un argumento de la orden
    deliveryMarker =
        await createMarketFromAssets('assets/images/delivery3.png');
    homeMarker = await createMarketFromAssets('assets/images/home1.png');

    socket = IO.io(
        'http://${Enviroment.apiProduction}/orders/delivery', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket?.connect();

    socket?.on('posicion/${order?.id}', (data) {
      print(data);
      addMarker("Delivery", data["latitud"], data["longitud"], "Tu repartidor",
          "", deliveryMarker!);
    }); // leer info de socket io

    user = User.fromJson(await _sharedPref.read("user"));
    _ordersProvider.init(context, user);
    print("ORDEN: ${order?.toJson()}");
    checkGPS();
  }

  void isCloseToDeliveredPosition() {
    _distanceBetween = Geolocator.distanceBetween(
        _position!.latitude,
        _position!.longitude,
        order!.direccion!.latitud!,
        order!.direccion!.longitud!);

    print("----Distancia ${_distanceBetween} ---------");
  }

  void addMarker(String markerId, double lat, double long, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: title, snippet: content));

    markers[id] = marker;
    refresh();
  }

  // geocoder: ^0.2.1 si algo no funciona

  void selectRefPoint() async {
    Map<String, dynamic> data = {
      "address": addressName,
      "lat": addressLaglng.latitude,
      "lng": addressLaglng.longitude,
    };
// pasar la informacion al navigator cerrando la pestaña
    Navigator.pop(context, data);
  }

  Future<BitmapDescriptor> createMarketFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  Future<void> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition!.target.latitude;
      double long = initialPosition!.target.longitude;
      List<Placemark> address = await placemarkFromCoordinates(lat, long);

      if (address != null) {
        if (address.isNotEmpty) {
          String direction = address[0].thoroughfare!;
          String street = address[0].subThoroughfare!;
          String city = address[0].locality!;
          String deparment = address[0].administrativeArea!;
          /* String country = address[0].country; */
          addressName = '$direction #$street, $city, $deparment';
          addressLaglng = LatLng(lat, long);

          refresh();
        }
      }
    }
  }

  void onMapCreate(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void dispose() {
    socket?.disconnect();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER LA POSICIÓN ACTUAL Y SOLICITAR PERMISOS
      _position = await Geolocator
          .getLastKnownPosition(); // obtener la ultima posicion del dispositivo la latitud y longitud actual es lo que devuelve
      animatedCameraToPosition(_position!.latitude, _position!.longitude);
      /*  addMarker("Delivery", _position.latitude, _position.longitude,
          "Tu posición", "", deliveryMarker); */
      addMarker("Home", order!.direccion!.latitud!, order!.direccion!.longitud!,
          "Lugar de entrega", "", homeMarker!);

      //setPolylines
      refresh();

      animatedCameraToPosition(_position!.latitude, _position!.longitude);
      isCloseToDeliveredPosition();
      refresh();
    } catch (e) {
      print("ERROR $e");
    }
  }

  void call() {
    launch("tel://${order?.cliente?.telefono}");
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      //requerir que el usuario habilite el GPs
      bool locationGPS = await location.Location()
          .requestService(); // solicitar al usuario activar el gps para continuar
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future animatedCameraToPosition(double lat, double long) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 15, bearing: 0),
      ));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled; // para saber si la localizacion está activada GPS
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
