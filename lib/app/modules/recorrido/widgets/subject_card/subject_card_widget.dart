import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utlis/dispose_util.dart';
import '../../controllers/recorrido_controller.dart';
import 'icon_button_widget.dart';
import 'subject_card_controller.dart';

class SubjectCardWidget extends GetView {
  final String classroom;
  final dynamic subject;

  const SubjectCardWidget({
    super.key,
    required this.classroom,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SubjectCardController();
    final recorridoController = Get.find<RecorridoController>();
    controller.getAssistance(
        subject.value, recorridoController.currentDayIndex.value);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(getSize(20)),
          ),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
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
                            subject.value['clave'],
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
                            subject.value['grupo'],
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
                            subject.value['titular'].split('-')[0],
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
                            subject.value['titular'].split('-')[1],
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
                            subject.value['materia'],
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
                          Text('Horario:',
                              style: TextStyleTheme.subtitleTextStyle),
                          Text(
                            subject.value['horario']
                                [recorridoController.currentDayIndex.value],
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
      },
      child: Container(
        // color: ColorsTheme.subjectCardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: getSize(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: getSize(10)),
                    width: getSize(70),
                    decoration: BoxDecoration(
                      color: ColorsTheme.subjectCardClassroomColor,
                      borderRadius:
                          BorderRadius.all(Radius.circular(getSize(15))),
                    ),
                    child: Text(
                      classroom.substring(0, 3),
                      style: TextStyleTheme.subjectTextStyle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: getSize(20)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.value['materia'],
                          style: TextStyleTheme.subjectTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subject.value['titular'].split('-')[1],
                          style: TextStyleTheme.subjectTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: getSize(20)),
              Row(
                children: [
                  SizedBox(width: getSize(75)),
                  Expanded(
                    child: Obx(() => Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            IconButtonWidget(
                              icon: Icons.report,
                              onPressed: () {},
                              isSelected: false,
                            ),
                            SizedBox(width: getSize(10)),
                            IconButtonWidget(
                              icon: Icons.camera_alt_rounded,
                              onPressed: () {},
                              isSelected: false,
                            ),
                            SizedBox(width: getSize(10)),
                            IconButtonWidget(
                              icon: Icons.close,
                              onPressed: () {
                                controller.setAssistance(false, subject.value,
                                    recorridoController.currentDayIndex.value);
                              },
                              isSelected: controller.close.value,
                            ),
                            SizedBox(width: getSize(10)),
                            IconButtonWidget(
                              icon: Icons.check,
                              onPressed: () {
                                controller.setAssistance(true, subject.value,
                                    recorridoController.currentDayIndex.value);
                              },
                              isSelected: controller.check.value,
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
