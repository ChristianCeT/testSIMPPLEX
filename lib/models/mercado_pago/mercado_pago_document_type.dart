class MercadoPagoDocumentType {

  //IDENTIFICADOR DEL TIPO DE IDENTIFICACION
  String id;

  //OMBRE DEL TIPO DE IDENTIFICACION
  String name;

  //TIPO DE DATO DEL NUMERO DE IDENTIFICACION
  String type;

  //MINIMA LONGITUD DEL NUMERO DE IDENTIFICACION
  int minLength;

  //MAXIMA LONGITUD DEL NUMERO DE IDENTIFICACION
  int maxLength;

  List<MercadoPagoDocumentType> documentTypeList = new List();

  MercadoPagoDocumentType();

  MercadoPagoDocumentType.fromJsonList( List<dynamic> jsonList  ){
    if ( jsonList == null ) {
      return;
    }
    jsonList.forEach((item) {
      final chat = MercadoPagoDocumentType.fromJsonMap(item);
      documentTypeList.add(chat);
    });
  }

  MercadoPagoDocumentType.fromJsonMap( Map<String, dynamic> json ) {
    print('EL JSON ES $json');
    id            = json['id'];
    name          = json['name'];
    type          = json['type'];
    minLength     = (json['min_length'] != null) ? int.parse(json['min_length'].toString()) : 0;
    maxLength     = (json['max_length'] != null) ? int.parse(json['max_length'].toString()) : 0;
  }

  Map<String, dynamic> toJson() =>
      {
        'id'          : id,
        'name'        : name,
        'type'        : type,
        'min_length'  : minLength,
        'max_length'  : maxLength
      };
}