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
  final ClientPaymentsInstallmentsController _con =
      ClientPaymentsInstallmentsController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuotas"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_textDescription(), _dropDownInstallments()],
      ),
      bottomNavigationBar: SizedBox(
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
      margin: const EdgeInsets.all(20),
      child: const Text("¿En cuántas cuotas?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total a pagar:",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_con?.totalPayment}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buttoNext() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.createPay,
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
                  Icons.attach_money_outlined,
                  size: 22,
                ),
              ),
              Text(
                "CONFIRMAR PAGO",
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

  Widget _dropDownInstallments() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,
                      )),
                  elevation: 3,
                  isExpanded: true,
                  hint: const Text("Seleccionar número de cuotas",
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
    for (var installment in installmentsList) {
      list.add(DropdownMenuItem(
        child: Text('${installment?.installments}'),
        value: '${installment?.installments}',
      ));
    }

    return list;
  }

  void refresh() {
    setState(() {});
  }
}
