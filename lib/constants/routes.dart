import 'package:checadordeprofesores/views/home/home_view.dart';
import 'package:checadordeprofesores/views/home/recorrido_view.dart';
import 'package:flutter/material.dart';
import '../views/ver_salon/ver_salon.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/recorrido': (context) => const RecorridoView(),
  '/ver_salon': (context) => const VerSalon(),
};
