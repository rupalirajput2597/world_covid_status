import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension RangeExtension on int {
  List<int> to(int maxInclusive, {int step = 1}) =>
      [for (int i = this; i <= maxInclusive; i += step) i];
}

Color hexToColor(String code) {
  try {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  } catch (e) {
    return Colors.transparent;
  }
}

//formatting number with thousand Separator
String formatNumber(int number) {
  return NumberFormat('#,##,###').format(number);
}

// Future<String> getCountryName() async {
//   Position position = await Geolocator()
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   debugPrint('location: ${position.latitude}');
//   final coordinates = new Coordinates(position.latitude, position.longitude);
//   var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   var first = addresses.first;
//   return first.countryName; // this will return country name
// }

/*Future<String?> getCountryName() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  debugPrint('location: ${position.latitude}');
  // final coordinates = Coordinates(position.latitude, position.longitude);

  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  // var addresses =
  //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
  // var first = addresses.first;
  // return first.countryName;
  //
  //this will return country name

  return placemarks.first.isoCountryCode;
}
*/
