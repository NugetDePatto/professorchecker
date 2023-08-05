import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_button/group_button.dart';

import '../utils/date_utils.dart';
import 'imagen_controller.dart';

class TarjetaController {
  Map<String, dynamic> datos;

  TarjetaController({required this.datos});

  String get ciclo => '2023 - 2 Verano';

  String get titular => datos['titular'].toString().trim().replaceAll(' ', '-');

  String get materia => '${datos['grupo']}-${datos['clave']}';

  String get fecha => fechaActual;

  String get horario => horarioActual.replaceAll(' ', '');

  String get codigo => GetStorage('informacion').read('codigo');

  GetStorage get asistencias => GetStorage('asistencias');

  //METODOS PARA TOMAR ASISTENCIA

  inicialzarAsistencia(GroupButtonController g) {
    var aux = asistencias.read('$titular/$materia/$fecha/$horario/$codigo');

    if (aux != null) {
      if (aux['asistencia'] != null) {
        if (aux['asistencia']) {
          g.selectIndex(1);
        } else {
          g.selectIndex(0);
        }
      }
    }
  }

  obtenerAsistencia() async {
    Map<String, dynamic> aux = {'asistencia': null, 'hora': '', 'imagen': ''};
    await asistencias.writeIfNull(
        '$titular/$materia/$fecha/$horario/$codigo', aux);

    return asistencias.read('$titular/$materia/$fecha/$horario/$codigo');
  }

  ponerAsistencia(bool asistencia) async {
    var aux = await obtenerAsistencia();
    aux['asistencia'] = asistencia;
    aux['hora'] = horaActual;
    await asistencias.write('$titular/$materia/$fecha/$horario/$codigo', aux);

    await actualizarAsistencia(aux);
  }

  actualizarAsistencia(Map<String, dynamic> aux) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('ciclos')
        .doc(ciclo)
        .collection('profesores')
        .doc(datos['titular'])
        .collection('asistencias')
        .doc(materia)
        .collection(fecha)
        .doc(horario)
        .set({
      codigo: aux,
    });
  }

  //METODOS PARA TOMAR IMAGEN Y GUARDARLA

  guardarImagen(File photo) async {
    final storage = FirebaseStorage.instance.ref();

    String nombre =
        'images/${ciclo}_${titular}_${materia}_${fecha}_${horario}_$codigo.jpg';

    await storage.child(nombre).putFile(photo);
  }

  tomarImagen() async {
    //inicia el controlador
    ImagenController imagenController = ImagenController();

    String path = await imagenController.iniciar();

    String ruta =
        '$path/${ciclo}_${titular}_${materia}_${fecha}_${horario}_$codigo.jpg';

    if (kDebugMode) {
      print('ruta Final: $ruta');
    }
    //metodo para tomar imagen y crear la ruta
    File? imagen = await imagenController.tomar(ruta);

    //guarda el ruta de la imagen en el getstorage
    if (imagen != null) {
      await guardarImagen(imagen);
      var aux = await obtenerAsistencia();
      aux['imagen'] = ruta;
      await asistencias.write('$titular/$materia/$fecha/$horario/$codigo', aux);

      await actualizarAsistencia(aux);
    }
  }

  bool existeImagen() {
    var aux = asistencias.read('$titular/$materia/$fecha/$horario/$codigo');
    if (aux != null) {
      if (aux['imagen'].toString().isNotEmpty) {
        if (obtenerImagen() != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  obtenerImagen() {
    var aux =
        asistencias.read('$titular/$materia/$fecha/$horario/$codigo')['imagen'];
    if (aux.toString().isNotEmpty) {
      return File(aux);
    } else {
      return null;
    }
  }
}
