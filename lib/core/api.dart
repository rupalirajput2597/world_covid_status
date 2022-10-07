import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:world_covid_status/core/.secret_key.dart';
import 'package:world_covid_status/core/constants.dart';
import 'package:world_covid_status/core/models/country_list_model.dart';

class Api {
  static final Map<String, String> _header = {
    // "Content-Type": "application/json",
    // "Accept": "application/json",
    "X-RapidAPI-Key": RAPID_API_KEY,
    "X-RapidAPI-Host": RAPID_API_HOST,
  };

  static dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        } catch (e) {
          print("error $e");
        }
        break;

      default:
        print("Error occured");
    }
  }

  static fetchCountries() async {
    try {
      Uri url = Uri.parse(Config.COUNTRY_URL);
      var response = await http.get(url, headers: _header);
      var jsonResponse = _returnResponse(response);
      print(jsonResponse);
      return CountryList.fromJson(jsonResponse);
    } catch (e) {
      print("errror ${e.toString()}");
    }
  }

  static fetchIsoCode() async {
    try {
      Uri url = Uri.parse(Config.ISO_CODE_URL);
      var response = await http.get(url);
      return _returnResponse(response);
    } catch (e) {
      print("error ${e.toString()}");
    }
  }

//  binarySearch(List<int> arr, int userValue, int min, int max) {
//   if (max >= min) {
//     print('min $min');
//     print('max $max');
//     int mid = ((max + min) / 2).floor();
//     if (userValue == arr[mid]) {
//       print('your item is at index: ${mid}');
//     } else if (userValue > arr[mid]) {
//       binarySearch(arr, userValue, mid + 1, max);
//     } else {
//       binarySearch(arr, userValue, min, mid - 1);
//     }
//   }
//   return null;
}
