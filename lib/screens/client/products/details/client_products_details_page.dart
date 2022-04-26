import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/screens/client/products/details/client_products_details_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/web_view_ra.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientProductDetailsPage extends StatefulWidget {
  Product product;
  ClientProductDetailsPage({Key key, @required this.product})
      : super(key: key); //@required obligatorio

  @override
  _ClientProductDetailsPageState createState() =>
      _ClientProductDetailsPageState();
}

class _ClientProductDetailsPageState extends State<ClientProductDetailsPage> {
  final ClientProductDetailController _con = ClientProductDetailController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _imageSlideshow(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _productName(),
              _buttonRa(),
            ],
          ),
          _productDescription(),
          TextButton(onPressed: () {
            Navigator.pushNamed(context, WebViewRa.routeName, arguments: _con.product.linkRA);
          }, child: const Text("prueba")),
          const Spacer(),
          _addOrRemoveItem(),
          _standarDelivery(),
          _buttonShoppingBag(),
        ],
      ),
    );
  }

  Widget _productName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Text(_con.product?.nombre ?? "",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buttonRa() {
    return Container(
        width: 80,
        margin: const EdgeInsets.only(top: 40, right: 25),
        child: ElevatedButton(
          onPressed: _con.launchURL,
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: MyColors.primaryColor,
              shadowColor: const Color(0x00000001)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.remove_red_eye,
                color: MyColors.primaryColor,
              ),
              Text(
                "RA",
                style: TextStyle(
                    color: MyColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }

  Widget _buttonShoppingBag() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.addToBag,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.add_shopping_cart,
                  size: 22,
                ),
              ),
              Text(
                "AGREGAR AL CARRITO",
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

  Widget _productDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(_con.product?.descripcion ?? "",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          )),
    );
  }

  Widget _standarDelivery() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            "assets/images/delivery.png",
            height: 25,
          ),
          const SizedBox(
            width: 7,
          ),
          const Text("Envio estándar",
              style: TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _addOrRemoveItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                Icons.add_circle_outline,
                color: MyColors.primaryColor,
                size: 30,
              )),
          Text(
            "${_con.counter}",
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline,
                color: MyColors.primaryColor,
                size: 30,
              )),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              "S/ ${_con.productPrice ?? 0}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageSlideshow() {
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          initialPage: 0,
          indicatorColor: MyColors.primaryColor,
          indicatorBackgroundColor: Colors.grey,
          onPageChanged: (value) {
            debugPrint('Page changed: $value');
          },
          autoPlayInterval: 6000,
          isLoop: true,
          children: [
            FadeInImage(
              image: _con.product?.image1 != null
                  ? NetworkImage(_con.product.image1)
                  : const AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage("assets/images/noImagen.png"),
            ),
            FadeInImage(
              image: _con.product?.image2 != null
                  ? NetworkImage(_con.product.image2)
                  : const AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage("assets/images/noImagen.png"),
            ),
            FadeInImage(
              image: _con.product?.image3 != null
                  ? NetworkImage(_con.product.image3)
                  : const AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage("assets/images/noImagen.png"),
            ),
          ],
        ),
        Positioned(
            left: 10,
            child: IconButton(
                onPressed: _con.close,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.primaryColor,
                ))),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
