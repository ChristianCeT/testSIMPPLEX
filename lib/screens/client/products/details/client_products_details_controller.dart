import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function refresh;
  Product? product;

  int counter = 1;
  double? productPrice;

  String urlMainImage = '';

  final SharedPref _sharedPref = SharedPref();

  late List<Product> selectedProducts = [];

  String url1 = '';
  String colorSeleccionado = '';
  String urlSeleccionada = "";

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.precio;
    /*  _sharedPref.remove("order");  */ //eliminar lo que hay en el sharedpreferences
    selectedProducts =
        Product.fromJsonList(await _sharedPref.read("order") ?? []).toList;

    urlMainImage = product.imagenPrincipal![0].path!;
    colorSeleccionado = product.imagenPrincipal![0].colorName!;

    refresh();
  }

  void launchURL() async {
    url1 = product!.linkRA!;
    if (!await launch(url1)) throw 'Could not launcher $url1';
    refresh();
  }

  void addToBag() {
    //TODO: fix posible error with the products

    int index = selectedProducts.indexWhere(
        (p) => p.id == product!.id && p.colorSelecionado == colorSeleccionado);

    if (urlSeleccionada.isEmpty) {
      urlSeleccionada = urlMainImage;
    }

    if (index == -1) {
      product!.cantidad ??= 1;
      product!.colorSelecionado = colorSeleccionado;
      product!.imagenPrincipalSeleccionado = urlSeleccionada;
      selectedProducts.add(product!);
      refresh();
    } else {
      for (var i = 0; i < selectedProducts.length; i++) {
        if (selectedProducts[i].id == product!.id &&
            selectedProducts[i].colorSelecionado == colorSeleccionado) {
          selectedProducts[i].cantidad =
              selectedProducts[i].cantidad! + counter;
          break;
        }
      }
      refresh();
    }

    _sharedPref.save("order", selectedProducts);
    Fluttertoast.showToast(msg: "Producto agregado al carrito");
    Navigator.pop(context);
    refresh();
  }

  void addItem() {
    if (counter < product!.stock!) {
      counter = counter + 1;
      productPrice = (product!.precio! * counter);
      product!.cantidad = counter;
    }
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter = counter - 1;
      productPrice = product!.precio! * counter;
      product!.cantidad = counter;
    }
    refresh();
  }

  void goToWhatssap(String parameter) async {
    final link = WhatsAppUnilink(
      phoneNumber: "+51920411227",
      text: "Hola, estoy interesado en el producto $parameter",
    );

    final url = Uri.parse(
      "$link",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se ha podido enlazar con $url';
    }
  }

  void close() {
    Navigator.pop(context);
  }
}
