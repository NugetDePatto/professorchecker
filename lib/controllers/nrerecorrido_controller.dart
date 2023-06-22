import 'dart:io';

import 'package:checadordeprofesores/utils/secretkey.dart';

import 'imagen_controller.dart';

class NewRecorridoController {
  String get horaRecorridoActual =>
      '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';
  String get fechaActual => '${DateTime.now().day}/${DateTime.now().month}';

  int get diaActual => DateTime.now().weekday;

  File? imagen;

  guardarImagen(Map<String, dynamic> e) async {
    //inicia el controlador
    ImagenController imagenController = ImagenController();
    // await imagenController.iniciar();

    String ruta = '${await imagenController.iniciar()}/'
        '${e['clave']}-${e['grupo']}_${fechaActual.replaceFirst('/', '-')}_${horaRecorridoActual.replaceAll(' ', '')}_${generateCode(fechaActual)}.jpg';

    print(ruta);
    //metodo para tomar imagen y crear la ruta
    imagen = await imagenController.tomar(ruta);
  }
}
