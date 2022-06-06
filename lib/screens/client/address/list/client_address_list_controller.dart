import 'package:simpplex_app/models/address.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/address_provider.dart';
import 'package:simpplex_app/provider/orders_provider.dart';
import 'package:simpplex_app/screens/client/address/create/client_address_create_page.dart';
import 'package:simpplex_app/screens/client/payments/create/client_payments_create_page.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function refresh;

  List<Address>? address = [];
  List<Product> selectedProducts = [];

  final AddressProvider _addressProvider = AddressProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();
/*   StripeProvider _stripeProvider = new StripeProvider(); */
  ProgressDialog? progressDialog;

  int totalAddress = 0;

  late User user;
  final SharedPref _sharedPref = SharedPref();

  int radioValue = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    selectedProducts =
        Product.fromJsonList(await _sharedPref.read("order")).toList;
    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);
    /*  _stripeProvider.init(context); */
    refresh();
  }

  void createOrder() async {
    /* progressDialog.show(max: 100, msg: "Espere un momento");
    var response = await _stripeProvider.payWithCard('${150 * 100}', 'USD');
    progressDialog.close();
    if (response.success) {
      Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
      Order order = new Order(
          cliente: user,
          direccion: a,
          producto: selectedProducts,
          estado: "PAGADO");
      ResponseApi responseApi = await _ordersProvider.create(order);
    } else {
      MySnackBar.show(context, response.message);
    } */

    Navigator.pushNamed(context, ClientPaymentsCreatePage.routeName);
  }

  void handleRadioValueChange(int? value) async {
    radioValue = value!;
    if (radioValue != value) {
      radioValue = value;
    }
    if (address != null) {
      if (radioValue == 0) {
        _sharedPref.save('address', address![0]);
      } else {
        _sharedPref.save('address', address![radioValue]);
      }
    }
    refresh();
  }

  Future<List<Address>?> getAddress() async {
    address = await _addressProvider.getByUsers();
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    if (address != null && address!.isNotEmpty) {
      int? index = address?.indexWhere((ad) => ad.id == a.id);
      if (totalAddress != address?.length) {
        totalAddress = address?.length ?? 0;
        refresh();
      }
      if (index != -1) {
        radioValue = index ?? 0;
      }

      if (address!.length == 1 && a.id != address![0].id) {
        _sharedPref.save('address', address![0]);
      }
      else {
        _sharedPref.save('address', address![radioValue]);
      }
    }

    return address;
  }

  void goToNewAddress() async {
    var result =
        await Navigator.pushNamed(context, ClientAddressCreatePage.routeName);
    if (result != null) {
      refresh();
    }
  }
}
