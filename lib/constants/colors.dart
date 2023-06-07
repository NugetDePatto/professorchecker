import 'package:flutter/material.dart';

/// Contains Theme Colors

ThemeData myTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
);
