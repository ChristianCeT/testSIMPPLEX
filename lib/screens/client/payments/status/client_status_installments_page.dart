import 'package:client_exhibideas/screens/client/payments/status/client_status_installments_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ClientPaymentsStatusPage extends StatefulWidget {
  const ClientPaymentsStatusPage({Key key}) : super(key: key);

  static String routeName = "/client/payments/status";

  @override
  _ClientPaymentsStatusPageState createState() =>
      _ClientPaymentsStatusPageState();
}

class _ClientPaymentsStatusPageState extends State<ClientPaymentsStatusPage> {
  ClientPaymentsStatusController _con = new ClientPaymentsStatusController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _clipPathOval(),
          _textCardDetail(),
          _textCardMessageStatus()
        ],
      ),
      bottomNavigationBar: Container(height: 90, child: _buttoNext()),
    );
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              _con?.mercadoPagoPayment?.status == "approved"
                  ? Icon(
                      Icons.check_circle,
                      color: MyColors.primaryColor,
                      size: 150,
                    )
                  : Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 150,
                    ),
              Text(
                  _con?.mercadoPagoPayment?.status == "approved"
                      ? "Gracias por tu compra"
                      : "Error en la transacción",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22))
            ],
          ),
        ),
      ),
    );
  }

  Widget _textCardDetail() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: _con?.mercadoPagoPayment?.status == "approved"
            ? Text(
                "Tu orden fue procesada exitosamente usando (${_con.mercadoPagoPayment?.paymentMethodId?.toUpperCase() ?? ''} **** ${_con.mercadoPagoPayment?.card?.lastFourDigits ?? ''}",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center)
            : Text("Tu pago fue rechazado",
                style: TextStyle(fontSize: 17), textAlign: TextAlign.center));
  }

  Widget _textCardMessageStatus() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: _con?.mercadoPagoPayment?.status == "approved"
            ? Text("Mira el estado de tu compra en la sección de MIS PEDIDOS",
                style: TextStyle(fontSize: 17), textAlign: TextAlign.center)
            : Text(_con.errorMessage ?? '',
                style: TextStyle(fontSize: 17), textAlign: TextAlign.center));
  }

  Widget _buttoNext() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.finishShopping,
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
                height: 45,
                child: Text(
                  "FINALIZAR COMPRA",
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
                margin: EdgeInsets.only(left: 75),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
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
