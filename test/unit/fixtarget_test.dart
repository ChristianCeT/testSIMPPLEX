import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/provider/mercado_pago_provider.dart';
import 'package:simpplex_app/screens/client/payments/create/client_payments_create_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test("ValidateCard", () async {
    ClientPaymentsCreateController clientPaymentsCreateController =
        ClientPaymentsCreateController();

    clientPaymentsCreateController.cardNumber = "4242424242424242 234";
    final _numberCard =
        clientPaymentsCreateController.cardNumber.replaceAll(RegExp(' '), '');

    expect(_numberCard, "4242424242424242234");
  });

  test("ValidatePayment", () async {
    Order order = Order();
    MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();

    Future<http.Response?> respuesta = mercadoPagoProvider.createPayment(
        cardId: "",
        transactionAmount: 200.0,
        installments: int.parse("12121221"),
        paymentMethodId: "1234434",
        paymentTypeId: "PAGADO",
        issuerId: "asdasdasd",
        emailCustomer: "chrisatnat@hotmail.com",
        cardToken: "sadasdasd",
        identificationType: "asdasd",
        identificationNumber: "5031755734530604",
        order: order);

    http.Response? response = await respuesta;

    expect(response, null);
  });
}
