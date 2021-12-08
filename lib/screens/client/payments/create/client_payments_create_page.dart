import 'package:client_exhibideas/models/mercado_pago/mercado_pago_document_type.dart';
import 'package:client_exhibideas/screens/client/payments/create/client_payments_create_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  const ClientPaymentsCreatePage({Key key}) : super(key: key);

  static String routeName = "/client/payments/create";

  @override
  _ClientPaymentsCreatePageState createState() =>
      _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {
  ClientPaymentsCreateController _con = new ClientPaymentsCreateController();

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
        title: Text("Pagos"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            onCreditCardWidgetChange: (CreditCardBrand card) {
              print("ADSAD $card");
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
            animationDuration: Duration(milliseconds: 1000),
            labelCardHolder: "NOMBRE Y APELLIDO",
          ),
          CreditCardForm(
            formKey: _con.keyForm, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            themeColor: Colors.red,
            obscureCvv: true,
            cvvCode: '',
            expiryDate: '',
            cardHolderName: '',
            cardNumber: '',
            obscureNumber: true,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            cardNumberDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de la tarjeta',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fecha de expiración',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del titular',
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
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.createCardToken,
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
                  "CONTINUAR",
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
                  Icons.arrow_forward_ios,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Flexible(
            flex: 2,
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
                        hint: Text("Tipo doc",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        items: _dropDownItems(_con?.documentTypeList),
                        value: _con?.typesDocument,
                        onChanged: (option) {
                          setState(() {
                            _con?.typesDocument = option;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            flex: 4,
            child: TextField(
              controller: _con.documentNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Número de documento"),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoDocumentType> mercadoDocumentType) {
    List<DropdownMenuItem<String>> list = [];
    mercadoDocumentType?.forEach((mercadoDocument) {
      list.add(DropdownMenuItem(
        child: Container(
          child: Text(mercadoDocument?.name),
        ),
        value: mercadoDocument?.id,
      ));
    });

    return list;
  }

  void refresh() {
    setState(() {});
  }
}
