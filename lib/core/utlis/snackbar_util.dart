import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackbarUtil(String mensaje, {String? title}) {
  Get.snackbar(
    title ?? 'Lista de asistencia',
    mensaje,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    backgroundColor: Colors.grey[900],
    duration: const Duration(milliseconds: 1500),
  );
}
