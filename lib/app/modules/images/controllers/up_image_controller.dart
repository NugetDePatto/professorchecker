import 'dart:io';

import 'package:checadordeprofesores/core/utlis/snackbar_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/consts/app_keys.dart';
import '../../../../core/utlis/is_conected_internet_utils.dart';

class UpImageContoller extends GetxController {
  var isUploading = false.obs;

  var imagesUploaded = 0.obs;

  var imagesLength = 0.obs;

  Future<void> uploadImages() async {
    if (getLenghtImages() == 0) {
      snackbarUtil(
        title: 'No se pudieron subir las imágenes',
        'No hay imágenes para subir',
      );

      return;
    }

    isUploading.value = true;

    var attendanceImage = GetStorage(AppKeys.ATTENDANCE_IMAGE).getValues();

    List<String> deleteKeys = [];

    for (var image in attendanceImage) {
      Map<dynamic, dynamic> imageMap = image as Map<dynamic, dynamic>;

      bool isUpload = await uploadImage(imageMap['path'], imageMap['key']);

      if (!isUpload) {
        snackbarUtil(
          title: 'Error',
          'Error al subir la imagen, verifique su conexión a internet',
        );

        break;
      }

      deleteKeys.add(imageMap['key']);

      imagesUploaded.value++;
    }
    await Future.delayed(const Duration(seconds: 1));

    for (var key in deleteKeys) {
      await GetStorage(AppKeys.ATTENDANCE_IMAGE).remove(key);
    }

    imagesUploaded.value = 0;

    isUploading.value = false;
  }

  Future<bool> uploadImage(String path, String key) async {
    if (await isConnectedToInternet()) {
      final storage = FirebaseStorage.instance.ref();
      await storage.child('images/$key').putFile(File(path));

      return true;
    } else {
      return false;
    }
  }

  int getLenghtImages() {
    imagesLength.value =
        GetStorage(AppKeys.ATTENDANCE_IMAGE).getValues().length;

    return imagesLength.value;
  }
}
