import '../core.dart';

class CovidDetailModel {
  String? continent;
  String? country;
  int? population;
  Cases? cases;
  Deaths? deaths;
  Tests? tests;
  String? day;
  String? time;

  CovidDetailModel(
      {this.continent,
      this.country,
      this.population,
      this.cases,
      this.deaths,
      this.tests,
      this.day,
      this.time});

  CovidDetailModel.fromJson(Map<String, dynamic> json) {
    continent = json['continent'];
    country = json['country'];
    population = json['population'];
    cases = json['cases'] != null ? Cases.fromJson(json['cases']) : null;
    deaths = json['deaths'] != null ? Deaths.fromJson(json['deaths']) : null;
    tests = json['tests'] != null ? Tests.fromJson(json['tests']) : null;
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['continent'] = continent;
    data['country'] = country;
    data['population'] = population;
    if (cases != null) {
      data['cases'] = cases!.toJson();
    }
    if (deaths != null) {
      data['deaths'] = deaths!.toJson();
    }
    if (tests != null) {
      data['tests'] = tests!.toJson();
    }
    data['day'] = day;
    data['time'] = time;
    return data;
  }
}
