import 'package:client_exhibideas/models/mercado_pago/mercado_pago_document_type.dart';
import 'package:client_exhibideas/screens/client/payments/create/client_payments_create_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/input_decorations_card_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  const ClientPaymentsCreatePage({Key? key}) : super(key: key);

  static String routeName = "/client/payments/create";

  @override
  _ClientPaymentsCreatePageState createState() =>
      _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {
  final ClientPaymentsCreateController _con = ClientPaymentsCreateController();

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
        title: const Text("Pagos"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            onCreditCardWidgetChange: (CreditCardBrand card) {
              print("ADSAD ${card.brandName}");
            },
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            showBackView: _con.isCvvFocused,
            cardBgColor: MyColors.primaryColor,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            isChipVisible: false,
            isSwipeGestureEnabled: true,
            animationDuration: const Duration(milliseconds: 1000),
            labelCardHolder: "NOMBRE Y APELLIDO",
          ),
          CreditCardForm(
            formKey: _con.keyForm, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            themeColor: MyColors.primaryColor,
            obscureCvv: true,
            cvvCode: '',
            expiryDate: '',
            cardHolderName: '',
            cardNumber: '',
            obscureNumber: true,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            cardNumberDecoration:
                InputDecorationsPayment.paymentInputDecoration(
              hintText: "Número de tarjeta",
              labelText: "Ingresa el número de la tarjeta",
              prefixIcon: Icons.credit_card,
            ),
            expiryDateDecoration:
                InputDecorationsPayment.paymentInputDecoration(
              labelText: 'Fecha de expiración',
              hintText: 'XX/XX',
              prefixIcon: Icons.date_range,
            ),
            cvvCodeDecoration: InputDecorationsPayment.paymentInputDecoration(
              labelText: 'CVV',
              hintText: 'XXX',
              prefixIcon: Icons.lock,
            ),
            cardHolderDecoration:
                InputDecorationsPayment.paymentInputDecoration(
              labelText: 'Nombre del titular',
              hintText: 'Nombre del titular',
              prefixIcon: Icons.person,
            ),
          ),
          _documentInfo(),
          _buttoNext(),
        ],
      ),
    );
  }

  Widget _buttoNext() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.createCardToken,
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
                  Icons.arrow_forward,
                  size: 22,
                ),
              ),
              Text(
                "CONTINUAR",
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

  Widget _documentInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Flexible(
            flex: 2,
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
                        hint: const Text("Tipo doc",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        items: _dropDownItems(_con.documentTypeList),
                        value: _con.typesDocument,
                        onChanged: (String? option) {
                          setState(() {
                            _con.typesDocument = option!;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            flex: 4,
            child: TextField(
              controller: _con.documentNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecorationsPayment.paymentInputDecoration(
                  labelText: "Número de documento",
                  hintText: "Número de doc",
                  prefixIcon: Icons.document_scanner),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoDocumentType> mercadoDocumentType) {
    List<DropdownMenuItem<String>> list = [];
    for (var mercadoDocument in mercadoDocumentType) {
      list.add(DropdownMenuItem(
        child: Text(mercadoDocument.name!),
        value: mercadoDocument.id,
      ));
    }

    return list;
  }

  void refresh() {
    setState(() {});
  }
}
