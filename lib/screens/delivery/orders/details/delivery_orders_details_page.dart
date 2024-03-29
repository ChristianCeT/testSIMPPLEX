import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/delivery/orders/details/delivery_orders_details_controller.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DeliveryOrdersDetailsPage extends StatefulWidget {
  final Order order;
  const DeliveryOrdersDetailsPage({Key? key, required this.order})
      : super(key: key);

  @override
  _DeliveryOrdersDetailsState createState() => _DeliveryOrdersDetailsState();
}

class _DeliveryOrdersDetailsState extends State<DeliveryOrdersDetailsPage> {
  final DeliveryOrdersDetailsController _con =
      DeliveryOrdersDetailsController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int indexData = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pedido $indexData",
            maxLines: 2,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(top: 18, right: 15),
              child: Text("Total: S/${_con.total}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
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
                _textData(
                    "Entregar en:", _con.order?.direccion?.direccion ?? ''),
                _textData("Fecha de pedido:",
                    RelativeTimeUtil.getRelativeTime(_con.order?.fecha ?? 0)),
                _con.order?.estado != "ENTREGADO" ? _buttonNext() : Container(),
              ],
            ),
          ),
        ),
        body: _con.order?.producto == null
            ? const NoDataWidget(
                text: "Tu carrito está vacío",
              )
            : _con.order?.producto != null
                ? ListView(
                    children: _con.order!.producto!.map((Product producto) {
                    return _cardProduct(producto);
                  }).toList())
                : const NoDataWidget(
                    text: "Tu carrito está vacío",
                  ));
  }

  Widget _textData(String title, String content) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
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
      margin: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        style: ElevatedButton.styleFrom(
            primary:
                _con.order?.estado == "DESPACHADO" ? Colors.blue : Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 2),
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
                  _con.order?.estado == "DESPACHADO"
                      ? "INICIAR ENTREGA"
                      : "IR AL MAPA",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 62, top: 9),
                child: const Icon(
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _imageProduct(producto),
              const SizedBox(
                width: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(producto.descripcion!,
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 5),
                  Text("(${producto.colorSelecionado})",
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: MyColors.primaryColor,
            ),
            child: Text(
              "x${producto.cantidad}",
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product producto) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: MyColors.primaryColor.withOpacity(0.6)),
      padding: const EdgeInsets.all(5),
      child: FadeInImage(
        image: producto.imagenPrincipalSeleccionado != null
            ? NetworkImage(producto.imagenPrincipalSeleccionado!)
            : const AssetImage("assets/images/noImagen.png") as ImageProvider,
        fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 40),
        placeholder: const AssetImage("assets/images/noImagen.png"),
      ),
      height: 50,
      width: 50,
    );
  }

  void refresh() {
    setState(() {});
  }
}
