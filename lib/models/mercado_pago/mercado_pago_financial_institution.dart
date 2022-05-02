class MercadoPagoFinancialInstitution {
  String? id;
  String? description;

  List<MercadoPagoFinancialInstitution> institutionList = [];

  MercadoPagoFinancialInstitution();

  MercadoPagoFinancialInstitution.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final chat = MercadoPagoFinancialInstitution.fromJsonMap(item);
      institutionList.add(chat);
    }
  }

  MercadoPagoFinancialInstitution.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'description': description};
}
