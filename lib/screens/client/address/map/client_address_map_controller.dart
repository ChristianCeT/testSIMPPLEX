import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:location/location.dart" as location;

class ClientAddressMapController {
  late BuildContext context;
  late Function refresh;
  Position? _position;
  String? addressName;
  late LatLng addressLaglng;

  CameraPosition? initialPosition = const CameraPosition(
      target: LatLng(-11.991651, -77.0147332), zoom: 1); // zoom del 1 al 20

  final Completer<GoogleMapController> _mapController = Completer();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
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

  Future setLocationDraggableInfo() async {
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

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER LA POSICIÓN ACTUAL Y SOLICITAR PERMISOS
      _position = await Geolocator
          .getLastKnownPosition(); // obtener la ultima posicion del dispositivo la latitud y longitud actual es lo que devuelve
      animatedCameraToPosition(_position!.latitude, _position!.longitude);
    } catch (e) {
      print("ERROR $e");
    }
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
