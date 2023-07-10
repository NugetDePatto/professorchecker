import 'package:checadordeprofesores/views/example2/example_recorridoview.dart';
import 'package:checadordeprofesores/views/home/agenda_view.dart';
import 'package:checadordeprofesores/views/home/home_view.dart';
import 'package:checadordeprofesores/views/home/newrecorrido_view.dart';
import 'package:flutter/material.dart';
import '../views/ver_salon/ver_salon.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/recorrido': (context) => const NewRecorridoView(),
  '/ver_salon': (context) => const VerSalon(),
  '/agenda': (context) => const AgendaView(),
  '/prueba': (context) => const ExampleRecorrido(),
};
