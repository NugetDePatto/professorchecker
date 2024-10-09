import 'package:checadordeprofesores/core/theme/colors_theme.dart';
import 'package:checadordeprofesores/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/up_image_controller.dart';

upImagesDialog() {
  UpImageContoller upImageContoller = Get.find<UpImageContoller>();

  Get.dialog(
    Dialog(
      backgroundColor: ColorsTheme.backgroundColor,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Subir Imagenes',
              style: TextStyleTheme.titleTextStyle,
            ),
            const SizedBox(height: 20),
            Obx(
              () => upImageContoller.isUploading.value
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Imagenes subidas: ${upImageContoller.imagesUploaded.value} de ${upImageContoller.getLenghtImages()}',
                          style: TextStyleTheme.subtitleTextStyle,
                        ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(),
                      ],
                    )
                  : Text(
                      'Imagenes a subir: ${upImageContoller.getLenghtImages()}',
                      style: TextStyleTheme.subtitleTextStyle,
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cerrar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    upImageContoller.uploadImages();
                  },
                  child: const Text('Subir Imagenes'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ).then((value) {
    upImageContoller.isUploading.value = false;
  });
}
