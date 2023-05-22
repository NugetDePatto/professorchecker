import 'package:checadordeprofesores/constants/colors.dart';
import 'package:checadordeprofesores/constants/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: myTheme,
      initialRoute: '/',
      routes: routes,
    );
  }
}
