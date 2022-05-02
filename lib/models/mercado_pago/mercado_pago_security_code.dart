class MercadoPagoSecurityCode {
  //LONGITUD DEL CODIGO DE SEGURIDAD
  int? length;

  //UBICACION DEL CODIGO DE SEGURIDAD EN LA TARJETA
  String? cardLocation;

  List<MercadoPagoSecurityCode> issuerList = [];

  MercadoPagoSecurityCode();

  MercadoPagoSecurityCode.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final chat = MercadoPagoSecurityCode.fromJsonMap(item);
      issuerList.add(chat);
    }
  }

  MercadoPagoSecurityCode.fromJsonMap(Map<String, dynamic> json) {
    length = json['length'];
    cardLocation = json['card_location'];
  }

  Map<String, dynamic> toJson() =>
      {'length': length, 'card_location': cardLocation};
}
