class Cases {
  String? newCases;
  int? active;
  int? critical;
  int? recovered;
  String? s1MPop;
  int? total;

  Cases(
      {this.newCases,
      this.active,
      this.critical,
      this.recovered,
      this.s1MPop,
      this.total});

  Cases.fromJson(Map<String, dynamic> json) {
    newCases = json['new'];
    active = json['active'];
    critical = json['critical'];
    recovered = json['recovered'];
    s1MPop = json['1M_pop'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new'] = newCases;
    data['active'] = active;
    data['critical'] = critical;
    data['recovered'] = recovered;
    data['1M_pop'] = s1MPop;
    data['total'] = total;
    return data;
  }
}
