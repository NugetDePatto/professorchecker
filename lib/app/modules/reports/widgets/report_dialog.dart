import 'package:checadordeprofesores/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/theme/text_theme.dart';

reportDialog(data) {
  Get.dialog(
    AlertDialog(
      backgroundColor: ColorsTheme.backgroundColor,
      title: Text(
        '¿Qué tipo de reporte deseas hacer?',
        style: TextStyleTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(
                Routes.PROFESSOR_REPORTS,
                arguments: data,
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(ColorsTheme.orangeColor),
            ),
            child: Text('A profesor', style: TextStyleTheme.buttonTextStyle),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(
                Routes.CLASSROOMS_REPORTS,
                arguments: data,
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(ColorsTheme.orangeColor),
            ),
            child: Text('A Salón', style: TextStyleTheme.buttonTextStyle),
          ),
        ],
      ),
    ),
  );
}
