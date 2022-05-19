import 'package:simpplex_app/models/mercado_pago/mercado_pago_payment.dart';
import 'package:simpplex_app/screens/client/products/client_products_menu/client_products_menu.dart';
import 'package:flutter/material.dart';

class ClientPaymentsStatusController {
  late BuildContext context;
  late Function refresh;

  MercadoPagoPayment? mercadoPagoPayment;
  String? errorMessage;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    mercadoPagoPayment = MercadoPagoPayment.fromJsonMap(arguments);

    if (mercadoPagoPayment?.status == 'rejected') {
      createErrorMessage();
    }

    refresh();
  }

  void finishShopping() {
    Navigator.pushNamedAndRemoveUntil(
        context, ClienteProductsMenu.routeName, (route) => false);
  }

  void createErrorMessage() {
    if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_bad_filled_card_number') {
      errorMessage = 'Revisa el número de tarjeta';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_bad_filled_date') {
      errorMessage = 'Revisa la fecha de vencimiento';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_bad_filled_other') {
      errorMessage = 'Revisa los datos de la tarjeta';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_bad_filled_security_code') {
      errorMessage = 'Revisa el código de seguridad de la tarjeta';
    } else if (mercadoPagoPayment?.statusDetail == 'cc_rejected_blacklist') {
      errorMessage = 'No pudimos procesar tu pago';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_call_for_authorize') {
      errorMessage =
          'Debes autorizar ante ${mercadoPagoPayment?.paymentMethodId} el pago de este monto.';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_card_disabled') {
      errorMessage =
          'Llama a ${mercadoPagoPayment?.paymentMethodId} para activar tu tarjeta o usa otro medio de pago';
    } else if (mercadoPagoPayment?.statusDetail == 'cc_rejected_card_error') {
      errorMessage = 'No pudimos procesar tu pago';
    } else if (mercadoPagoPayment?.statusDetail == 'cc_rejected_card_error') {
      errorMessage = 'No pudimos procesar tu pago';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_duplicated_payment') {
      errorMessage = 'Ya hiciste un pago por ese valor';
    } else if (mercadoPagoPayment?.statusDetail == 'cc_rejected_high_risk') {
      errorMessage =
          'Elige otro de los medios de pago, te recomendamos con medios en efectivo';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_insufficient_amount') {
      errorMessage =
          'Tu ${mercadoPagoPayment?.paymentMethodId} no tiene fondos suficientes';
    } else if (mercadoPagoPayment?.statusDetail ==
        'cc_rejected_invalid_installments') {
      errorMessage =
          '${mercadoPagoPayment?.paymentMethodId} no procesa pagos en ${mercadoPagoPayment?.installments} cuotas.';
    } else if (mercadoPagoPayment?.statusDetail == 'cc_rejected_max_attempts') {
      errorMessage = 'Llegaste al límite de intentos permitidos';
    } else if (mercadoPagoPayment?.statusDetail == 'cc_rejected_other_reason') {
      errorMessage = 'Elige otra tarjeta u otro medio de pago';
    }
  }
}
