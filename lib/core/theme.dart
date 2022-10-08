import 'package:flutter/material.dart';

import 'core.dart';

class WCovidStatTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: WCovidStatColor.backGroundColor(),
    );
  }
}

class WCovidStatColor {
  static Color backGroundColor() {
    return hexToColor("#EEEEFF");
  }
}
