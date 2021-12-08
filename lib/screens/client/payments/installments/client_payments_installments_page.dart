import 'package:client_exhibideas/models/mercado_pago/mercado_pago_installment.dart';
import 'package:client_exhibideas/screens/client/payments/installments/client_payments_installments_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientPaymentsInstallmentsPage extends StatefulWidget {
  const ClientPaymentsInstallmentsPage({Key key}) : super(key: key);

  static String routeName = "/client/payments/installments";

  @override
  _ClientPaymentsInstallmentsPageState createState() =>
      _ClientPaymentsInstallmentsPageState();
}

class _ClientPaymentsInstallmentsPageState
    extends State<ClientPaymentsInstallmentsPage> {
  ClientPaymentsInstallmentsController _con =
      new ClientPaymentsInstallmentsController();

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
        title: Text("Cuotas"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_textDescription(), _dropDownInstallments()],
      ),
      bottomNavigationBar: Container(
        height: 140,
        child: Column(
          children: [
            _textTotalPrice(),
            _buttoNext(),
          ],
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text("¿En cuántas cuotas?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total a pagar:",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_con?.totalPayment}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buttoNext() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.createPay,
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
                  "CONFIRMAR PAGO",
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
                margin: EdgeInsets.only(left: 80, top: 11),
                child: Icon(
                  Icons.attach_money_outlined,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDownInstallments() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,
                      )),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text("Seleccionar número de cuotas",
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  items: _dropDownItems(_con?.installmentsList),
                  value: _con?.selectedInstallment,
                  onChanged: (option) {
                    setState(() {
                      _con?.selectedInstallment = option;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoInstallment> installmentsList) {
    List<DropdownMenuItem<String>> list = [];
    installmentsList?.forEach((installment) {
      list.add(DropdownMenuItem(
        child: Container(
          child: Text('${installment?.installments}'),
        ),
        value: '${installment?.installments}',
      ));
    });

    return list;
  }

  void refresh() {
    setState(() {});
  }
}
