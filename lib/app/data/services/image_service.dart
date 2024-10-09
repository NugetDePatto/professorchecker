import 'dart:io';
import 'package:checadordeprofesores/core/utlis/print_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import '../../../core/consts/app_keys.dart';

class ImageService {
  static Future<String> initializeDirectory() async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;

    String finalPath = '$path/Evidence';

    final evidenceImagesDirectory = Directory(finalPath);

    if (!await evidenceImagesDirectory.exists()) {
      await evidenceImagesDirectory.create(recursive: true);
      printD('Directory Path: $finalPath');
    }

    return finalPath;
  }

  static Future<File?> captureAndCompressImage(String nameImage) async {
    String filePath = '${_getDirectory()}/$nameImage.jpg';

    final capturedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (capturedImage == null) return null;

    final compressedImageBytes = await FlutterImageCompress.compressWithFile(
      capturedImage.path,
      quality: 50,
      minHeight: 600,
      minWidth: 800,
    );

    if (compressedImageBytes == null) return null;

    return await File(filePath).writeAsBytes(compressedImageBytes);
  }

  //obtener el direcotrio de las imagenes
  static String _getDirectory() {
    return GetStorage(AppKeys.UTILS).read(AppKeys.UTIL_EXTERNAL_DIRECTORY);
  }
}
