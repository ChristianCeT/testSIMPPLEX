class MercadoPagoTransactionDetail {

  String paymentMethodReferenceId;
  double netReceivedAmount;
  double totalPaidAmount;
  double overpaidAmount;
  String externalResourceUrl;
  double installmentAmount;
  String financialInstitution;
  String payableDeferralPeriod;
  String acquirerReference;
  String bankTransferId;

  List<MercadoPagoTransactionDetail> taxList = new List();

  MercadoPagoTransactionDetail({
    this.externalResourceUrl
  });

  MercadoPagoTransactionDetail.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoTransactionDetail.fromJsonMap(item);
      taxList.add(chat);
    });
  }

  MercadoPagoTransactionDetail.fromJsonMap( Map<String, dynamic> json ) {
    paymentMethodReferenceId    = json['payment_method_reference_id'];
    netReceivedAmount           = (json['net_receivedA_amount'] != null) ? double.parse(json['net_receivedA_amount'].toString()) : 0;
    totalPaidAmount             = (json['total_paid_amount'] != null) ? double.parse(json['total_paid_amount'].toString()) : 0;
    overpaidAmount              = (json['overpaid_amount'] != null) ? double.parse(json['overpaid_amount'].toString()) : 0;
    externalResourceUrl         = json['external_resource_url'];
    installmentAmount           = (json['installment_amount'] != null) ? double.parse(json['installment_amount'].toString()) : 0;
    financialInstitution        = json['financial_institution'];
    payableDeferralPeriod       = json['payable_deferral_period'];
    acquirerReference           = json['acquirer_reference'];
    bankTransferId              = json['bank_transfer_id'].toString();
  }

  Map<String, dynamic> toJson() =>
      {
        'payment_method_reference_id'      : paymentMethodReferenceId,
        'net_receivedA_amount'             : netReceivedAmount.toString(),
        'total_paid_amount'                : totalPaidAmount.toString(),
        'overpaid_amount'                  : overpaidAmount.toString(),
        'external_resource_url'            : externalResourceUrl,
        'installment_amount'               : installmentAmount.toString(),
        'financial_institution'            : financialInstitution,
        'payable_deferral_period'          : payableDeferralPeriod,
        'acquirer_reference'               : acquirerReference,
      };
}