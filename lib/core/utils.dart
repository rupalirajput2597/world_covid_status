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
