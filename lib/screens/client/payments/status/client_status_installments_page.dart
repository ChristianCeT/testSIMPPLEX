import 'package:simpplex_app/screens/client/payments/status/client_status_installments_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ClientPaymentsStatusPage extends StatefulWidget {
  const ClientPaymentsStatusPage({Key? key}) : super(key: key);

  static String routeName = "/client/payments/status";

  @override
  _ClientPaymentsStatusPageState createState() =>
      _ClientPaymentsStatusPageState();
}

class _ClientPaymentsStatusPageState extends State<ClientPaymentsStatusPage> {
  final ClientPaymentsStatusController _con = ClientPaymentsStatusController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _clipPathOval(),
          _textCardDetail(),
          _textCardMessageStatus()
        ],
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(
              horizontal: 30, vertical: size.height * 0.07),
          child: _buttoNext()),
    );
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: MyColors.primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              _con.mercadoPagoPayment?.status == "approved"
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.black,
                      size: 150,
                    )
                  : const Icon(
                      Icons.cancel,
                      color: Colors.black,
                      size: 150,
                    ),
              Text(
                _con.mercadoPagoPayment?.status == "approved"
                    ? "Gracias por tu compra"
                    : "Error en la transacción",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _textCardDetail() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: _con.mercadoPagoPayment?.status == "approved"
            ? Text(
                "Tu orden fue procesada exitosamente usando (${_con.mercadoPagoPayment?.paymentMethodId?.toUpperCase() ?? ''} **** ${_con.mercadoPagoPayment?.card?.lastFourDigits ?? ''}",
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.center)
            : const Text("Tu pago fue rechazado",
                style: TextStyle(fontSize: 17), textAlign: TextAlign.center));
  }

  Widget _textCardMessageStatus() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: _con.mercadoPagoPayment?.status == "approved"
            ? const Text(
                "Mira el estado de tu compra en la sección de MIS PEDIDOS",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center)
            : Text(_con.errorMessage ?? '',
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.center));
  }

  Widget _buttoNext() {
    return ElevatedButton(
      onPressed: _con.finishShopping,
      style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.arrow_forward,
                size: 22,
              ),
            ),
            Text(
              "FINALIZAR COMPRA",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
