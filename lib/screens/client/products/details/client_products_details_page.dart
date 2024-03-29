import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/client/products/details/client_products_details_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientProductDetailsPage extends StatefulWidget {
  final Product product;
  const ClientProductDetailsPage({Key? key, required this.product})
      : super(key: key);

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
              _con.product?.linkRA == null
                  ? const SizedBox(
                      height: 60,
                    )
                  : _buttonRa(),
            ],
          ),
          _productDescription(),
          _chipsColors(),
          const Spacer(),
          _addOrRemoveItem(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _standarDelivery(),
              Container(
                margin: const EdgeInsets.only(right: 30),
                width: 45,
                height: 45,
                child: FloatingActionButton(
                  focusElevation: 0,
                  splashColor: MyColors.primaryColor.withOpacity(0.4),
                  elevation: 0,
                  backgroundColor: MyColors.primaryColor,
                  onPressed: () {
                    _con.goToWhatssap(_con.product!.nombre!);
                  },
                  child: const Icon(
                    Icons.whatsapp,
                    color: Colors.white,
                    size: 27.5,
                  ),
                ),
              ),
            ],
          ),
          _con.product != null
              ? _con.product?.disponible == true && _con.product!.stock! > 0
                  ? _buttonShoppingBag()
                  : Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 30),
                      child: const Text("Producto no disponible",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    )
              : Container(),
        ],
      ),
    );
  }

  Widget _productName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 10),
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
        margin: const EdgeInsets.only(top: 20, right: 25),
        child: OutlinedButton(
          onPressed: _con.launchURL,
          style: ElevatedButton.styleFrom(
            onPrimary: MyColors.primaryColor,
            shadowColor: const Color(0x00000001),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
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
      margin: const EdgeInsets.symmetric(horizontal: 19),
      child: Row(
        children: [
          _con.product != null
              ? _con.product!.disponible!
                  ? Row(
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
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        IconButton(
                            onPressed: _con.removeItem,
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: MyColors.primaryColor,
                              size: 30,
                            )),
                      ],
                    )
                  : const Text(
                      "Producto no disponible",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )
              : Container(),
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
/*           autoPlayInterval: 12000, */
          isLoop: true,
          children: [
            FadeInImage(
              image: _con.product?.imagenPrincipal != null
                  ? NetworkImage(_con.urlMainImage)
                  : const AssetImage("assets/images/noImagen.png")
                      as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage("assets/images/noImagen.png"),
            ),
            FadeInImage(
              image: _con.product?.image2 != null
                  ? NetworkImage(_con.product!.image2!)
                  : const AssetImage("assets/images/noImagen.png")
                      as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage("assets/images/noImagen.png"),
            ),
            FadeInImage(
              image: _con.product?.image3 != null
                  ? NetworkImage(_con.product!.image3!)
                  : const AssetImage("assets/images/noImagen.png")
                      as ImageProvider,
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _chipsColors() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(left: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Colores:",
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _con.product?.imagenPrincipal != null
                ? _con.product!.imagenPrincipal!.map((imagenPrincipalItem) {
                    final Color _colorItem = Color(
                      int.parse(
                        imagenPrincipalItem.color!.split('(')[1].split(')')[0],
                      ),
                    );
                    return Container(
                      margin: const EdgeInsets.only(
                        right: 7,
                      ),
                      padding: const EdgeInsets.all(4),
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _colorItem.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(
                            () {
                              _con.urlMainImage = imagenPrincipalItem.path!;
                              _con.colorSeleccionado =
                                  imagenPrincipalItem.colorName!;
                              _con.urlSeleccionada = imagenPrincipalItem.path!;
                            },
                          );
                        },
                        elevation: 0,
                        backgroundColor: Color(_colorItem.value),
                        child: _con.colorSeleccionado ==
                                imagenPrincipalItem.colorName!
                            ? const Icon(
                                Icons.check_sharp,
                                color: Colors.white,
                              )
                            : Container(),
                      ),
                    );
                  }).toList()
                : [],
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
