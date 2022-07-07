import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/admin/orders/details/admin_orders_details_controller.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AdminOrdersDetailsPage extends StatefulWidget {
  final Order order;
  const AdminOrdersDetailsPage({Key? key, required this.order})
      : super(key: key);

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
            child: Text(
              "Total: S/${_con.total}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
        backgroundColor: MyColors.primaryColor,
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: MyColors.primaryColor,
                endIndent: 30,
                indent: 30,
                thickness: 1.8,
              ),
              _textDescription(),
              _con.order?.estado != "PAGADO" ? _deliveryData() : Container(),
              _con.order?.estado == "PAGADO" && _con.user != null
                  ? _dropDown(_con.users)
                  : Container(),
              _textData("Cliente:",
                  '${_con.order?.cliente?.nombre ?? ''} ${_con.order?.cliente?.apellido ?? ''}'),
              _textData("Entregar en:", _con.order?.direccion?.direccion ?? ''),
              _textData("Fecha de pedido:",
                  RelativeTimeUtil.getRelativeTime(_con.order?.fecha ?? 0)),
              _con.order?.estado == "PAGADO" ? _buttonNext() : Container(),
              _con.order?.estado == "ENTREGADO"
                  ? _modalEvidences()
                  : Container()
            ],
          ),
        ),
      ),
      body: _con.order?.producto == null
          ? const NoDataWidget(
              text: "Tu carrito está vacío",
            )
          : _con.order!.producto!.isNotEmpty
              ? ListView(
                  children: _con.order!.producto!.map((Product producto) {
                  return _cardProduct(producto);
                }).toList())
              : const NoDataWidget(
                  text: "Tu carrito está vacío",
                ),
    );
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
                value: _con.idDelivery,
                onChanged: (String? option) {
                  setState(() {
                    _con.idDelivery = option;
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
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
            ),
            child: FadeInImage(
              image: _con.order != null
                  ? NetworkImage(_con.order!.deliveryList!.image!)
                  : const AssetImage("assets/images/no-avatar.png")
                      as ImageProvider,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(seconds: 1),
              placeholder: const AssetImage("assets/images/no-avatar.png"),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
              '${_con.order?.deliveryList?.nombre ?? ''} ${_con.order?.deliveryList?.apellido ?? ''}')
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    for (var user in users) {
      list.add(DropdownMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
              ),
              child: FadeInImage(
                image: _con.user != null
                    ? NetworkImage(user.image!)
                    : const AssetImage("assets/images/no-avatar.png")
                        as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(microseconds: 40),
                placeholder: const AssetImage("assets/images/no-avatar.png"),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '${user.nombre ?? ''} ${user.apellido ?? ''}',
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
        value: user.id,
      ));
    }

    return list;
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
            primary: MyColors.primaryColor,
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
                child: const Text(
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

  Widget _modalEvidences() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  MyColors.primaryColor.withOpacity(0.1)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            onPressed: () {
              _con.showBottomSheet();
            },
            child: Row(children: [
              Icon(
                Icons.remove_red_eye_outlined,
                color: MyColors.primaryColor,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                "Evidencias",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.primaryColor,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  void refresh() {
    if (mounted) setState(() {});
  }
}
