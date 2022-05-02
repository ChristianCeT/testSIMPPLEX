import 'package:client_exhibideas/models/mercado_pago/mercado_pago_credit_cart.dart';

class MercadoPagoCustomer {
  //IDENTIFICADOR DEL USUARIO EN MERCADO PAGO
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneArea;
  String? phoneNumber;
  String? identificationType;
  String? identificationNumber;
  String? addressId;
  String? addressZip;
  String? addressStreetName;
  String? addressStreetNumber;
  DateTime? dateRegistered;
  String? description;
  DateTime? dateCreated;
  DateTime? dateLastUpdated;
  List<dynamic>? metadata;
  String? defaultCardId;
  String? defaultAddressId;
  List<MercadoPagoCreditCard> customerCardList = [];
  bool? liveMode;

  List<MercadoPagoCustomer> customerList = [];

  MercadoPagoCustomer();

  MercadoPagoCustomer.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final customer = MercadoPagoCustomer.fromJsonMap(item);
      customerList.add(customer);
    }
  }

  MercadoPagoCustomer.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneArea = (json['phone'] != null) ? json['phone']['area_code'] : null;
    phoneNumber = (json['phone'] != null) ? json['phone']['number'] : null;
    identificationType = (json['identification'] != null)
        ? json['identification']['type']
        : null;
    identificationNumber = (json['identification'] != null)
        ? json['identification']['number']
        : null;
    addressId = (json['address'] != null) ? json['address']['id'] : null;
    addressZip = (json['address'] != null) ? json['address']['zip_code'] : null;
    addressStreetName =
        (json['address'] != null) ? json['address']['street_name'] : null;
    addressStreetNumber =
        (json['address'] != null) ? json['address']['street_number'] : null;
    dateRegistered = (json['date_registered'] != null)
        ? DateTime.parse(json['date_registered'])
        : null;
    description = json['description'];
    dateCreated = (json['date_created'] != null)
        ? DateTime.parse(json['date_created'])
        : null;
    dateLastUpdated = (json['date_last_updated'] != null)
        ? DateTime.parse(json['date_last_updated'])
        : null;
    metadata = json['metadata'];
    defaultCardId = json['default_card'];
    defaultAddressId = json['defauilt_address'];
    customerCardList = json['cards'];
    liveMode = json['live_mode'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone_area_code': phoneArea,
        'phone_number': phoneNumber,
        'identification_type': identificationType,
        'identification_number': identificationNumber,
        'address_id': addressId,
        'address_zip_code': addressZip,
        'address_street_name': addressStreetName,
        'address_street_number': addressStreetNumber,
        'date_registered': dateRegistered,
        'description': description,
        'date_created': dateCreated,
        'date_last_updated': dateLastUpdated,
        'metadata': metadata,
        'default_card': defaultCardId,
        'defauilt_address': defaultAddressId,
        'cards': customerCardList,
        'live_mode': liveMode,
      };
}
