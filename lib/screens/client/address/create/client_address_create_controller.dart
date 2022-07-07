import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/providers.dart';
import 'package:simpplex_app/screens/client/address/map/client_address_map_page.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  late BuildContext context;
  late Function refresh;

  TextEditingController refPointController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();

  Map<String, dynamic>? refPoint;

  final AddressProvider _addressProvider = AddressProvider();
  late User user;
  final SharedPref _sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));
    _addressProvider.init(context, user);
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    double lat = refPoint!["lat"] ?? 0;
    double lng = refPoint!["lng"] ?? 0;

    if (addressName.isEmpty || neighborhood.isEmpty || lat == 0 || lng == 0) {
      MySnackBar.show(context, "Completa todos los campos");
      return;
    }

    Address address = Address(
      direccion: addressName,
      avenida: neighborhood,
      latitud: lat,
      longitud: lng,
      usuario: user.id,
    );

    ResponseApi? responseApi = await _addressProvider.create(address);
    if (responseApi == null) return;

    if (responseApi.success!) {
      address.id = responseApi.data;
      Fluttertoast.showToast(msg: responseApi.message!);
      Navigator.pop(context, true);
    }
  }

  void openMap() async {
    refPoint = await showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (context) => ClientAddressMapPage());
    if (refPoint != null) {
      refPointController.text = refPoint!["address"];
      refresh();
    }
  }
}
