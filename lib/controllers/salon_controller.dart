import 'package:hive_flutter/adapters.dart';
import '../models/horario_model.dart';
import '../models/salon_model.dart';
import 'package:intl/intl.dart';

class SalonController {
  Box<Salon> salonesBox = Hive.box<Salon>('salones');

  addAll(Map<String, dynamic> salones) {
    salones.forEach((key, value) {
      salonesBox.put(key, Salon.fromMap(value));
    });
  }

  Map<String, dynamic> get obtenerMapa =>
      Map<String, dynamic>.from(salonesBox.toMap());

  //mandar por bloque y
  Map<String, dynamic> get obtener100s {
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    Map<String, dynamic> salones = {};
    salonesBox.toMap().forEach((keyH, salonesH) {
      if (keyH.startsWith('1')) {
        salonesH.horarios.forEach((key, value) {
          String horaInicial = key.split('-')[0].replaceAll(':', '');
          String horaFinal = key.split('-')[1].replaceAll(':', '');
          if (int.parse(horaActual) >= int.parse(horaInicial) &&
              int.parse(horaActual) <= int.parse(horaFinal)) {
            salones[keyH] = salonesH;
            salones[keyH].horarios = {key: value};
          }
        });
      }
    });
    return salones;
  }

  Map<String, dynamic> get obtener200s {
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    Map<String, dynamic> salones = {};
    salonesBox.toMap().forEach((keyH, salonesH) {
      if (keyH.startsWith('2')) {
        salonesH.horarios.forEach((key, value) {
          String horaInicial = key.split('-')[0].replaceAll(':', '');
          String horaFinal = key.split('-')[1].replaceAll(':', '');
          if (int.parse(horaActual) >= int.parse(horaInicial) &&
              int.parse(horaActual) <= int.parse(horaFinal)) {
            salones[keyH] = salonesH;
            salones[keyH].horarios = {key: value};
          }
        });
      }
    });
    return salones;
  }

  Map<String, dynamic> get obtener300s {
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    Map<String, dynamic> salones = {};
    salonesBox.toMap().forEach((keyH, salonesH) {
      if (keyH.startsWith('3')) {
        salonesH.horarios.forEach((key, value) {
          String horaInicial = key.split('-')[0].replaceAll(':', '');
          String horaFinal = key.split('-')[1].replaceAll(':', '');
          if (int.parse(horaActual) >= int.parse(horaInicial) &&
              int.parse(horaActual) <= int.parse(horaFinal)) {
            salones[keyH] = salonesH;
            salones[keyH].horarios = {key: value};
          }
        });
      }
    });
    return salones;
  }

  Map<String, dynamic> get obtener400s {
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    Map<String, dynamic> salones = {};
    salonesBox.toMap().forEach((keyH, salonesH) {
      if (keyH.startsWith('4')) {
        salonesH.horarios.forEach((key, value) {
          String horaInicial = key.split('-')[0].replaceAll(':', '');
          String horaFinal = key.split('-')[1].replaceAll(':', '');
          if (int.parse(horaActual) >= int.parse(horaInicial) &&
              int.parse(horaActual) <= int.parse(horaFinal)) {
            salones[keyH] = salonesH;
            salones[keyH].horarios = {key: value};
          }
        });
      }
    });
    return salones;
  }

  //obtener salones por hora actual
  List<Horario> get obtenerSalonesPorHora {
    List<Horario> salones = [];
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    salonesBox.toMap().forEach((key, value) {
      value.horarios.forEach((key, value) {
        String horaInicial = key.split('-')[0].replaceAll(':', '');
        String horaFinal = key.split('-')[1].replaceAll(':', '');
        if (int.parse(horaActual) >= int.parse(horaInicial) &&
            int.parse(horaActual) <= int.parse(horaFinal)) {
          salones.add(value);
        }
      });
    });

    return salones;
  }

  //obtener salones por hora actual
  Map<String, dynamic> get obtenerSalonesHora {
    Map<String, dynamic> salonesHora = {};
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    salonesBox.toMap().forEach((keyS, salon) {
      salon.horarios.forEach((keyH, horario) {
        String horaInicial = keyH.split('-')[0].replaceAll(':', '');
        String horaFinal = keyH.split('-')[1].replaceAll(':', '');
        Map<String, Horario> horarioHora = {};
        if (int.parse(horaActual) >= int.parse(horaInicial) &&
            int.parse(horaActual) <= int.parse(horaFinal)) {
          horarioHora[keyH] = horario;
          salonesHora[keyS]['horarios'] = horarioHora;
        }
      });
    });

    return salonesHora;
  }
}
