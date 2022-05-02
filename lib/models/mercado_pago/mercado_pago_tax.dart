class MercadoPagoTax {
  double? value;
  String? type;

  List<MercadoPagoTax> taxList = [];

  MercadoPagoTax();

  MercadoPagoTax.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      MercadoPagoTax tax;
      if (item is MercadoPagoTax) {
        tax = item;
      } else {
        tax = MercadoPagoTax.fromJsonMap(item);
      }

      taxList.add(tax);
    }
  }

  MercadoPagoTax.fromJsonMap(Map<String, dynamic> json) {
    value =
        (json['value'] != null) ? double.parse(json['value'].toString()) : 0;
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {'value': value.toString(), 'type': type};
}
