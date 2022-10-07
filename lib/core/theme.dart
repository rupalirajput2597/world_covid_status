import 'package:flutter/material.dart';

import 'core.dart';

class WCovidStatusTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: hexToColor("#EEEEFF"),
    );
  }
}
