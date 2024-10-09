import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/theme/text_theme.dart';

moreInfoDialog(subject, day) {
  Get.dialog(
    AlertDialog(
      backgroundColor: ColorsTheme.subjectCardClassroomColor,
      title: Text(
        'INFORMACIÓN DE LA MATERIA',
        style: TextStyleTheme.subjectTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clave:',
                      style: TextStyleTheme.subtitleTextStyle,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      subject['clave'],
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grupo:',
                      style: TextStyleTheme.subtitleTextStyle,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      subject['grupo'],
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('ID:', style: TextStyleTheme.subtitleTextStyle),
                    Text(
                      subject['titular'].split('-')[0],
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Titular:',
                      style: TextStyleTheme.subtitleTextStyle,
                    ),
                    Text(
                      subject['titular'].split('-')[1],
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Materia:',
                      style: TextStyleTheme.subtitleTextStyle,
                    ),
                    Text(
                      subject['materia'],
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Text('Horario:', style: TextStyleTheme.subtitleTextStyle),
                    Text(
                      subject['horario'][day],
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
