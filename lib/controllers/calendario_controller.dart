import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

agregarHora(dia, materia, hora, aula) async {
  List<dynamic> calendario = GetStorage().read('calendario');

  var bloque = aula.split('-')[0];
  var clave = materia['grupo'] + materia['clave'];

  int horaInicio = int.parse(hora.split(':')[0]);
  int horaFin = int.parse(hora.split('-')[1].split(':')[0]);

  while (horaInicio < horaFin) {
    hora = '$horaInicio:00 - ${horaInicio + 1}:00';
    if (calendario[dia].containsKey(hora)) {
      if (calendario[dia][hora].containsKey(bloque)) {
        if (calendario[dia][hora][bloque].containsKey(aula)) {
          if (kDebugMode) {
            print('Agregando materia: $dia, $hora, $bloque, $aula $materia');
          }

          calendario[dia][hora][bloque][aula][clave] = materia;
        } else {
          calendario[dia][hora][bloque][aula] = {clave: materia};
        }
      } else {
        calendario[dia][hora][bloque] = {
          aula: {
            clave: materia,
          }
        };
      }
    } else {
      calendario[dia][hora] = {
        bloque: {
          aula: {
            clave: materia,
          }
        }
      };
    }
    horaInicio++;
  }

  await GetStorage().write('calendario', calendario);
}

eliminarHora(dia, materia, String hora, aula) async {
  var calendario = GetStorage().read('calendario');

  var bloque = aula.split('-')[0];
  var clave = materia['grupo'] + materia['clave'];

  int horaInicio = int.parse(hora.split(':')[0]);
  int horaFin = int.parse(hora.split('-')[1].split(':')[0]);

  while (horaInicio < horaFin) {
    hora = '$horaInicio:00 - ${horaInicio + 1}:00';
    if (calendario[dia].containsKey(hora)) {
      if (calendario[dia][hora]!.containsKey(bloque)) {
        if (calendario[dia][hora]![bloque].containsKey(aula)) {
          if (kDebugMode) print('Eliminando materia: $materia');

          calendario[dia][hora]![bloque][aula]!.remove(clave);
        }
      }
    }
    horaInicio++;
  }

  await GetStorage().write('calendario', calendario);
}
