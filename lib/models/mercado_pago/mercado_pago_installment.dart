class MercadoPagoInstallment {

  //IDENTIFICACION DEL EMISON
  int installments;
  int installmentRate;
  int discountRate;
  int reimbursementRate;
  List<dynamic> labels;
  List<dynamic> installmentRateCollector;
  double minAllowedAmount;
  double maxAllowedAmount;
  String recommendedMessage;
  double installmentAmount;
  double totalAmount;
  String paymentMethodOptionId;

  List<MercadoPagoInstallment> installmentList = [];

  MercadoPagoInstallment();

  MercadoPagoInstallment.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoInstallment.fromJsonMap(item);
      installmentList.add(chat);
    });
  }

  MercadoPagoInstallment.fromJsonMap( Map<String, dynamic> json ) {
    installments              = (json['installments'] != null) ? int.parse(json['installments'].toString()) : -1;
    installmentRate           = (json['installment_rate'] != null) ? int.parse(json['installment_rate'].toString()) : -1;
    discountRate              = (json['discount_rate'] != null) ? int.parse(json['discount_rate'].toString()) : -1;
    reimbursementRate         = (json['reimbursement_rate'] != null) ? int.parse(json['reimbursement_rate'].toString()) : -1;
    labels                    = json['labels'];
    installmentRateCollector  = json['installment_rate_collector'];
    minAllowedAmount          = (json['min_allowed_amount'] != null) ? double.parse(json['min_allowed_amount'].toString()) : -1;
    maxAllowedAmount          = (json['max_allowed_amount'] != null) ? double.parse(json['max_allowed_amount'].toString()) : -1;
    recommendedMessage        = json['recommended_message'];
    installmentAmount         = (json['installment_amount'] != null) ? double.parse(json['installment_amount'].toString()) : -1;
    totalAmount               = (json['total_amount'] != null) ? double.parse(json['total_amount'].toString()) : -1;
    paymentMethodOptionId     = json['payment_method_option_id'];
  }

  Map<String, dynamic> toJson() =>
      {
        'installments'                 : installments,
        'installment_rate'             : installmentRate,
        'discount_rate'                : discountRate,
        'reimbursement_rate'           : reimbursementRate,
        'labels'                       : labels,
        'installment_rate_collector'   : installmentRateCollector,
        'min_allowed_amount'           : minAllowedAmount,
        'max_allowed_amount'           : maxAllowedAmount,
        'recommended_message'          : recommendedMessage,
        'installment_amount'           : installmentAmount,
        'total_amount'                 : totalAmount,
        'payment_method_option_id'     : paymentMethodOptionId,
      };
}