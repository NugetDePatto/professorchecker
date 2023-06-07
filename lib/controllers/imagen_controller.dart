import 'dart:io';
import 'package:checadordeprofesores/controllers/recorrido_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/secretkey.dart';

class ImagenController {
  Directory? imagenesEvidencias;
  XFile? imagenX;

  void iniciar() async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    imagenesEvidencias = Directory('$path/Evidencias');
    if (!await imagenesEvidencias!.exists()) {
      await imagenesEvidencias!.create(recursive: true);
    }
  }

  Future<File?> tomar(MapEntry<String, dynamic> e) async {
    final imagenTomada =
        await ImagePicker().pickImage(source: ImageSource.camera);

    //si hubo algun error al tomar la imagen, retorna nulo
    if (imagenTomada == null) return null;

    //baja la calidad de la imagen
    final result = await FlutterImageCompress.compressWithFile(
      imagenTomada.path,
      quality: 50, // Establecer la calidad de la imagen comprimida
      minHeight: 600,
      minWidth: 800,
    );

    //si hubo algun error al bajar la calidad, retorna nulo
    if (result == null) return null;

    //controlador para usar los metodos que facilitan usar el mapa
    RecorridoController r = RecorridoController();

    //creacion de la ruta nueva
    String ruta =
        '${imagenesEvidencias!.path}/${r.horarioKey(e)}_${r.fechaActual.replaceAll('/', '-')}_${r.horario(e).grado}${r.horario(e).grupo}_${generateCode('${DateTime.now()}')}.jpg';

    //crea el archivo en la ruta especificada
    return await File(ruta).writeAsBytes(result);
  }
}
