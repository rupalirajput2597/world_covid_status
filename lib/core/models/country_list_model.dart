import 'country_model.dart';

class CountryList {
  String? get;
  int? results;
  List<Country>? countryList;

  CountryList({this.get, this.results});

  CountryList.fromJson(Map<String, dynamic> json) {
    get = json['get'];
    results = json['results'];

    if (json['response'] != null) {
      countryList = <Country>[];
      json['response'].forEach((name) {
        countryList!.add(Country(name: name));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['get'] = get;
    data['results'] = results;
    return data;
  }
}
