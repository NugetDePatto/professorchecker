import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(String title, context) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    toolbarHeight: 150,
    titleTextStyle: const TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    iconTheme: const IconThemeData(
      size: 60,
    ),
  );
}
