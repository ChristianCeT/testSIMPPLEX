import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/screens/client/orders/create/client_orders_create_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientOrderCreatePage extends StatefulWidget {
  ClientOrderCreatePage({Key key}) : super(key: key);
  static String routeName = "/client/orders/create";

  @override
  _ClientOrderCreatePageState createState() => _ClientOrderCreatePageState();
}

class _ClientOrderCreatePageState extends State<ClientOrderCreatePage> {
  ClientOrdersCreateController _con = ClientOrdersCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Carrito"),
          backgroundColor: Colors.black,
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.21,
          child: Column(
            children: [
              Divider(
                color: MyColors.primaryColor,
                endIndent: 30, // margen en la parte izquierda
                indent: 30, // margen en la parte derecha
              ),
              _textTotalPrice(),
              _buttonNextShopping()
            ],
          ),
        ),
        body: _con.selectedProducts.length > 0
            ? ListView(
                children: _con.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList())
            : NoDataWidget(
                text: "Tu carrito está vacío",
              ));
  }

  Widget _buttonNextShopping() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.goToAddress,
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
                  "Continuar",
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
                margin: EdgeInsets.only(left: 103, top: 13),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product?.nombre ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              _addOrRemoveItem(product),
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _iconDelete(product),
            ],
          )
        ],
      ),
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // la fila tiene un mainaxisalignment
        children: [
          Text("Total: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Text("S/${_con.total}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: IconButton(
        onPressed: () {
          _con.deleteItem(product);
        },
        icon: Icon(Icons.delete_outline),
        color: MyColors.primaryColor,
      ),
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        "S/${product.precio * product.cantidad}",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]),
      padding: EdgeInsets.all(10),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1)
            : AssetImage("assets/images/noImagen.png"),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage("assets/images/noImagen.png"),
      ),
      height: 90,
      width: 90,
    );
  }

  Widget _addOrRemoveItem(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _con.removeItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: MyColors.primaryColor),
            child: Text(
              "-",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: MyColors.primaryColor,
          child: Text(
            "${product?.cantidad ?? 0}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            _con.addItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: MyColors.primaryColor),
            child: Text(
              "+",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
