import 'package:checadordeprofesores/views/Agenda/info_view.dart';
import 'package:checadordeprofesores/views/AsistenciaIndividual/asistencia_view.dart';
import 'package:checadordeprofesores/views/Recorrido/recorrido_view.dart';
import 'package:checadordeprofesores/views/Agenda/agenda_view.dart';
import 'package:checadordeprofesores/views/home/home_view.dart';
import 'package:flutter/material.dart';

import '../views/Agenda/escogerhoras_view.dart';

Map<String, WidgetBuilder> get routes => {
      '/': (context) => const HomePage(),
      '/recorrido': (context) => const RecorridoView(),
      '/asistencia': (context) => const AsistenciaView(),
      '/agenda': (context) => const AgendaView(),
      '/info_prof': (context) => const InfoProfView(),
      '/edit_materia': (context) => const EscogerHorasView(),
    };
