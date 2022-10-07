import 'country_model.dart';

class CountryList {
  String? get;
  //List<dynamic>? parameters;
  //List<dynamic>? errors;
  int? results;
  List<String>? countries;
  List<Country>? countriesNew;

  CountryList(
      {this.get,
      /*this.parameters, this.errors,*/ this.results,
      this.countries});

  CountryList.fromJson(Map<String, dynamic> json) {
    get = json['get'];
    // if (json['parameters'] != null) {
    //   parameters = <Null>[];
    //   json['parameters'].forEach((v) {
    //     parameters!.add(new dynamic.fromJson(v));
    //   });
    // }
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    results = json['results'];
    countries = json['response'].cast<String>();

    if (json['response'] != null) {
      countriesNew = <Country>[];
      json['response'].forEach((name) {
        countriesNew!.add(Country(name: name));
        //        countriesNew!.add(Country(name: name.replaceAll("-", "")));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['get'] = get;
    // if (this.parameters != null) {
    //   data['parameters'] = this.parameters!.map((v) => v.toJson()).toList();
    // }
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    data['results'] = this.results;
    data['response'] = this.countries;
    return data;
  }
}
