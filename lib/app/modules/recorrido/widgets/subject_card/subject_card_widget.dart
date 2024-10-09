import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utlis/dispose_util.dart';
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
    final controller = SubjectCardController(subject.value);
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
        padding: EdgeInsets.symmetric(
          horizontal: getSize(15),
        ),
      ),
      onPressed: controller.moreInfoButton,
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
                Container(
                  width: getSize(70),
                ),
                Expanded(
                  child: Obx(
                    () => Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        IconButtonWidget(
                          icon: Icons.report,
                          onPressed: controller.reportButton,
                        ),
                        SizedBox(width: getSize(10)),
                        IconButtonWidget(
                          icon: controller.getHasPicture()
                              ? Icons.photo_camera_back_rounded
                              : Icons.camera_alt_rounded,
                          onPressed: controller.takeAPictureButton,
                          isSelected: controller.getHasPicture(),
                        ),
                        SizedBox(width: getSize(10)),
                        IconButtonWidget(
                          icon: Icons.close,
                          onPressed: () {
                            controller.setAttendance(false);
                          },
                          isSelected: controller.getAttendance(false),
                        ),
                        SizedBox(width: getSize(10)),
                        IconButtonWidget(
                          icon: Icons.check,
                          onPressed: () {
                            controller.setAttendance(true);
                          },
                          isSelected: controller.getAttendance(true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
