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

  // String get ciclo => GetStorage().read('ciclo');

  String get ciclo {
    // enero a mayo = primavera
    // junio a julio = verano
    // agosto a diciembre = otoño

    int mesActual = DateTime.now().month;

    if (mesActual >= 1 && mesActual <= 5) {
      return '${DateTime.now().year} - 1 Primavera';
    } else if (mesActual >= 6 && mesActual <= 7) {
      return '${DateTime.now().year} - 2 Verano';
    } else {
      return '${DateTime.now().year} - 3 Otoño';
    }
  }

  String get titular => datos['titular'].toString().trim().replaceAll(' ', '-');

  String get materia => '${datos['grupo']}-${datos['clave']}';

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

  crearReporte(String mensaje) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('ciclos')
        .doc(ciclo)
        .collection('reportes')
        .doc('${aula}_${fechaActual}_${horaActual}_${generateCode(mensaje)}')
        .set({
      'mensaje': mensaje,
      'fecha': '$fechaActual $horaActual',
      'codigo': codigo,
      'titular': titular,
      'aula': aula,
      'materia': materia
    });
  }

  //METODOS PARA TOMAR ASISTENCIA

  agregarInasistencia() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection('ciclos')
        .doc(ciclo)
        .collection('inasistencias')
        .doc('${titular}_${materia}_${fecha}_${horario}_$codigo')
        .set({
      'fecha': fechaActual,
      'hora': horaActual,
      'titular': titular,
      'materia': materia,
      'horario': horario,
      'codigo': codigo,
      'timestamp': FieldValue.serverTimestamp(),
      'imagen': obtenerImagen() == null
          ? ''
          : '${ciclo}_${titular}_${materia}_${fecha}_${horario}_$codigo.jpg',
    });
  }

  actualizarInasistencia() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection('ciclos')
        .doc(ciclo)
        .collection('inasistencias')
        .doc('${titular}_${materia}_${fecha}_${horario}_$codigo')
        .update({
      'imagen': obtenerImagen() == null
          ? ''
          : '${ciclo}_${titular}_${materia}_${fecha}_${horario}_$codigo.jpg',
    });
  }

  eliminarInasistencia() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection('ciclos')
        .doc(ciclo)
        .collection('inasistencias')
        .doc('${titular}_${materia}_${fecha}_${horario}_$codigo')
        .delete();
  }

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

    Map<String, dynamic> mapa = {
      'asistencia': aux['asistencia'],
      'hora': aux['hora'],
      'imagen': obtenerImagen() == null
          ? ''
          : '${ciclo}_${titular}_${materia}_${fecha}_${horario}_$codigo.jpg',
    };

    await actualizarAsistencia(mapa);

    if (asistencia) {
      print('eliminar inasistencia');
      await eliminarInasistencia();
    } else {
      print('agregar inasistencia');
      await agregarInasistencia();
    }
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

      Map<String, dynamic> mapa = {
        'asistencia': aux['asistencia'],
        'hora': aux['hora'],
        'imagen':
            '${ciclo}_${titular}_${materia}_${fecha}_${horario}_$codigo.jpg',
      };

      await actualizarAsistencia(mapa);

      if (mapa['asistencia'] != null) {
        if (mapa['asistencia']) {
          await actualizarInasistencia();
        }
      }

      //snackbar en pantalla de que se tomo la imagen
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
