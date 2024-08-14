import 'package:checadordeprofesores/app/modules/recorrido/widgets/subject_card/icon_button_widget.dart';
import 'package:checadordeprofesores/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors_theme.dart';

class SubjectCarWidget extends StatelessWidget {
  final String classroom;
  final dynamic subject;
  final bool isLast;

  const SubjectCarWidget({
    super.key,
    required this.classroom,
    required this.subject,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: const BoxDecoration(
            color: ColorsTheme.subjectCardClassroomColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            classroom.split('-')[1].substring(0, 3),
            style: TextStyleTheme.subjectTextStyle,
            overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 10),
              Center(
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButtonWidget(
                          icon: Icons.close,
                          onPressed: () {},
                          isSelected: false,
                        ),
                        const SizedBox(width: 10),
                        IconButtonWidget(
                          icon: Icons.check,
                          onPressed: () {},
                          isSelected: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (!isLast) ...[
                Center(
                  child: Container(
                    height: 2,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
