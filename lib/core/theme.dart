import 'package:flutter/material.dart';

import 'core.dart';
//App theme
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
}
