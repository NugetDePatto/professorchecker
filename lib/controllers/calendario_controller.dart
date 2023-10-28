import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

eliminarMateria(materia) async {
  var calendario = GetStorage().read('calendario');

  var horarioAux = GetStorage('auxiliares')
      .read(materia['titular'] + materia['grupo'] + materia['clave']);

  var horarioAnterior = [];

  if (horarioAux == null) {
    horarioAnterior = materia['horario'];
  } else {
    horarioAnterior = horarioAux['horario'];
  }

  var bloque = materia['aula'].toString().split('-')[0];
  var aula = materia['aula'];
  var clave = materia['grupo'] + materia['clave'];

  for (int i = 0; i < 7; i++) {
    if (horarioAnterior[i].contains(':')) {
      // print(calendario[i][horarioAnterior[i]][bloque][aula]);
      // calendario[i][horarioAnterior[i]][bloque][aula].remove(clave);
      // print(calendario[i][horarioAnterior[i]][bloque][aula]);

      int horaInicio = int.parse(horarioAnterior[i].split(':')[0]);
      int horaFin = int.parse(horarioAnterior[i].split('-')[1].split(':')[0]);

      while (horaInicio < horaFin) {
        String horas = '$horaInicio:00 - ${horaInicio + 1}:00';
        calendario[i][horas][bloque][aula].remove(clave);
        horaInicio++;
      }
    }
  }

  await GetStorage().write('calendario', calendario);
}

agregarHorario(materia, horario) async {
  var calendario = GetStorage().read('calendario');

  var bloque = materia['aula'].toString().split('-')[0];
  var aula = materia['aula'];
  var clave = materia['grupo'] + materia['clave'];

  for (int i = 0; i < 7; i++) {
    String horas = horario[i];
    if (horas != '-') {
      int horaInicio = int.parse(horas.split(':')[0]);
      int horaFin = int.parse(horas.split('-')[1].split(':')[0]);
      while (horaInicio < horaFin) {
        horas = '$horaInicio:00 - ${horaInicio + 1}:00';
        if (calendario[i].containsKey(horas)) {
          if (calendario[i][horas]!.containsKey(bloque)) {
            if (calendario[i][horas]![bloque].containsKey(aula)) {
              if (kDebugMode) {
                print('Agregando materia: $materia');
              }
              calendario[i][horas]![bloque][aula]![clave] = materia;
              if (kDebugMode) print(calendario[i][horas][bloque][aula]);
            } else {
              calendario[i][horas]![bloque][aula] = {clave: materia};
            }
          } else {
            calendario[i][horas]![bloque] = {
              aula: {
                clave: materia,
              }
            };
          }
        } else {
          calendario[i][horas] = {
            bloque: {
              aula: {
                clave: materia,
              }
            }
          };
        }
        horaInicio++;
      }
    }
  }

  await GetStorage().write('calendario', calendario);
}
