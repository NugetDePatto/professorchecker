import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'salon_model.dart';

class SalonController {
  Box<Salon> salonesBox = Hive.box<Salon>('salones');

  addAll(Map<String, dynamic> salones) {
    salones.forEach((key, value) {
      salonesBox.put(key, Salon.fromMap(value));
    });
  }

  Map<String, dynamic> get obtenerMapa =>
      Map<String, dynamic>.from(salonesBox.toMap());

  Salon? obtenerSalon(String salon) {
    Map<String, dynamic> salones = obtenerMapa;

    if (salones.containsKey(salon)) {
      return salones[salon];
    } else {
      return null;
    }
  }

  // verHorarios(Salon salon) {
  //   Map<String, Horario> horarios = salon.horarios;
  // } (mapa['llave'])

  Map<String, dynamic> obtenerSalonesProfesores(String profesor) {
    Map<String, dynamic> salones = obtenerMapa;
    Map<String, dynamic> salonesProfesor = {};

    salones.forEach((keySalon, salon) {
      salon.forEach((keyHorario, horario) {
        if (horario.titular == profesor) {
          salonesProfesor[profesor] = salon;
        }
      });
    });

    return salonesProfesor;
  }

  // mandar por bloque y
  Map<String, dynamic> get obtener100s {
    String horaActual = '${DateFormat('HH').format(DateTime.now())}00';
    Map<String, dynamic> salones = {};
    salonesBox.toMap().forEach(
      (keyH, salonesH) {
        if (keyH.startsWith('1')) {
          salonesH.horarios.forEach(
            (key, value) {
              String horaInicial = key.split('-')[0].replaceAll(':', '');
              String horaFinal = key.split('-')[1].replaceAll(':', '');
              if (int.parse(horaActual) >= int.parse(horaInicial) &&
                  int.parse(horaActual) <= int.parse(horaFinal)) {
                salones[keyH] = salonesH;
                salones[keyH].horarios = {key: value};
              }
            },
          );
        }
      },
    );
    return salones;
  }
}
