import 'package:client_exhibideas/models/address.dart';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/address_provider.dart';
import 'package:client_exhibideas/screens/client/address/map/client_address_map_page.dart';
import 'package:client_exhibideas/utils/my_snackbar.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();

  Map<String, dynamic> refPoint;

  AddressProvider _addressProvider = new AddressProvider();
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));
    _addressProvider.init(context, user);
  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    double lat = refPoint["lat"] ?? 0;
    double lng = refPoint["lng"] ?? 0;

    if (addressName.isEmpty || neighborhood.isEmpty || lat == 0 || lng == 0) {
      MySnackBar.show(context, "Completa todos los campos");
      return;
    }

    Address address = new Address(
      direccion: addressName,
      avenida: neighborhood,
      latitud: lat,
      longitud: lng,
      usuario: user.id,
    );

    ResponseApi responseApi = await _addressProvider.create(address);

    if (responseApi.success) {
      address.id = responseApi.data;
      Fluttertoast.showToast(msg: responseApi.message);
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
      refPointController.text = refPoint["address"];
      refresh();
    }
  }
}
