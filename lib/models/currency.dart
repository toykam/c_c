class Currency {
  String currencyName;
  String currencyId;
  String currencySymbol;

  Currency({this.currencyName, this.currencyId, this.currencySymbol});

  Currency.fromJson(Map<String, dynamic> json) {
    currencyName = json['currencyName'];
    currencyId = json['currencyId'];
    currencySymbol = json['currencySymbol'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyName'] = this.currencyName;
    data['currencyId'] = this.currencyId;
    data['currencySymbol'] = this.currencySymbol;
    return data;
  }
}