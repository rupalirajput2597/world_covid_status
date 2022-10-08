class CovidStatResponse {
  String? get;
  Parameters? parameters;
  // List<Null>? errors;
  int? results;
  List<CovidDetailModel>? covidDetails;

  CovidStatResponse(
      {this.get,
      this.parameters,
      /*this.errors,*/ this.results,
      this.covidDetails});

  CovidStatResponse.fromJson(Map<String, dynamic> json) {
    get = json['get'];
    parameters = json['parameters'] != null
        ? Parameters.fromJson(json['parameters'])
        : null;
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) { errors!.add( Null.fromJson(v)); });
    // }
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
    // if (errors != null) {
    //   data['errors'] = errors!.map((v) => v.toJson()).toList();
    // }
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
