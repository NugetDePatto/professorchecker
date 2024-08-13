import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackbarUtil(String mensaje) {
  Get.snackbar(
    'Lista de asistencias',
    mensaje,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    backgroundColor: Colors.grey[900],
  );
}
