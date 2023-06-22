import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImagenController {
  Directory? imagenesEvidencias;
  XFile? imagenX;

  Future<String> iniciar() async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    imagenesEvidencias = Directory('$path/Evidencias');
    if (!await imagenesEvidencias!.exists()) {
      await imagenesEvidencias!.create(recursive: true);
    }
    print(imagenesEvidencias!.path);
    return imagenesEvidencias!.path;
  }

  Future<File?> tomar(String ruta) async {
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

    //crea el archivo en la ruta especificada
    return await File(ruta).writeAsBytes(result);
  }
}
