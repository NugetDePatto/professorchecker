import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:group_button/group_button.dart';

import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../controllers/recorrido_controller.dart';
import 'icon_button_widget.dart';

class SubjectCardWidget extends GetView<RecorridoController> {
  final String classroom;
  final dynamic subject;

  const SubjectCardWidget({
    super.key,
    required this.classroom,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: 55,
                decoration: const BoxDecoration(
                  color: ColorsTheme.subjectCardClassroomColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Text(
                  classroom.split('-')[1].substring(0, 3),
                  style: TextStyleTheme.subjectTextStyle,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 20),
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
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 75),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    IconButtonWidget(
                      icon: Icons.report,
                      onPressed: () {},
                      isSelected: false,
                    ),
                    const SizedBox(width: 10),
                    IconButtonWidget(
                      icon: Icons.camera_alt_rounded,
                      onPressed: () {},
                      isSelected: false,
                    ),
                    const SizedBox(width: 10),
                    GroupButton(
                      buttons: const ['close', 'check'],
                      onSelected: (value, index, isSelected) {},
                      buttonBuilder: (selected, value, context) {
                        return
                            // Obx(
                            //   () =>
                            IconButtonWidget(
                          icon: value == 'close' ? Icons.close : Icons.check,
                          onPressed: () {
                            controller.setAssistance(selected, subject.value);
                          },
                          isSelected: controller.hasAssistance(),
                          // ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
