import 'package:flutter/material.dart';

import 'core.dart';

class WCovidStatTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
    );
  }
}

//custom colors for project
class WCovidStatColor {
  static Color backGroundColor() {
    return hexToColor("#EEEEFF");
  }

  static Color whiteColor() {
    return Colors.white;
  }

  static Color blackColor() {
    return Colors.black;
  }

  static Color redColor() {
    return Colors.red;
  }
}
