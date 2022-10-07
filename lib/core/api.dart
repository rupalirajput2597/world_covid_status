import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  final Map<String, String> _header = {
    // "Content-Type": "application/json",
    // "Accept": "application/json",
    "X-RapidAPI-Key": "08fa60901amsh37168630b70a793p16cae1jsn9bb5d7e4a262",
    "X-RapidAPI-Host": "covid-193.p.rapidapi.com"
  };

  static dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        } catch (e) {
          print("$e");
        }
        break;

      default:
        print("Error occured");
    }
  }
}
