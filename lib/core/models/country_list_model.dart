import 'country_model.dart';

class CountryList {
  String? get;
  int? results;
  List<String>? countries;
  List<Country>? countriesNew;

  CountryList({this.get, this.results, this.countries});

  CountryList.fromJson(Map<String, dynamic> json) {
    get = json['get'];
    results = json['results'];
    countries = json['response'].cast<String>();

    if (json['response'] != null) {
      countriesNew = <Country>[];
      json['response'].forEach((name) {
        countriesNew!.add(Country(name: name));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['get'] = get;
    data['results'] = results;
    data['response'] = countries;
    return data;
  }
}
