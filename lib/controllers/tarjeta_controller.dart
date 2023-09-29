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
      return 'TEST - 2023 - 3 Otoño';
    } else if (mesActual >= 1 && mesActual <= 5) {
      return '${DateTime.now().year} - 1 Primavera';
    } else if (mesActual >= 6 && mesActual <= 7) {
      return '${DateTime.now().year} - 2 Verano';
    } else {
      return '${DateTime.now().year} - 3 Otoño';
    }
  }

  String get titular => datos['titular'].toString().trim().replaceAll(' ', '-');

  String get claveMateria => '${datos['grupo']}-${datos['clave']}';

  String get materia => datos['materia'];

  String get fecha => fechaActual;

  String get horario => horarioActual.replaceAll(' ', '');

  String get codigo => GetStorage().read('codigo');

  GetStorage get asistencias => GetStorage('asistencias');

  String get aula => datos['aula'];

  bool isHorarioAux() {
    GetStorage auxiliares = GetStorage('auxiliares');

    var aux =
        auxiliares.read(datos['titular'] + datos['grupo'] + datos['clave']);

    return aux != null;
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

  // reporteAula(String mensaje) {
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   db
  //       .collection('ciclos')
  //       .doc(ciclo)
  //       .collection('reportes')
  //       .doc('${aula}_${fechaActual}_${horaActual}_${generateCode(mensaje)}')
  //       .set({
  //     'mensaje': mensaje,
  //     'fecha': '$fechaActual $horaActual',
  //     'codigo': codigo,
  //     'titular': titular,
  //     'aula': aula,
  //     'claveMateria': claveMateria
  //   });
  // }

  //NUEVA ASISTENCIA

  addAsistenciaLocalYFS(bool asistio) async {
    var asistencia = await obtenerAsistencia();

    asistencia['asistencia'] = asistio;
    asistencia['hora'] = horaActual;

    GetStorage('asistencias')
        .write('$titular/$claveMateria/$fecha/$horario/$codigo', asistencia);

    // asistencia en coleccin 'asistencias'

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('ciclos')
        .doc(ciclo)
        .collection('asistencias')
        .doc('${titular}_${claveMateria}_${fecha}_${horario}_$codigo')
        .set(
      {
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
      },
    );

    //asistencia en coleccion 'profesores'

    await db
        .collection('ciclos')
        .doc(ciclo)
        .collection('profesores')
        .doc(titular)
        .collection('asistencias')
        .doc(claveMateria)
        .collection(fecha)
        .doc(horario)
        .set({
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
    });
  }

  inicialzarAsistencia(GroupButtonController g) {
    var aux =
        asistencias.read('$titular/$claveMateria/$fecha/$horario/$codigo');

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
        '$titular/$claveMateria/$fecha/$horario/$codigo', aux);

    return asistencias.read('$titular/$claveMateria/$fecha/$horario/$codigo');
  }

  //METODOS PARA TOMAR IMAGEN Y GUARDARLA

  addImagenAsistFS() async {
    var asistencia = await obtenerAsistencia();

    // asistencia en coleccin 'asistencias'

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('ciclos')
        .doc(ciclo)
        .collection('asistencias')
        .doc('${titular}_${claveMateria}_${fecha}_${horario}_$codigo')
        .set(
      {
        codigo: {
          'asistencia': asistencia['asistencia'],
          'hora': asistencia['hora'],
          'imagen': obtenerImagen() == null
              ? ''
              : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
          'materia': materia,
          'titular': titular,
          'aula': aula,
          'timeServer': FieldValue.serverTimestamp(),
        }
      },
    );

    //asistencia en coleccion 'profesores'

    await db
        .collection('ciclos')
        .doc(ciclo)
        .collection('profesores')
        .doc(titular)
        .collection('asistencias')
        .doc(claveMateria)
        .collection(fecha)
        .doc(horario)
        .set({
      codigo: {
        'asistencia': asistencia['asistencia'],
        'hora': asistencia['hora'],
        'imagen': obtenerImagen() == null
            ? ''
            : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
        'materia': materia,
        'titular': titular,
        'aula': aula,
        'timeServer': FieldValue.serverTimestamp(),
      }
    });
  }

  guardarImagenStorage(File photo) async {
    final storage = FirebaseStorage.instance.ref();

    String nombre =
        'images/${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg';

    await storage.child(nombre).putFile(photo);
  }

  tomarYGuardarImagen() async {
    //inicia el controlador
    ImagenController imagenController = ImagenController();

    String path = await imagenController.iniciar();

    String ruta =
        '$path/${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg';

    if (kDebugMode) {
      print('ruta Final: $ruta');
    }
    //metodo para tomar imagen y crear la ruta
    File? imagen = await imagenController.tomar(ruta);

    //guarda el ruta de la imagen en el getstorage
    if (imagen != null) {
      await guardarImagenStorage(imagen);
      var aux = await obtenerAsistencia();
      aux['imagen'] = ruta;

      await asistencias.write(
          '$titular/$claveMateria/$fecha/$horario/$codigo', aux);

      await addImagenAsistFS();
    }
  }

  bool existeImagen() {
    var aux =
        asistencias.read('$titular/$claveMateria/$fecha/$horario/$codigo');
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
    var aux = asistencias
        .read('$titular/$claveMateria/$fecha/$horario/$codigo')['imagen'];
    if (aux.toString().isNotEmpty) {
      return File(aux);
    } else {
      return null;
    }
  }
}

 //METODOS PARA TOMAR ASISTENCIA

  // agregarInasistencia() async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;

  //   db
  //       .collection('ciclos')
  //       .doc(ciclo)
  //       .collection('inasistencias')
  //       .doc('${titular}_${claveMateria}_${fecha}_${horario}_$codigo')
  //       .set({
  //     'id_dispositivo': codigo,
  //     'fecha': '$fechaActual $horaActual',
  //     'titular': titular,
  //     'claveMateria': claveMateria,
  //     'horario': horario,
  //     'imagen': obtenerImagen() == null
  //         ? ''
  //         : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  // actualizarInasistencia() async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;

  //   db
  //       .collection('ciclos')
  //       .doc(ciclo)
  //       .collection('inasistencias')
  //       .doc('${titular}_${claveMateria}_${fecha}_${horario}_$codigo')
  //       .update({
  //     'imagen': obtenerImagen() == null
  //         ? ''
  //         : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
  //   });
  // }

  // eliminarInasistencia() async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;

  //   db
  //       .collection('ciclos')
  //       .doc(ciclo)
  //       .collection('inasistencias')
  //       .doc('${titular}_${claveMateria}_${fecha}_${horario}_$codigo')
  //       .delete();
  // }

  
  // ponerAsistencia(bool asistencia) async {
  //   //si ya hay asistencia no poner falta

  //   var aux = await obtenerAsistencia();
  //   aux['asistencia'] = asistencia;
  //   aux['hora'] = horaActual;

  //   print('entro');

  //   // obtener la asistencia de firestore
  //   FirebaseFirestore db = FirebaseFirestore.instance;
  //   var asistenciaFirestore = await db
  //       .collection('ciclos')
  //       .doc(ciclo)
  //       .collection('profesores')
  //       .doc(datos['titular'])
  //       .collection('asistencias')
  //       .doc(claveMateria)
  //       .collection(fecha)
  //       .doc(horario)
  //       .get();

  //   bool? asistio;

  //   if (asistenciaFirestore.exists) {
  //     for (var dispositivo in asistenciaFirestore.data()!.keys) {
  //       print('dispositivo: $dispositivo');
  //       var mapaAsistencia = asistenciaFirestore.data()![dispositivo];
  //       print(mapaAsistencia);
  //       if (mapaAsistencia['asistencia'] != null) {
  //         if (mapaAsistencia['asistencia']) {
  //           asistio = true;
  //           break;
  //         } else {
  //           asistio = false;
  //         }
  //       }
  //     }
  //   }

  //   if (asistio != null) {
  //     if (asistio) {
  //       await asistencias.write(
  //           '$titular/$claveMateria/$fecha/$horario/$codigo', aux);

  //       Map<String, dynamic> mapa = {
  //         'asistencia': aux['asistencia'],
  //         'hora': aux['hora'],
  //         'imagen': obtenerImagen() == null
  //             ? ''
  //             : '${ciclo}_${titular}_${claveMateria}_${fecha}_${horario}_$codigo.jpg',
  //       };

  //       await actualizarAsistencia(mapa);

  //       //obtener la misma asistencia pero de firestore

  //       // if (asistencia) {
  //       //   print('eliminar inasistencia');
  //       //   await eliminarInasistencia();
  //       // } else {
  //       //   print('agregar inasistencia');
  //       //   await agregarInasistencia();
  //       // }
  //     }
  //   }
  // }

  // actualizarAsistencia(Map<String, dynamic> aux) async {
  //   FirebaseFirestore db = FirebaseFirestore.instance;

  //   await db
  //       .collection('ciclos')
  //       .doc(ciclo)
  //       .collection('profesores')
  //       .doc(datos['titular'])
  //       .collection('asistencias')
  //       .doc(claveMateria)
  //       .collection(fecha)
  //       .doc(horario)
  //       .set({
  //     codigo: {
  //       ...aux,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     },
  //   });
  // }

