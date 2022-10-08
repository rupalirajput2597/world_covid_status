import '../core.dart';

class CovidStatResponse {
  String? get;
  Parameters? parameters;
  int? results;
  List<CovidDetailModel>? covidDetails;

  CovidStatResponse(
      {this.get, this.parameters, this.results, this.covidDetails});

  CovidStatResponse.fromJson(Map<String, dynamic> json) {
    get = json['get'];
    parameters = json['parameters'] != null
        ? Parameters.fromJson(json['parameters'])
        : null;
    results = json['results'];
    if (json['response'] != null) {
      covidDetails = <CovidDetailModel>[];
      json['response'].forEach((v) {
        covidDetails!.add(CovidDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['get'] = get;
    if (parameters != null) {
      data['parameters'] = parameters!.toJson();
    }
    data['results'] = results;
    if (covidDetails != null) {
      data['response'] = covidDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parameters {
  String? country;

  Parameters({this.country});

  Parameters.fromJson(Map<String, dynamic> json) {
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    return data;
  }
}

class Tests {
  String? s1MPop;
  int? total;

  Tests({this.s1MPop, this.total});

  Tests.fromJson(Map<String, dynamic> json) {
    s1MPop = json['1M_pop'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1M_pop'] = s1MPop;
    data['total'] = total;
    return data;
  }
}
