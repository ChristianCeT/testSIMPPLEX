class MercadoPagoIssuer {

  //IDENTIFICACION DEL EMISON
  String id;

  //NOMBRE DEL EMISOR
  String name;

  List<MercadoPagoIssuer> issuerList = [];

  MercadoPagoIssuer();

  MercadoPagoIssuer.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoIssuer.fromJsonMap(item);
      issuerList.add(chat);
    });
  }

  MercadoPagoIssuer.fromJsonMap( Map<String, dynamic> json ) {
    id      = json['id'].toString();
    name    = json['name'];
  }

  Map<String, dynamic> toJson() =>
      {
        'id'    : id,
        'name'  : name
      };
}