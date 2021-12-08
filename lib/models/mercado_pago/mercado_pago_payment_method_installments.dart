import 'package:client_exhibideas/models/mercado_pago/mercado_pago_installment.dart';
import 'package:client_exhibideas/models/mercado_pago/mercado_pago_issuer.dart';

class MercadoPagoPaymentMethodInstallments {
  String paymentMethodId;

  String paymentTypeId;

  MercadoPagoIssuer issuer;

  String processingMode;

  String merchantAccountId;

  List<MercadoPagoInstallment> payerCosts = [];

  String aggreements;

  List<MercadoPagoPaymentMethodInstallments> installmentList = [];

  MercadoPagoPaymentMethodInstallments();

  MercadoPagoPaymentMethodInstallments.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoPaymentMethodInstallments.fromJsonMap(item);
      installmentList.add(chat);
    });
  }

  MercadoPagoPaymentMethodInstallments.fromJsonMap(Map<String, dynamic> json) {
    paymentMethodId = json['payment_method_id'];
    paymentTypeId = json['payment_type_id'];
    issuer = (json['issuer'] != null)
        ? MercadoPagoIssuer.fromJsonMap(json['issuer'])
        : null;
    processingMode = json['processing_mode'];
    merchantAccountId = json['merchant_account_id'];
    payerCosts = (json['payer_costs'] != null)
        ? MercadoPagoInstallment.fromJsonList(json['payer_costs'])
            .installmentList
        : null;
    aggreements = json['agreements'];
  }

  Map<String, dynamic> toJson() => {
        'payment_method_id': paymentMethodId,
        'payment_type_id': paymentTypeId,
        'issuer': (issuer != null) ? issuer.toJson() : null,
        'processing_mode': processingMode,
        'merchant_account_id': merchantAccountId,
        'payer_costs': (payerCosts != null) ? payerCosts : null,
        'agreements': aggreements,
      };
}
