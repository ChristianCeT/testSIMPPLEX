class MercadoPagoFinancialInstitution {

  String id;
  String description;

  List<MercadoPagoFinancialInstitution> institutionList = new List();

  MercadoPagoFinancialInstitution();

  MercadoPagoFinancialInstitution.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoFinancialInstitution.fromJsonMap(item);
      institutionList.add(chat);
    });
  }

  MercadoPagoFinancialInstitution.fromJsonMap( Map<String, dynamic> json ) {
    id            = json['id'];
    description   = json['description'];
  }

  Map<String, dynamic> toJson() =>
      {
        'id'          : id,
        'description' : description
      };
}