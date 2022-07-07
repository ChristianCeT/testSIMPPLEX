import 'dart:convert';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/providers.dart';
import 'package:simpplex_app/screens/client/payments/installments/client_payments_installments_page.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:http/http.dart';

class ClientPaymentsCreateController {
  late BuildContext context;
  late Function refresh;

  GlobalKey<FormState> keyForm = GlobalKey();

  TextEditingController documentNumberController = TextEditingController();

  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  List<MercadoPagoDocumentType> documentTypeList = [];
  final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();
  late User user;
  final SharedPref _sharedPref = SharedPref();

  String typesDocument = 'DNI';
  late String expirationYear;
  late int expirationMonth;
  MercadoPagoCardToken? cardToken;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _mercadoPagoProvider.init(context, user);

    getIdenteficationTypes();
  }

  void getIdenteficationTypes() async {
    documentTypeList = (await _mercadoPagoProvider.getIdentificacionTtpes())!;

    for (var documentMercado in documentTypeList) {
      print("DOCUMENTO: ${documentMercado.toJson()}");
    }
    refresh();
  }

  void createCardToken() async {
    String documentNumber = documentNumberController.text;
    if (cardNumber.isEmpty) {
      MySnackBar.show(context, "Ingresa el número de la tarjeta");
      return;
    }

    if (expireDate.isEmpty) {
      MySnackBar.show(context, "Ingresa la fecha de expiración de la tarjeta");
      return;
    }

    if (cvvCode.isEmpty) {
      MySnackBar.show(context, "Ingresa el código de seguridad de la tarjeta");
      return;
    }

    if (cardHolderName.isEmpty) {
      MySnackBar.show(context, "Ingresa el titular de la tarjeta");
      return;
    }

    if (documentNumber.isEmpty) {
      MySnackBar.show(context, "Ingresa el número del documento");
      return;
    }

    List<String> list = expireDate.split('/');
    if (list.length == 2) {
      expirationMonth = int.parse(list[0]);
      expirationYear = '20${list[1]}';
    } else {
      MySnackBar.show(
          context, "Inserta el mes y el año de expiración de la tarjeta");
    }
    cardNumber = cardNumber.replaceAll(RegExp(' '), '');

    Response? response = await _mercadoPagoProvider.createCardToken(
      cvv: cvvCode,
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      documentId: typesDocument,
      documentNumber: documentNumber,
      expirationYear: expirationYear,
      expirationMonth: expirationMonth,
    );

    if (response != null) {
      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        cardToken = MercadoPagoCardToken.fromJsonMap(data);

        Navigator.pushNamed(context, ClientPaymentsInstallmentsPage.routeName,
            arguments: {
              'identification_type': typesDocument,
              'identification_number': documentNumber,
              'card_token': cardToken?.toJson(),
            });
      } else {
        print('Hubo un error generando el token');
        int? status = int.tryParse(data['cause'][0]['code'] ?? data['status']);
        String message = data['message'] ?? 'Erro al registrar la tarjeta';
        MySnackBar.show(context, "Status code $status - $message");
      }
    }
  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expireDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;

    refresh();
  }
}
