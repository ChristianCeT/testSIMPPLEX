import 'package:simpplex_app/models/address.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/screens/client/address/list/client_address_list_controller.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

String listaddress() {
  ClientAddressListController clientAddressListController =
      ClientAddressListController();

  List<Address> directions = [Address(), Address()];

  clientAddressListController.address = directions;

  if (clientAddressListController.address.isNotEmpty) {
    return "Mostrar direcciones";
  } else {
    return "No mostrar nada";
  }
}

void main() {
  test("testProductDireccion", () {
    final resp = listaddress();
    expect(resp, equals("Mostrar direcciones"));
  });

  test("ValidationProducts", () async {
    SharedPref sharedPref = SharedPref();

    List? selectedProduct = [];


    List? products = [Product(id: "1234")];

    //shared preferences
    sharedPref.save("order", products);

    selectedProduct = await sharedPref.read("order");

    expect(selectedProduct?.isNotEmpty, true);
  });
}
