/* import 'dart:convert';

import 'package:arcore_flutter_plugin_example/models/stripe_transaction.dart';
import 'package:arcore_flutter_plugin_example/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeProvider {
  String secret =
      "sk_test_51K3ReeKxxarONBdjYEpMjr6PHXyWPBqqEecderX2nNX2rPZ2V5PRv4abABwY8VnTR3KZsh6RbuWUDoMg4CyhnmfZ00mIcpprYK";
  Map<String, String> headers = {
    'Authorization':
        'Bearer sk_test_51K3ReeKxxarONBdjYEpMjr6PHXyWPBqqEecderX2nNX2rPZ2V5PRv4abABwY8VnTR3KZsh6RbuWUDoMg4CyhnmfZ00mIcpprYK',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  BuildContext context;

  void init(BuildContext context) {
    this.context = context;
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            'pk_test_51K3ReeKxxarONBdjP7ioip5hgy7Qc1Z6MjBDKDVzMTfbHk3iNrmrutMzY3S4iPHkNV7CsOS71XHoL5Q3wvPC1C9T00MvxMkbrU',
        merchantId: 'test',
        androidPayMode: 'test'));
  }

  Future<StripeTransactionResponse> payWithCard(
      String amount, String currency) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await createPaymentIntent(amount, currency);

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));

      if (response.status == "succeeded") {
        return new StripeTransactionResponse(
          message: 'Transacción exitosa',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transacción falló',
          success: false,
        );
      }
    } catch (e) {
      print("ERROR AL REALIZAR LA TRANSACCIÓN $e");
      MySnackBar.show(context, "ERROR AL REALIZAR LA TRANSACCIÓN $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      Uri uri = Uri.https('api.stripe.com', 'v1/payment_intents');
      var response = await http.post(uri, body: body, headers: headers);

      return json.decode(response.body);
    } catch (e) {
      print("ERROR AL CREAR EL INTENT DE PAGOS $e");
      return null;
    }
  }
}
 */