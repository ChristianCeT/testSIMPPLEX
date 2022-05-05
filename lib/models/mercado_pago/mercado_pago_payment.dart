import 'package:client_exhibideas/models/mercado_pago/mercado_pago_credit_cart.dart';
import 'package:client_exhibideas/models/mercado_pago/mercado_pago_customer.dart';
import 'package:client_exhibideas/models/mercado_pago/mercado_pago_tax.dart';
import 'package:client_exhibideas/models/mercado_pago/mercado_pago_transaction_detail.dart';

class MercadoPagoPayment {
  String? id;
  DateTime? dateCreated;
  DateTime? dateApproved;
  DateTime? dateLastUpdated;
  DateTime? dateOfExpiration;
  DateTime? moneyReleaseDate;
  String? operationType;
  String? issuerId;
  String? paymentMethodId;
  String? paymentTypeId;
  String? status;
  String? statusDetail;
  String? currencyId;
  String? description;
  bool? liveMode;
  String? sponsorId;
  String? authorizationCode;
  String? moneyReleaseSchema;
  double? taxesAmount;
  String? counterCurrency;
  double? shippingAmount;
  String? posId;
  String? storeId;
  String? integratorId;
  String? platformId;
  String? corporationId;
  String? collectorId;
  MercadoPagoCustomer? payer;
  String? marketplaceOwner;
  dynamic metadata;
  String? availableBalance;
  String? nsuProcessadora;
  dynamic order;
  String? externalReference;
  double? transactionAmount;
  double? netAmount;
  List<MercadoPagoTax>? taxes = [];
  double? transactionAmountRefunded;
  double? couponAmount;
  String? differentialPricingId;
  String? deductionSchema;
  String? callBackUrl;
  MercadoPagoTransactionDetail? transactionDetails;
  List<dynamic>? feeDetails;
  bool? captured;
  bool? binaryMode;
  String? callForAuthorizeId;
  String? statementDescriptor;
  int? installments;
  MercadoPagoCreditCard? card;
  String? notificationUrl;
  List<dynamic>? refunds;
  String? processingMode;
  String? merchantAccountId;
  String? acquirer;
  String? merchantNumber;
  List<dynamic>? acquirerReconciliation;

  List<MercadoPagoPayment> creditPaymentList = [];

  MercadoPagoPayment(
      {this.id, this.status, this.transactionDetails, this.callBackUrl});

