import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../controllers/recorrido_controller.dart';
import '../widgets/subject_card/icon_button_widget.dart';

class IntervalAdjusterView extends GetView {
  const IntervalAdjusterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecorridoController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
              style: const TextStyle(
                color: ColorsTheme.textColor,
                fontSize: 20,
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
