class MercadoPagoSecurityCode {

  //LONGITUD DEL CODIGO DE SEGURIDAD
  int length;

  //UBICACION DEL CODIGO DE SEGURIDAD EN LA TARJETA
  String cardLocation;

  List<MercadoPagoSecurityCode> issuerList = new List();

  MercadoPagoSecurityCode();

  MercadoPagoSecurityCode.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoSecurityCode.fromJsonMap(item);
      issuerList.add(chat);
    });
  }

  MercadoPagoSecurityCode.fromJsonMap( Map<String, dynamic> json ) {
    length          = json['length'];
    cardLocation    = json['card_location'];
  }

  Map<String, dynamic> toJson() =>
      {
        'length'         : length,
        'card_location'  : cardLocation
      };
}