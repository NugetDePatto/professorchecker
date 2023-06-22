import 'dart:io';

import 'package:checadordeprofesores/controllers/imagen_controller.dart';
import 'package:hive/hive.dart';

import '../models/horario_model.dart';
import '../models/salon_model.dart';

class RecorridoController {
  Box<Salon> salonesBox = Hive.box<Salon>('salones');

  ///devuelve el horario en base el mapa,
  ///que por los metodos de obtenerX00s solo se obtiene un horario por la hora
  Horario horario(MapEntry<String, dynamic> e) =>
      e.value.horarios.entries.first.value;

  //obtiene el salon mediante el key del mapa
  String horarioKey(MapEntry<String, dynamic> e) =>
      e.value.horarios.entries.first.key;

  String get fechaActual => '${DateTime.now().day}/${DateTime.now().month}';

  //hora actual para hacer la comparacion en el metodo de horariosporhora
  String get horaActual => '${DateTime.now().hour}00';

  //String que se muestra en el appBar de recorrido_view
  String get horaRecorridoActual =>
      'Hora: ${DateTime.now().hour}:00 a ${DateTime.now().hour + 1}:00';

  //metodos para obtener los salones por hora y por bloque

  Map<String, dynamic> porBloque(bool verTodos, String bloque) {
    //aqui se guardaran solo los salones que empiecen con 4
    Map<String, dynamic> salones = {};

    //obtener TODOS salones mediante hive
    Map<dynamic, Salon> cajaSalones = salonesBox.toMap();

    cajaSalones.forEach((keyS, salonesH) {
      if (keyS.startsWith(bloque)) {
        salones.addEntries(_horariosPorHora(keyS, salonesH, verTodos).entries);
      }
    });

    return salones;
  }

  Map<String, dynamic> _horariosPorHora(
      dynamic keyS, Salon salon, bool verTodos) {
    // bool verTodos = false;
    Map<String, dynamic> salones = {};

    salon.horarios.forEach(
      (key, value) {
        String horaInicial = key.split('-')[0].replaceAll(':', '');
        String horaFinal = key.split('-')[1].replaceAll(':', '');
        if (int.parse(horaActual) >= int.parse(horaInicial) &&
            int.parse(horaActual) <= int.parse(horaFinal)) {
          if (verTodos) {
            salones[keyS] = salon;
            salones[keyS].horarios = {key: value};
          } else if (crearFecha(MapEntry(keyS, salon)) == false ||
              obtenerImagen(MapEntry(keyS, salon)) == null) {
            salones[keyS] = salon;
            salones[keyS].horarios = {key: value};
          }
        }
      },
    );

    return salones;
  }

  //metodos para la asistencia

  //cada nuevo dia crea una fecha
  bool crearFecha(MapEntry<String, dynamic> e) {
    Horario h = horario(e);

    if (!h.fechas.containsKey(fechaActual)) {
      h.fechas[fechaActual] = {
        "asistencia": false,
        "imagen_url": "",
      };
    }

    //se guarda en hive
    salonesBox.put(e.key, e.value);

    return h.fechas[fechaActual]['asistencia'];
  }

  //metodo para poner o quitar asistencia
  asistencia(MapEntry<String, dynamic> e) {
    Horario h = horario(e);
    h.fechas[fechaActual]['asistencia'] = !h.fechas[fechaActual]['asistencia'];

    //se guarada en hive.
    salonesBox.put(e.key, e.value);
  }

  guardarImagenAsistencia(MapEntry<String, dynamic> e) async {
    //inicia el controlador
    ImagenController imagenController = ImagenController();
    imagenController.iniciar();

    //metodo para tomar imagen y crear la ruta
    File? imagen = await imagenController.tomar(''); //aqui iba el e

    if (imagen != null) {
      Horario h = horario(e);

      //si ya existe una imagen en esta asistencia, la eliminara y pondra la nueva ruta en el mapa
      if (h.fechas[fechaActual]['imagen_url'] != '') {
        File? imagenAnterior = File(h.fechas[fechaActual]['imagen_url']);
        if (await imagenAnterior.exists()) {
          await imagenAnterior.delete();
        }
      }

      h.fechas[fechaActual]['imagen_url'] = imagen.path;

      salonesBox.put(e.key, e.value);
    }
  }

  File? obtenerImagen(MapEntry<String, dynamic> e) {
    Horario h = horario(e);

    if (!h.fechas.containsKey(fechaActual)) return null;

    if (h.fechas[fechaActual]['imagen_url'] == '') return null;

    return File(h.fechas[fechaActual]['imagen_url']);
  }

  guardarObservacion(MapEntry<String, dynamic> e, String observacion) {
    e.value.observaciones.add(observacion);

    for (var x in e.value.observaciones) {
      print(x);
    }

    salonesBox.put(e.key, e.value);
  }
}
