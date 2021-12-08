import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/screens/delivery/orders/details/delivery_orders_details_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/utils/relative_time_util.dart';
import 'package:client_exhibideas/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DeliveryOrdersDetailsPage extends StatefulWidget {
  Order order;
  DeliveryOrdersDetailsPage({Key key, @required this.order}) : super(key: key);

  @override
  _DeliveryOrdersDetailsState createState() => _DeliveryOrdersDetailsState();
}

class _DeliveryOrdersDetailsState extends State<DeliveryOrdersDetailsPage> {
  DeliveryOrdersDetailsController _con = DeliveryOrdersDetailsController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pedido ${_con.order?.id ?? ''}",
            maxLines: 2,
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(top: 18, right: 15),
              child: Text("Total: S/${_con.total}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(
                    color: MyColors.primaryColor,
                    endIndent: 30, // margen en la parte izquierda
                    indent: 30, // margen en la parte derecha
                  ),
                  _textData("Cliente:",
                      '${_con.order?.cliente?.nombre ?? ''} ${_con.order?.cliente?.apellido ?? ''}'),
                  _textData("Entregar en:",
                      '${_con.order?.direccion?.direccion ?? ''}'),
                  _textData("Fecha de pedido:",
                      "${RelativeTimeUtil.getRelativeTime(_con.order?.fecha ?? 0)}"),
                  _con?.order?.estado != "ENTREGADO"
                      ? _buttonNext()
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        body: _con.order?.producto == null
            ? NoDataWidget(
                text: "Tu carrito está vacío",
              )
            : _con.order.producto.length > 0
                ? ListView(
                    children: _con.order.producto.map((Product producto) {
                    return _cardProduct(producto);
                  }).toList())
                : NoDataWidget(
                    text: "Tu carrito está vacío",
                  ));
  }

  Widget _textData(String title, String content) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            content,
            maxLines: 2,
          ),
        ));
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        style: ElevatedButton.styleFrom(
            primary: _con?.order?.estado == "DESPACHADO"
                ? Colors.blue
                : Colors.green,
            padding: EdgeInsets.symmetric(vertical: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  _con?.order?.estado == "DESPACHADO"
                      ? "INICIAR ENTREGA"
                      : "IR AL MAPA",
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
                margin: EdgeInsets.only(left: 62, top: 9),
                child: Icon(
                  Icons.directions_car,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardProduct(Product producto) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(producto),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(producto?.nombre ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text("Cantidad: ${producto.cantidad}",
                  style: TextStyle(fontSize: 13)),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product producto) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]),
      padding: EdgeInsets.all(5),
      child: FadeInImage(
        image: producto.image1 != null
            ? NetworkImage(producto.image1)
            : AssetImage("assets/images/noImagen.png"),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage("assets/images/noImagen.png"),
      ),
      height: 50,
      width: 50,
    );
  }

  void refresh() {
    setState(() {});
  }
}
