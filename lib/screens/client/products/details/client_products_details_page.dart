import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/screens/client/products/details/client_products_details_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
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
  ClientProductDetailController _con = new ClientProductDetailController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Spacer(),
          _addOrRemoveItem(),
          _standarDelivery(),
          _buttonShoppingBag()
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
            padding: EdgeInsets.symmetric(vertical: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  "AGREGAR AL CARRITO",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 52, top: 13),
                child: Icon(
                  Icons.shopping_cart_sharp,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(_con.product?.descripcion ?? "",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          )),
    );
  }

  Widget _standarDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            "assets/images/delivery.png",
            height: 25,
          ),
          SizedBox(
            width: 7,
          ),
          Text("Envio estándar",
              style: TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _addOrRemoveItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.grey,
                size: 30,
              )),
          Text(
            "${_con.counter}",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
                size: 30,
              )),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              "S/${_con.productPrice ?? 0}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  : AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage("assets/images/noImagen.png"),
            ),
            FadeInImage(
              image: _con.product?.image2 != null
                  ? NetworkImage(_con.product.image2)
                  : AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage("assets/images/noImagen.png"),
            ),
            FadeInImage(
              image: _con.product?.image3 != null
                  ? NetworkImage(_con.product.image3)
                  : AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage("assets/images/noImagen.png"),
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
