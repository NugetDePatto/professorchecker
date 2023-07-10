import 'dart:io';

import 'package:checadordeprofesores/utils/secretkey.dart';
import 'package:firebase_database/firebase_database.dart';

import 'imagen_controller.dart';

class NewRecorridoController {
  Map<String, dynamic> recorrido = {};

  Future<NewRecorridoController> iniciar() async {
    int dia = DateTime.now().weekday;

    DatabaseEvent data = await FirebaseDatabase.instance
        .ref('ciclo2023/calendario/${dia - 1}')
        .once();

    for (DataSnapshot horario in data.snapshot.children) {
      recorrido[horario.key!] = {};
      for (DataSnapshot bloque in horario.children) {
        recorrido[horario.key!][bloque.key!] = {};
        for (DataSnapshot salon in bloque.children) {
          Map<String, dynamic> salonMap = {
            'aula': salon.key,
            'materia': salon.child('materia').value,
            'clave': salon.child('clave').value,
            'profesor': salon.child('titular').value,
            'suplente': salon.child('suplente').value,
            'grupo': salon.child('grupo').value,
          };
          recorrido[horario.key!][bloque.key!][salon.key] = salonMap;
        }
      }
    }
    return this;
  }

  String get horaActual =>
      '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';
  String get fechaActual => '${DateTime.now().day}/${DateTime.now().month}';

  int get diaActual => DateTime.now().weekday;

  File? imagen;

  guardarImagen(Map<String, dynamic> e) async {
    //inicia el controlador
    ImagenController imagenController = ImagenController();
    // await imagenController.iniciar();

    String ruta = '${await imagenController.iniciar()}/'
        '${e['clave']}-${e['grupo']}_${fechaActual.replaceFirst('/', '-')}_${horaActual.replaceAll(' ', '')}_${generateCode(fechaActual)}.jpg';

    print(ruta);
    //metodo para tomar imagen y crear la ruta
    imagen = await imagenController.tomar(ruta);
  }
}
