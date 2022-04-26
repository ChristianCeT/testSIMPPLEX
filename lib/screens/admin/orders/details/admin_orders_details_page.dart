import 'package:client_exhibideas/models/orders.dart';
import 'package:client_exhibideas/models/product.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/screens/admin/orders/details/admin_orders_details_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/utils/relative_time_util.dart';
import 'package:client_exhibideas/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminOrdersDetailsPage extends StatefulWidget {
  Order order;
  AdminOrdersDetailsPage({Key key, @required this.order}) : super(key: key);

  @override
  _AdminOrdersDetailsState createState() => _AdminOrdersDetailsState();
}

class _AdminOrdersDetailsState extends State<AdminOrdersDetailsPage> {
  final AdminOrdersDetailsController _con = AdminOrdersDetailsController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pedido ${_con.order?.id ?? ''}",
            maxLines: 2,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(top: 18, right: 15),
              child: Text("Total: S/${_con.total}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
          backgroundColor: Colors.black,
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
                _textDescription(),
                _con.order?.estado != "PAGADO"
                    ? _deliveryData()
                    : Container(),
                _con.order?.estado == "PAGADO"
                    ? _con.users != null
                        ? _dropDown(_con?.users)
                        : ''
                    : Container(),
                _textData("Cliente:",
                    '${_con.order?.cliente?.nombre ?? ''} ${_con.order?.cliente?.apellido ?? ''}'),
                _textData("Entregar en:",
                    _con.order?.direccion?.direccion ?? ''),
                _textData("Fecha de pedido:",
                    RelativeTimeUtil.getRelativeTime(_con.order?.fecha ?? 0)),
                _con.order?.estado == "PAGADO" ? _buttonNext() : Container(),
              ],
            ),
          ),
        ),
        body: _con.order?.producto == null
            ? NoDataWidget(
                text: "Tu carrito está vacío",
              )
            : _con.order.producto.isNotEmpty
                ? ListView(
                    children: _con.order.producto.map((Product producto) {
                    return _cardProduct(producto);
                  }).toList())
                : NoDataWidget(
                    text: "Tu carrito está vacío",
                  ));
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
          _con.order?.estado == "PAGADO"
              ? "Asignar repartidor"
              : "Repartidor asignado",
          style: TextStyle(
              color: MyColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _dropDown(List<User> users) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 9),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButton(
                underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColor,
                    )),
                elevation: 3,
                isExpanded: true,
                hint: const Text("Repartidor",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                items: _dropDownItems(users),
                value: _con?.idDelivery,
                onChanged: (option) {
                  setState(() {
                    _con?.idDelivery = option;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _deliveryData() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            child: FadeInImage(
              image: _con.order?.deliveryList?.image != null
                  ? NetworkImage(_con.order?.deliveryList?.image)
                  : AssetImage("assets/images/noImagen.png"),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage("assets/images/noImagen.png"),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
              '${_con.order?.deliveryList?.nombre ?? ''} ${_con.order?.deliveryList?.apellido ?? ''}')
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image)
                    : AssetImage("assets/images/noImagen.png"),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage("assets/images/noImagen.png"),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text('${user?.nombre ?? ''} ${user?.apellido ?? ''}')
          ],
        ),
        value: user?.id,
      ));
    });

    return list;
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
                height: 40,
                child: Text(
                  "DESPACHAR PEDIDO",
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
