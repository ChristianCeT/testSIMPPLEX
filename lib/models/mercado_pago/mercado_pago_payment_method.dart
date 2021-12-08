import 'package:client_exhibideas/models/mercado_pago/mercado_pago_financial_institution.dart';
import 'package:client_exhibideas/models/mercado_pago/mercado_pago_issuer.dart';

class MercadoPagoPaymentMethod {
  //IDENTIFICADOR DEL MEDIO DE PAGO
  String id;

  //OMBRE DEL MEDIO DE PAGO
  String name;

  String paymentTypeId;
  String status;
  String secureThumbnail;
  String thumbnail;
  String deferredCapture;

  MercadoPagoIssuer issuer = MercadoPagoIssuer();

  //SETTINGS
  int cardNumberLength;
  String binPattern;
  String binExclusionPattern;
  int securityCodeLength;

  List<dynamic> additionalInfoNeeded = [];
  double minAllowedAmount;
  double maxAllowedAmount;
  double accreditationTime;
  List<MercadoPagoFinancialInstitution> financialInstitutions;

  List<MercadoPagoPaymentMethod> paymentMenthodList = [];

  MercadoPagoPaymentMethod({this.id});

  MercadoPagoPaymentMethod.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoPaymentMethod.fromJsonMap(item);
      paymentMenthodList.add(chat);
      print('SE DICIONO METODO');
    });
  }

  MercadoPagoPaymentMethod.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    paymentTypeId = json['payment_type_id'];
    status = json['status'];
    secureThumbnail = json['secure_thumbnail'];
    thumbnail = json['thumbnail'];
    deferredCapture = json['deferred_capture'];
    cardNumberLength = (json['payment_type_id'] == 'credit_card')
        ? (json['settings'] != null)
            ? (json['settings'][0]['card_number']['length'] != null)
                ? int.parse(
                    json['settings'][0]['card_number']['length'].toString())
                : -1
            : -1
        : -1;
    binPattern = (json['payment_type_id'] == 'credit_card')
        ? (json['settings'] != null)
            ? json['settings'][0]['bin']['pattern']
            : null
        : null;
    binExclusionPattern = (json['payment_type_id'] == 'credit_card')
        ? (json['settings'] != null)
            ? json['settings'][0]['bin']['exclusion_pattern']
            : null
        : null;
    securityCodeLength = (json['payment_type_id'] == 'credit_card')
        ? (json['settings'] != null)
            ? (json['settings'][0]['security_code']['length'] != null)
                ? int.parse(
                    json['settings'][0]['security_code']['length'].toString())
                : -1
            : -1
        : -1;
    additionalInfoNeeded = json['additional_info_needed'];
    minAllowedAmount = (json['min_allowed_amount'] != null)
        ? double.parse(json['min_allowed_amount'].toString())
        : -1;
    maxAllowedAmount = (json['max_allowed_amount'] != null)
        ? double.parse(json['max_allowed_amount'].toString())
        : -1;
    accreditationTime = (json['accreditation_time'] != null)
        ? double.parse(json['accreditation_time'].toString())
        : -1;
    financialInstitutions = (json['financial_institutions'] != null)
        ? MercadoPagoFinancialInstitution.fromJsonList(
                json['financial_institutions'])
            .institutionList
        : [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'payment_type_id': paymentTypeId,
        'status': status,
        'secure_thumbnail': secureThumbnail,
        'thumbnail': thumbnail,
        'deferred_capture': deferredCapture,
        'card_number_length': cardNumberLength,
        'bin_pattern': binPattern,
        'bin_exclusion_pattern': binExclusionPattern,
        'security_code_length': securityCodeLength,
        'additional_info_needed': additionalInfoNeeded.toString(),
        'min_allowed_amount': minAllowedAmount,
        'max_allowed_amount': maxAllowedAmount,
        'accreditation_time': accreditationTime,
        'financial_institutions': financialInstitutions
      };
}