  MercadoPagoPayment.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final chat = MercadoPagoPayment.fromJsonMap(item);
      creditPaymentList.add(chat);
    }
  }

  MercadoPagoPayment.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'].toString();
    dateApproved = json['date_approved'] is String
        ? DateTime.parse(json['date_approved'])
        : json['date_approved'];
    dateLastUpdated = json['date_last_updated'] is String
        ? DateTime.parse(json['date_last_updated'])
        : json['date_last_updated'];
    dateOfExpiration = json['date_of_expiration'] is String
        ? DateTime.parse(json['date_of_expiration'])
        : json['date_of_expiration'];
    moneyReleaseDate = json['money_release_date'] is String
        ? DateTime.parse(json['money_release_date'])
        : json['money_release_date'];
    operationType = json['operation_type'];
    issuerId = json['issuer_id'];
    paymentMethodId = json['payment_method_id'];
    paymentTypeId = json['payment_type_id'];
    status = json['status'];
    statusDetail = json['status_detail'];
    currencyId = json['currency_id'];
    description = json['description'];
    liveMode = json['live_mode'];
    sponsorId = json['sponder_id'];
    authorizationCode = json['authorization_code'];
    moneyReleaseSchema = json['money_release_schema'];
    taxesAmount = (json['taxes_amount'] != null)
        ? double.parse(json['taxes_amount'].toString())
        : 0;
    counterCurrency = json['counter_currency'];
    shippingAmount = (json['shipping_amount'] != null)
        ? double.parse(json['shipping_amount'].toString())
        : 0;
    posId = json['pos_id'];
    storeId = json['store_id'];
    integratorId = json['integrator_id'];
    platformId = json['platform_id'];
    corporationId = json['corporation_id'];
    collectorId = json['collector_id'].toString();
    payer = json['payer'] is MercadoPagoCustomer
        ? json['payer']
        : MercadoPagoCustomer.fromJsonMap(json['payer'] ?? {});
    marketplaceOwner = json['marketplace_owner'];
    metadata = json['metadata'];
    availableBalance = json['available_balance'];
    nsuProcessadora = json['nsu_processadora'];
    order = json['order'];
    externalReference = json['external_reference'];
    transactionAmount = (json['transaction_amount'] != null)
        ? double.parse(json['transaction_amount'].toString())
        : 0;
    netAmount = (json['net_amount'] != null)
        ? double.parse(json['net_amount'].toString())
        : 0;
    taxes = json['taxes'] is MercadoPagoTax
        ? json['taxes']
        : MercadoPagoTax.fromJsonList(json['taxes']).taxList;
    transactionAmountRefunded = (json['transaction_amount_refunded'] != null)
        ? double.parse(json['transaction_amount_refunded'].toString())
        : 0;
    couponAmount = (json['coupon_amount'] != null)
        ? double.parse(json['coupon_amount'].toString())
        : 0;
    differentialPricingId = json['differential_princing_id'];
    deductionSchema = json['deduction_schema'];
    callBackUrl = json['callback_url'];
    transactionDetails =
        json['transaction_details'] is MercadoPagoTransactionDetail
            ? json['transaction_details']
            : MercadoPagoTransactionDetail.fromJsonMap(
                json['transaction_details'] ?? {});
    feeDetails = json['fee_details'];
    captured = json['captured'];
    binaryMode = json['binary_mode'];
    callForAuthorizeId = json['call_for_authorized_id'];
    statementDescriptor = json['statement_descriptor'];
    installments = (json['installments'] != null)
        ? int.parse(json['installments'].toString())
        : 0;
    card = json['card'] is MercadoPagoCreditCard
        ? json['card']
        : MercadoPagoCreditCard.fromJsonMap(json['card'] ?? {});
    notificationUrl = json['notification_url'];
    refunds = json['refunds'];
    processingMode = json['processing_mode'];
    merchantAccountId = json['merchant_account_id'];
    acquirer = json['acquired'];
    merchantNumber = json['merchant_number'];
    acquirerReconciliation = json['acquirer_reconciliation'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date_created': dateCreated,
        'date_approved': dateApproved,
        'date_last_updated': dateLastUpdated,
        'date_of_expiration': dateOfExpiration,
        'money_release_date': moneyReleaseDate,
        'operation_type': operationType,
        'issuer_id': issuerId,
        'payment_method_id': paymentMethodId,
        'payment_type_id': paymentTypeId,
        'status': status,
        'status_detail': statusDetail,
        'currency_id': currencyId,
        'description': description,
        'live_mode': liveMode,
        'sponder_id': sponsorId,
        'authorization_code': authorizationCode,
        'money_release_schema': moneyReleaseSchema,
        'taxes_amount': taxesAmount.toString(),
        'counter_currency': counterCurrency,
        'shipping_amount': shippingAmount.toString(),
        'pos_id': posId,
        'store_id': storeId,
        'integrator_id': integratorId,
        'platform_id': platformId,
        'corporation_id': corporationId,
        'collector_id': collectorId,
        'payer': payer,
        'marketplace_owner': marketplaceOwner,
        'metadata': metadata,
        'available_balance': availableBalance,
        'nsu_processadora': nsuProcessadora,
        'order': order,
        'external_reference': externalReference,
        'transaction_amount': transactionAmount.toString(),
        'net_amount': netAmount.toString(),
        'taxes': taxes,
        'transaction_amount_refunded': transactionAmountRefunded.toString(),
        'coupon_amount': couponAmount.toString(),
        'differential_princing_id': differentialPricingId,
        'deduction_schema': deductionSchema,
        'callback_url': callBackUrl,
        'transaction_details': transactionDetails?.toJson(),
        'fee_details': feeDetails,
        'captured': captured,
        'binary_mode': binaryMode,
        'call_for_authorized_id': callForAuthorizeId,
        'statement_descriptor': statementDescriptor,
        'installments': installments.toString(),
        'card': card?.toJson(),
        'notification_url': notificationUrl,
        'refunds': refunds,
        'processing_mode': processingMode,
        'merchant_account_id': merchantAccountId,
        'acquired': acquirer,
        'merchant_number': merchantNumber,
        'acquirer_reconciliation': acquirerReconciliation,
      };
}
