class Deaths {
  String? newDeaths;
  String? s1MPop;
  int? total;

  Deaths({this.newDeaths, this.s1MPop, this.total});

  Deaths.fromJson(Map<String, dynamic> json) {
    newDeaths = json['new'];
    s1MPop = json['1M_pop'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new'] = newDeaths;
    data['1M_pop'] = s1MPop;
    data['total'] = total;
    return data;
  }
}
