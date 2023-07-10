import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(String title, List<Widget> actions, context) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
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
    leadingWidth: 100,
    actions: actions,
  );
}
