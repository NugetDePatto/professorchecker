import 'dart:io';
import 'package:checadordeprofesores/utils/secretkey.dart';
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

  String get ciclo {
    // enero a mayo = primavera
    // junio a julio = verano
    // agosto a diciembre = otoño

    int mesActual = DateTime.now().month;

    if (kDebugMode) {
      return '2023 - 3 Otoño';
    } else if (mesActual >= 1 && mesActual <= 5) {
      return '${DateTime.now().year} - 1 Primavera';
    } else if (mesActual >= 6 && mesActual <= 7) {
      return '${DateTime.now().year} - 2 Verano';
    } else {
      return '${DateTime.now().year} - 3 Otoño';
    }
  }

  String get titular => datos['titular'].toString().trim();

  String get claveMateria => '${datos['grupo']}-${datos['clave']}';

  String get materia => datos['materia'];

  String get fecha => fechaActual;

  String get horario => horarioActual.replaceAll(' ', '');

  String get codigo => GetStorage().read('codigo');

  GetStorage get asistencias => GetStorage('asistencias');

  String get aula => datos['aula'];

  bool get seTomoAsitencia => GetStorage('asistencias')
              .read('$titular/$claveMateria/$fecha/$horario') !=
          null
      ? true
      : false;

  bool isHorarioAux() {
    GetStorage auxiliares = GetStorage('auxiliares');

    var aux =
        auxiliares.read(datos['titular'] + datos['grupo'] + datos['clave']);

    if (aux != null) {
      if (aux['horario'][diaActual - 1] == horarioActual) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //METODOS PARA LOS REPORTES

  crearReporte(String mensaje, bool etiqueta) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection('ciclos')
        .doc(ciclo)
        .collection('reportes')
        .doc(
            '${etiqueta ? titular : aula}_${fechaActual}_${horaActual}_${generateCode(mensaje)}')
        .set({
      'tipo': etiqueta ? 'profesor' : 'mantenimiento',
      'mensaje': mensaje,
      'fecha': '$fechaActual $horaActual',
      'codigo': codigo,
      'titular': titular,
      'aula': aula,
      'claveMateria': claveMateria,
      'materia': materia,
      'timeServer': FieldValue.serverTimestamp(),
    });
  }

  //NUEVA ASISTENCIA
  addAsistenciaLocalYFS(bool asistio) async {
    var asistencia = await obtenerAsistencia();

    asistencia['asistencia'] = asistio;
    asistencia['hora'] = horaActual;

    await GetStorage('asistencias')
        .write('$titular/$claveMateria/$fecha/$horario', asistencia);

    Map<String, dynamic> valor = {
      codigo: {
        'asistencia': asistio,
        'hora': horaActual,
        'imagen': obtenerImagen() == null
            ? ''
            : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
        'materia': materia,
        'titular': titular,
        'aula': aula,
        'timeServer': FieldValue.serverTimestamp(),
      }
    };

    DocumentReference<Map<String, dynamic>> c =
        FirebaseFirestore.instance.collection('ciclos').doc(ciclo);

    DocumentReference<Map<String, dynamic>> colAsis = c
        .collection('asistencias')
        .doc('${titular}_${claveMateria}_${fecha}_$horario');

    DocumentReference<Map<String, dynamic>> colProf = c
        .collection('profesores')
        .doc(titular)
        .collection('asistencias')
        .doc(claveMateria)
        .collection(fecha)
        .doc(horario);

    //tiene await

    colAsis.set({...valor}, SetOptions(merge: true));

    colProf.set({...valor}, SetOptions(merge: true));
  }

  inicialzarAsistencia(GroupButtonController g) {
    var aux = asistencias.read('$titular/$claveMateria/$fecha/$horario');

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
        '$titular/$claveMateria/$fecha/$horario', aux);

    return asistencias.read('$titular/$claveMateria/$fecha/$horario');
  }

  //METODOS PARA TOMAR IMAGEN Y GUARDARLA

  addImagenAsistFS() async {
    // var asistencia = await obtenerAsistencia();

    Map<String, dynamic> valor = {
      codigo: {
        'imagen': obtenerImagen() == null
            ? ''
            : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
      }
    };

    DocumentReference<Map<String, dynamic>> c =
        FirebaseFirestore.instance.collection('ciclos').doc(ciclo);

    DocumentReference<Map<String, dynamic>> colAsis = c
        .collection('asistencias')
        .doc('${titular}_${claveMateria}_${fecha}_$horario');

    DocumentReference<Map<String, dynamic>> colProf = c
        .collection('profesores')
        .doc(titular)
        .collection('asistencias')
        .doc(claveMateria)
        .collection(fecha)
        .doc(horario);

    colAsis.set({...valor}, SetOptions(merge: true));

    colProf.set({...valor}, SetOptions(merge: true));
  }

  guardarImagenStorage(File photo) {
    final storage = FirebaseStorage.instance.ref();

    String nombre =
        'images/${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg';

    //tenia await
    storage.child(nombre).putFile(photo);
  }

  Future tomarYGuardarImagen() async {
    //inicia el controlador
    ImagenController imagenController = ImagenController();

    String path = await imagenController.iniciar();

    String ruta =
        '$path/${ciclo}_${titular}_${claveMateria}_${fecha}_$horario.jpg';

    if (kDebugMode) {
      print('ruta Final: $ruta');
    }
    //metodo para tomar imagen y crear la ruta
    File? imagen = await imagenController.tomar(ruta);

    //guarda el ruta de la imagen en el getstorage
    if (imagen != null) {
      var aux = await obtenerAsistencia();
      aux['imagen'] = ruta;

      await asistencias.write('$titular/$claveMateria/$fecha/$horario', aux);

      //teniua await
      // try {
      //   guardarImagenStorage(imagen);
      // } catch (e) {
      //   print(e);
      // }

      await guardarImagenEnCache(ruta);
      addImagenAsistFS();
    }

    return imagen;
  }

  bool get existeImagen {
    var aux = asistencias.read('$titular/$claveMateria/$fecha/$horario');
    if (aux != null) {
      if (aux['imagen'] != null && aux['imagen'] != '') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  File? obtenerImagen() {
    var aux = asistencias.read('$titular/$claveMateria/$fecha/$horario');
    if (aux != null) {
      if (aux['imagen'] != null && aux['imagen'] != '') {
        return File(aux['imagen']);
      }
    }
    return null;
  }

  guardarImagenEnCache(String ruta) async {
    GetStorage imagenes = GetStorage('imagenes');

    await imagenes.write(
        '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo', {
      'imagen': ruta,
      'seSubio': false,
    });

    if (kDebugMode) print('SE GUARDO EN CAHCE LA IMAGEN');
  }
}
