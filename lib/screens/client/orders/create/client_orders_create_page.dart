import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/screens/client/orders/create/client_orders_create_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientOrderCreatePage extends StatefulWidget {
  const ClientOrderCreatePage({Key? key}) : super(key: key);
  static String routeName = "/client/orders/create";

  @override
  _ClientOrderCreatePageState createState() => _ClientOrderCreatePageState();
}

class _ClientOrderCreatePageState extends State<ClientOrderCreatePage> {
  final ClientOrdersCreateController _con = ClientOrdersCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Carrito"),
        ),
        bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height * 0.21,
            child: _con.selectedProducts.isEmpty
                ? const Text(
                    "Aún no tienes productos en tu carrito :(",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    children: [
                      Divider(
                        color: MyColors.primaryColor,
                        endIndent: 30, // margen en la parte izquierda
                        indent: 30, // margen en la parte derecha
                      ),
                      _textTotalPrice(),
                      _buttonNextShopping(),
                    ],
                  )),
        body: _con.selectedProducts.isNotEmpty
            ? ListView(
                children: _con.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList())
            : const NoDataWidget(
                text: "Tu carrito está vacío",
              ));
  }

  Widget _buttonNextShopping() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: _con.goToAddress,
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
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 22,
                ),
              ),
              Text(
                "Continuar",
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

  Widget _cardProduct(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.nombre ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              _addOrRemoveItem(product),
            ],
          ),
          const Spacer(),
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
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // la fila tiene un mainaxisalignment
        children: [
          const Text("Total: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Text("S/${_con.total}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: IconButton(
        onPressed: () {
          _con.deleteItem(product);
        },
        icon: const Icon(Icons.delete_outline),
        color: MyColors.primaryColor,
      ),
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        "S/${product.precio! * product.cantidad!}",
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: MyColors.primaryColor.withOpacity(0.15)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1!)
            : const AssetImage("assets/images/noImagen.png") as ImageProvider,
        fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 50),
        placeholder: const AssetImage("assets/images/noImagen.png"),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: MyColors.primaryColor),
            child: const Text(
              "-",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: MyColors.primaryColor,
          child: Text(
            "${product.cantidad ?? 0}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            _con.addItem(product);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: MyColors.primaryColor),
            child: const Text(
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
