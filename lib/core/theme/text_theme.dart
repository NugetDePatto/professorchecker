import 'package:checadordeprofesores/core/utlis/dispose_util.dart';
import 'package:flutter/material.dart';

import 'colors_theme.dart';

class TextStyleTheme {
  static TextStyle titleTextStyle = TextStyle(
    fontSize: getSize(25),
    color: ColorsTheme.textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontSize: getSize(20),
    color: ColorsTheme.lightColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle blockTextStyle = TextStyle(
    fontSize: getSize(16),
    color: ColorsTheme.textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subjectTextStyle = TextStyle(
    fontSize: getSize(16),
    color: ColorsTheme.textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subtitleTextStyle = TextStyle(
    fontSize: getSize(14),
    color: ColorsTheme.textColor,
  );
}
