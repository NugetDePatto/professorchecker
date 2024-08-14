import 'package:flutter/material.dart';
import '../views/Agenda/agenda_view.dart';
import '../views/Agenda/cambiarsalon_view.dart';
import '../views/Agenda/escogerhoras_view.dart';
import '../views/Agenda/info_view.dart';
import '../views/AsistenciaIndividual/asistencia_view.dart';
import '../views/Recorrido/recorrido_view.dart';
import '../views/home/home_view.dart';
import '../views/home/options_view.dart';
import '../widgets/reporte_view.dart';

Map<String, WidgetBuilder> get routes => {
      '/': (context) => const HomePage(),
      '/recorrido': (context) => const RecorridoView(),
      '/asistencia': (context) => const AsistenciaView(),
      '/agenda': (context) => const AgendaView(),
      '/info_prof': (context) => const InfoProfView(),
      '/edit_materia': (context) => const EscogerHorasView(),
      '/reporte': (context) => const ReporteView(),
      '/options': (context) => const OptionsView(),
      '/edit_salon': (context) => const CambiarSalonView(),
    };
