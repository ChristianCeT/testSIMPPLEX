import 'package:simpplex_app/models/mercado_pago/mercado_pago_card_holder.dart';

class MercadoPagoCardToken {
  String? id;
  String? publicKey;
  String? cardId;
  bool? luhnValidation;
  String? status;
  DateTime? dateUsed;
  int? cardNumberLength;
  DateTime? dateCreated;
  String? firstSixDigits;
  String? lastFourDigits;
  int? securityCodeLength;
  int? expirationMonth;
  int? expirationYear;
  DateTime? dateLastUpdated;
  DateTime? dateDue;
  bool? liveMode;
  MercadoPagoCardHolder? cardHolder;
  List<MercadoPagoCardToken> cardTokenList = [];

  MercadoPagoCardToken();

  MercadoPagoCardToken.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return;
    }
    for (var item in jsonList) {
      final chat = MercadoPagoCardToken.fromJsonMap(item);
      cardTokenList.add(chat);
    }
  }

  MercadoPagoCardToken.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    publicKey = json['publick_key'];
    cardId = json['card_id'];
    luhnValidation = json['luhnValidation'];
    status = json['status'];
    dateUsed =
        (json['date_used'] != null) ? DateTime.parse(json['date_used']) : null;
    cardNumberLength = json['card_number_length'];
    dateCreated = json['date_created'] is DateTime
        ? json['date_created']
        : DateTime.parse(json['date_created']);
    firstSixDigits = json['first_six_digits'];
    lastFourDigits = json['last_four_digits'];
    securityCodeLength = json['security_code_length'];
    expirationMonth = (json['expiration_month'] != null)
        ? int.parse(json['expiration_month'].toString())
        : 0;
    expirationYear = (json['expiration_year'] != null)
        ? int.parse(json['expiration_year'].toString())
        : 0;
    dateLastUpdated = json['date_last_updated'] is DateTime
        ? json['date_last_updated']
        : DateTime.parse(json['date_last_updated']);
    dateDue = json['date_due'] is DateTime
        ? json['date_due']
        : DateTime.parse(json['date_due']);
    cardHolder = (json['cardholder'] != null)
        ? MercadoPagoCardHolder.fromJsonMap(json['cardholder'])
        : null;
    liveMode = json['live_mode'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'publick_key': publicKey,
        'card_id': cardId,
        'luhnValidation': luhnValidation,
        'status': status,
        'date_used': dateUsed,
        'card_number_length': cardNumberLength,
        'date_created': dateCreated,
        'first_six_digits': firstSixDigits,
        'last_four_digits': lastFourDigits,
        'security_code_length': securityCodeLength,
        'expiration_month': expirationMonth,
        'expiration_year': expirationYear,
        'date_last_updated': dateLastUpdated,
        'date_due': dateDue,
        'cardholder': cardHolder?.toJson(),
        'live_mode': liveMode
      };
}
