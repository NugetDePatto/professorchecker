import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/utlis/dispose_util.dart';
import '../controllers/recorrido_controller.dart';
import '../widgets/subject_card/icon_button_widget.dart';

class IntervalAdjusterView extends GetView<RecorridoController> {
  const IntervalAdjusterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getSize(25), vertical: getSize(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButtonWidget(
            onPressed: controller.decrementHour,
            icon: Icons.arrow_back_ios_rounded,
            isSelected: false,
            color: ColorsTheme.accentColor,
          ),
          Obx(
            () => Text(
              controller.currentInterval.value,
              style: TextStyle(
                color: ColorsTheme.textColor,
                fontSize: getSize(20),
              ),
            ),
          ),
          IconButtonWidget(
            onPressed: controller.incrementHour,
            icon: Icons.arrow_forward_ios_rounded,
            isSelected: false,
            color: ColorsTheme.accentColor,
          ),
        ],
      ),
    );
  }
}
